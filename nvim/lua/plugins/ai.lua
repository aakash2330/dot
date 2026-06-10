return {
  "ThePrimeagen/99",
  keys = {
    { "<leader>9s", function() require("99").search() end, desc = "99 Search" },
    { "<leader>9o", function() require("99").open() end, desc = "99 Open Last" },
    { "<leader>9x", function() require("99").stop_all_requests() end, desc = "99 Stop Requests" },
    { "<leader>9l", function() require("99").view_logs() end, desc = "99 View Logs" },
    { "<leader>9m", function() require("99.extensions.telescope").select_model() end, desc = "99 Select Model" },
    { "<leader>9p", function() require("99.extensions.telescope").select_provider() end, desc = "99 Select Provider" },
    { "<leader>9v", function() require("99").visual() end, mode = "v", desc = "99 Visual" },
  },
  config = function()
    local _99 = require("99")
    local BaseProvider = _99.Providers.BaseProvider
    local codex_model = "gpt-5.5"

    local function once(fn)
      local called = false
      return function(...)
        if called then
          return
        end
        called = true
        fn(...)
      end
    end

    local CodexProvider = setmetatable({}, { __index = BaseProvider })

    function CodexProvider._build_command(_, _, context)
      local command = {
        "codex",
        "exec",
        "--color",
        "never",
        "-c",
        'model_reasoning_effort="medium"',
        "-c",
        'service_tier="fast"',
        "--sandbox",
        "workspace-write",
        "--skip-git-repo-check",
      }

      if context.model and context.model ~= "" then
        vim.list_extend(command, { "--model", context.model })
      end

      return command
    end

    function CodexProvider._get_provider_name()
      return "CodexProvider"
    end

    function CodexProvider._get_default_model()
      return codex_model
    end

    function CodexProvider.fetch_models(callback)
      callback({ codex_model }, nil)
    end

    function CodexProvider.make_request(self, query, context, observer)
      observer.on_start()

      local logger = context.logger:set_area(self:_get_provider_name())
      logger:debug("make_request", "tmp_file", context.tmp_file)

      local once_complete = once(function(status, text)
        observer.on_complete(status, text)
      end)

      local command = self:_build_command(query, context)
      local extra_args = context._99 and context._99.provider_extra_args or {}
      if #extra_args > 0 then
        vim.list_extend(command, extra_args)
      end
      table.insert(command, "-")
      logger:debug("make_request", "command", command)

      local proc = vim.system(
        command,
        {
          text = true,
          stdin = query,
          stdout = vim.schedule_wrap(function(err, data)
            logger:debug("stdout", "data", data)
            if context:is_cancelled() then
              once_complete("cancelled", "")
              return
            end
            if err and err ~= "" then
              logger:debug("stdout#error", "err", err)
            end
            if not err and data then
              observer.on_stdout(data)
            end
          end),
          stderr = vim.schedule_wrap(function(err, data)
            logger:debug("stderr", "data", data)
            if context:is_cancelled() then
              once_complete("cancelled", "")
              return
            end
            if err and err ~= "" then
              logger:debug("stderr#error", "err", err)
            end
            if not err and data then
              observer.on_stderr(data)
            end
          end),
        },
        vim.schedule_wrap(function(obj)
          if context:is_cancelled() then
            once_complete("cancelled", "")
            logger:debug("on_complete: request has been cancelled")
            return
          end

          local ok, res = self:_retrieve_response(context)
          if obj.code ~= 0 then
            if ok and res ~= "" then
              logger:warn(
                "CodexProvider exited non-zero after writing TEMP_FILE",
                "code",
                obj.code,
                "stderr",
                obj.stderr or ""
              )
              once_complete("success", res)
              return
            end

            local str = string.format(
              "process exit code: %d\nstderr:\n%s\nstdout:\n%s",
              obj.code,
              obj.stderr or "",
              obj.stdout or ""
            )
            once_complete("failed", str)
            logger:error(
              "CodexProvider make_request failed",
              "code",
              obj.code,
              "stderr",
              obj.stderr or "",
              "stdout",
              obj.stdout or ""
            )
            return
          end

          if ok then
            once_complete("success", res)
          else
            once_complete("failed", "unable to retrieve response from temp file")
          end
        end)
      )

      context:_set_process(proc)
    end

    _99.Providers.CodexProvider = CodexProvider

    _99.setup({
      provider = CodexProvider,
      md_files = {
        "AGENTS.md",
        "AGENT.md",
      },
    })
  end,
}

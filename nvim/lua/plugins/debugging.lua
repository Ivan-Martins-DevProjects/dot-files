return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "leoluz/nvim-dap-go",
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("dap-go").setup()

    dap.adapters.coreclr = {
      type = "executable",
      command = "/usr/bin/netcoredbg",
      args = { "--interpreter=vscode" },
    }

    dapui.setup()

    local function get_project_dll()
      return coroutine.create(function(dap_run_co)
        vim.ui.input({ prompt = "Project name", default = "Agiliza.WorkReady.Api" }, function(project_name)
          if not project_name or project_name == "" then
            coroutine.resume(dap_run_co)
            return
          end

          local project_dir = vim.fn.getcwd() .. "/src/" .. project_name
          vim.fn.system("dotnet build " .. project_dir)

          local dll_path = project_dir .. "/bin/Debug/net10.0/" .. project_name .. ".dll"
          coroutine.resume(dap_run_co, dll_path)
        end)
      end)
    end

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Launch .NET Project",
        request = "launch",
        program = get_project_dll,
        cwd = "${workspaceFolder}",
        env = {
          ASPNETCORE_ENVIRONMENT = "Development",
          ASPNETCORE_URLS = "http://localhost:5135",
        },
      },
    }

    dap.adapters.wails = {
      type = "server",
      port = 2345,
      host = "127.0.0.1",
    }

    table.insert(dap.configurations.go, {
      type = "go",
      name = "Launch",
      request = "launch",
      program = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
    })

    table.insert(dap.configurations.go, {
      type = "go",
      name = "Launch test",
      request = "launch",
      mode = "test",
      program = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
    })

    table.insert(dap.configurations.go, {
      type = "wails",
      name = "Wails: Attach",
      request = "attach",
      mode = "remote",
      port = 2345,
      cwd = "${workspaceFolder}",
    })

    table.insert(dap.configurations.go, {
      type = "go",
      name = "Wails: Attach to process",
      request = "attach",
      mode = "local",
      processId = function()
        return vim.fn.input("PID: ")
      end,
      cwd = "${workspaceFolder}",
    })

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<leader>dc", dap.continue, {})
    vim.keymap.set("n", "<leader>du", dapui.toggle, {})
  end,
}

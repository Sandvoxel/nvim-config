return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerToggle", "OverseerRun" },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<CR>", desc = "Run Task (Overseer)" },
    { "<leader>oo", "<cmd>OverseerToggle<CR>", desc = "Toggle Task List (Overseer)" },
  },
  config = function()
    require("overseer").setup({
      strategy = {
        "toggleterm",
        direction = "horizontal",
      },
      task_list = {
        direction = "bottom",
        min_height = 15,
        bindings = {
          ["<CR>"] = "run",
        },
      },
    })

    local overseer = require("overseer")
    local fn = vim.fn
    local is_macos = vim.loop.os_uname().sysname == "Darwin"

    -- Helper to wrap builders and save before running
    local function with_save(builder)
      return function(params)
        vim.cmd("update") -- saves current buffer if modified
        return builder(params)
      end
    end

    local function find_cargo_toml(dir)
      dir = dir or fn.getcwd()
      return vim.fs.find("Cargo.toml", { upward = true, type = "file", path = dir })[1]
    end

    local function cargo_has_bevy(cargo_path)
      if not cargo_path then
        return false
      end
      local ok, lines = pcall(fn.readfile, cargo_path)
      if not ok then
        return false
      end
      for _, line in ipairs(lines) do
        if line:match("%s*bevy%s*=") then
          return true
        end
      end
      return false
    end

    local function bevy_condition(opts)
      if fn.executable("cargo") == 0 then
        return false, 'Command "cargo" not found'
      end
      local dir = opts and opts.dir or fn.getcwd()
      local cargo_toml = find_cargo_toml(dir)
      if not cargo_toml then
        return false, "No Cargo.toml found"
      end
      if not cargo_has_bevy(cargo_toml) then
        return false, "Cargo.toml does not list a bevy dependency"
      end
      return true
    end

    local function normalize_list(value)
      if type(value) == "string" and value ~= "" then
        return vim.split(value, "%s+", { trimempty = true })
      end
      if type(value) == "table" then
        return value
      end
      return {}
    end

    local function build_bevy_run_args(params)
      local args = { "run" }
      if params.release then
        table.insert(args, "--release")
      end
      if params.bin and params.bin ~= "" then
        table.insert(args, "--bin")
        table.insert(args, params.bin)
      elseif params.example and params.example ~= "" then
        table.insert(args, "--example")
        table.insert(args, params.example)
      end

      local features = {}
      local seen = {}
      if params.dynamic_link then
        seen["bevy/dynamic"] = true
        table.insert(features, "bevy/dynamic")
      end
      for _, feature in ipairs(normalize_list(params.additional_features)) do
        if feature ~= "" and not seen[feature] then
          seen[feature] = true
          table.insert(features, feature)
        end
      end
      if #features > 0 then
        table.insert(args, "--features")
        table.insert(args, table.concat(features, ","))
      end

      local run_args = normalize_list(params.run_args)
      if #run_args > 0 then
        table.insert(args, "--")
        vim.list_extend(args, run_args)
      end

      return args
    end

    overseer.register_template({
      name = "Cargo Run",
      builder = with_save(function()
        return {
          cmd = { "cargo" },
          args = { "run" },
          name = "cargo run",
          components = { "default" },
        }
      end),
      condition = {
        filetype = { "rust" },
      },
    })

    overseer.register_template({
      name = "Cargo Test",
      builder = with_save(function()
        return {
          cmd = { "cargo" },
          args = { "test" },
          name = "cargo test",
          components = { "default" },
        }
      end),
      condition = {
        filetype = { "rust" },
      },
    })

    overseer.register_template({
      name = "Bevy: Run Native",
      builder = with_save(function(params)
        params = params or {}
        local run_args = build_bevy_run_args(params)
        local label = "Bevy: Run"
        if params.bin and params.bin ~= "" then
          label = label .. " [bin:" .. params.bin .. "]"
        elseif params.example and params.example ~= "" then
          label = label .. " [example:" .. params.example .. "]"
        end
        if params.release then
          label = label .. " (release)"
        end
        if params.dynamic_link then
          label = label .. " {dynamic}"
        end
        return {
          cmd = { "cargo" },
          args = run_args,
          name = label,
          components = { "default", "unique" },
        }
      end),
      params = {
        release = { type = "boolean", default = false, desc = "Build with --release" },
        dynamic_link = {
          type = "boolean",
          default = is_macos,
          desc = "Enable bevy/dynamic feature (recommended on macOS)",
        },
        additional_features = {
          type = "list",
          delimiter = " ",
          optional = true,
          desc = "Extra cargo features (space separated)",
        },
        bin = { type = "string", optional = true, desc = "Specific binary target" },
        example = { type = "string", optional = true, desc = "Example target" },
        run_args = {
          type = "list",
          delimiter = " ",
          optional = true,
          desc = "Arguments forwarded to the binary after --",
        },
      },
      condition = {
        filetype = { "rust" },
        callback = bevy_condition,
      },
    })

    overseer.register_template({
      name = "Bevy: Cargo Watch",
      builder = with_save(function(params)
        params = params or {}
        local run_args = build_bevy_run_args(params)
        local label = "Bevy: Cargo Watch"
        if params.release then
          label = label .. " (release)"
        end
        local watch_args = { "watch", "-x", table.concat(run_args, " ") }
        return {
          cmd = { "cargo" },
          args = watch_args,
          name = label,
          components = { "default", "unique" },
        }
      end),
      params = {
        release = { type = "boolean", default = false, desc = "Build with --release" },
        dynamic_link = {
          type = "boolean",
          default = is_macos,
          desc = "Enable bevy/dynamic feature (recommended on macOS)",
        },
        additional_features = {
          type = "list",
          delimiter = " ",
          optional = true,
          desc = "Extra cargo features (space separated)",
        },
        bin = { type = "string", optional = true, desc = "Specific binary target" },
        example = { type = "string", optional = true, desc = "Example target" },
        run_args = {
          type = "list",
          delimiter = " ",
          optional = true,
          desc = "Arguments forwarded to the binary after --",
        },
      },
      condition = {
        filetype = { "rust" },
        callback = bevy_condition,
      },
    })

  end,
}

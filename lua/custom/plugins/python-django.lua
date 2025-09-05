-- Python/Django specific configuration
return {
  -- Modern formatting with conform.nvim
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Match your project's pre-commit pipeline: ruff → isort → black
        python = { "ruff_fix", "ruff_format", "isort", "black" },
        json = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      -- Custom formatter configurations to match your project settings
      formatters = {
        black = {
          args = {
            "--line-length", "120",
            "--extend-exclude", ".*migrations.*|.*mod_wsgi-4.9.4.*",
            "-"
          },
        },
        isort = {
          args = {
            "--line-length", "120",
            "--multi-line", "3",
            "--profile", "black",
            "--skip-glob", "*migrations*",
            "--skip-glob", "mod_wsgi-4.9.4*",
            "-"
          },
        },
        ruff_fix = {
          args = {
            "--line-length", "120",
            "--fix",
            "--extend-exclude", ".*migrations.*,.*mod_wsgi-4.9.4.*",
            "-"
          },
        },
        ruff_format = {
          args = {
            "--line-length", "120",
            "--extend-exclude", ".*migrations.*,.*mod_wsgi-4.9.4.*",
            "format",
            "-"
          },
        },
      },
      format_on_save = {
        timeout_ms = 1000, -- Increased timeout for multiple formatters
        lsp_fallback = true,
      },
      -- Custom keymaps for formatting
      keys = {
        {
          "<leader>f",
          function()
            require("conform").format({ async = true, lsp_fallback = true })
          end,
          mode = "",
          desc = "Format buffer",
        },
      },
    },
  },

  -- Enhanced Python syntax and Django template support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure Python and other relevant parsers are installed
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "python",
        "html",
        "htmldjango", -- Django templates
        "sql",
        "yaml",
        "toml",
        "json",
        "dockerfile",
      })
    end,
  },

  -- Better Django template support
  {
    "amadeus/vim-xml",
    ft = { "xml", "html", "htmldjango" },
  },

  -- Python-specific text objects and better navigation
  {
    "jeetsukumaran/vim-pythonsense",
    ft = "python",
  },

  -- Testing support for pytest
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Use pytest as the runner
          runner = "pytest",
          -- Arguments for pytest (matching your pytest.ini_options)
          args = { "--reuse-db", "--tb=short" },
          -- Use the correct Python interpreter
          python = function()
            -- Try to use poetry's python first
            local handle = io.popen("poetry env info --path 2>/dev/null")
            if handle then
              local result = handle:read("*a")
              handle:close()
              if result and result ~= "" then
                return vim.trim(result) .. "/bin/python"
              end
            end
            -- Fallback to system python
            return "python"
          end,
        },
      },
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end,                   desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run test file" },
      { "<leader>to", function() require("neotest").output.open() end,               desc = "Show test output" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,            desc = "Toggle test summary" },
    },
  },

  -- Enhanced LSP configuration for Python
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- Auto-detect virtual environment
          before_init = function(_, config)
            local util = require("lspconfig.util")
            local path = util.path

            -- Function to get Python path
            local function get_python_path(workspace)
              -- Use poetry if available
              if path.is_file(path.join(workspace, "pyproject.toml")) then
                local handle = io.popen("cd " .. workspace .. " && poetry env info --path 2>/dev/null")
                if handle then
                  local result = handle:read("*a")
                  handle:close()
                  if result and result ~= "" then
                    local venv_path = vim.trim(result)
                    local python_path = path.join(venv_path, "bin", "python")
                    if path.is_file(python_path) then
                      return python_path
                    end
                  end
                end
              end

              -- Fallback to system python
              return "python"
            end

            config.settings.python.pythonPath = get_python_path(config.root_dir)
          end,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
              },
            },
          },
        },
      },
    },
  },
}

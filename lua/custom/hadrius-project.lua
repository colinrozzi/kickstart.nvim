-- Project-specific configuration for Hadrius backend
-- This file can contain project-specific settings, keymaps, and configurations

-- Detect if we're in the Hadrius project
local function is_hadrius_project()
  local cwd = vim.fn.getcwd()
  return string.find(cwd, "hadrius_backend") ~= nil
end

-- Only apply these settings if we're in the Hadrius project
if is_hadrius_project() then
  -- Set project-specific Python path for LSP
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "pyright" then
        -- Try to use poetry python if available
        local handle = io.popen("poetry env info --path 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          if result and result ~= "" then
            local venv_path = vim.trim(result)
            client.config.settings.python.pythonPath = venv_path .. "/bin/python"
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
        end
      end
    end
  })
  
  -- Project-specific keymaps
  vim.keymap.set('n', '<leader>pm', ':!cd hadrius && python manage.py makemigrations<CR>', 
    { desc = '[P]roject [M]akemigrations' })
  vim.keymap.set('n', '<leader>pi', ':!cd hadrius && python manage.py migrate<CR>', 
    { desc = '[P]roject M[i]grate' })
  vim.keymap.set('n', '<leader>pc', ':!cd hadrius && python manage.py collectstatic --noinput<CR>', 
    { desc = '[P]roject [C]ollectstatic' })
  
  -- Quick access to common Django files
  vim.keymap.set('n', '<leader>ps', ':edit hadrius/hadrius/settings.py<CR>', 
    { desc = '[P]roject [S]ettings' })
  vim.keymap.set('n', '<leader>pu', ':edit hadrius/hadrius/urls.py<CR>', 
    { desc = '[P]roject [U]rls' })
    
  -- Set up Django-specific file associations
  vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*/templates/*.html",
    command = "set filetype=htmldjango"
  })
  
  -- Set working directory to project root when opening Python files
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.py",
    callback = function()
      local file_dir = vim.fn.expand("%:p:h")
      if string.find(file_dir, "hadrius_backend") then
        local project_root = string.match(file_dir, "(.*hadrius_backend)")
        if project_root and vim.fn.getcwd() ~= project_root then
          vim.cmd("cd " .. project_root)
        end
      end
    end
  })
end

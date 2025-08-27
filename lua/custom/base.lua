-- Custom base configuration

-- Load project-specific configuration
require('custom.hadrius-project')

-- Set tab settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Copilot keymaps
vim.keymap.set('n', '<leader>cpd', ':Copilot disable<CR>', { desc = '[C]opilot [D]isable', silent = true })
vim.keymap.set('n', '<leader>cpe', ':Copilot enable<CR>', { desc = '[C]opilot [E]nable', silent = true })
vim.keymap.set('n', '<leader>cpt', ':Copilot toggle<CR>', { desc = '[C]opilot [T]oggle', silent = true })
vim.keymap.set('n', '<leader>cps', ':Copilot status<CR>', { desc = '[C]opilot [S]tatus', silent = true })

-- Python-specific settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    -- Set Python-specific options
    vim.opt_local.textwidth = 120
  end,
})

-- Django-specific keymaps and settings
vim.keymap.set('n', '<leader>dm', function()
  require('telescope.builtin').find_files({
    search_dirs = { 'hadrius' },
    find_command = { 'find', '.', '-name', 'models.py', '-type', 'f' }
  })
end, { desc = '[D]jango [M]odels' })

vim.keymap.set('n', '<leader>dv', function()
  require('telescope.builtin').find_files({
    search_dirs = { 'hadrius' },
    find_command = { 'find', '.', '-name', 'views.py', '-type', 'f' }
  })
end, { desc = '[D]jango [V]iews' })

vim.keymap.set('n', '<leader>du', function()
  require('telescope.builtin').find_files({
    search_dirs = { 'hadrius' },
    find_command = { 'find', '.', '-name', 'urls.py', '-type', 'f' }
  })
end, { desc = '[D]jango [U]rls' })

-- Quick access to manage.py commands
vim.keymap.set('n', '<leader>dr', ':!cd ' .. vim.fn.getcwd() .. '/hadrius && python manage.py runserver<CR>', 
  { desc = '[D]jango [R]unserver' })
vim.keymap.set('n', '<leader>ds', ':!cd ' .. vim.fn.getcwd() .. '/hadrius && python manage.py shell<CR>', 
  { desc = '[D]jango [S]hell' })
vim.keymap.set('n', '<leader>dt', ':!cd ' .. vim.fn.getcwd() .. '/hadrius && python manage.py test<CR>', 
  { desc = '[D]jango [T]est' })

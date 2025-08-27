# Neovim Configuration with GitHub Copilot

This configuration extends kickstart.nvim with GitHub Copilot support and custom settings.

## Added Features

### GitHub Copilot
- **Plugin**: `zbirenbaum/copilot.lua` (modern Lua-based implementation)
- **Integration**: `zbirenbaum/copilot-cmp` (integrates with nvim-cmp)
- **Setup**: Copilot suggestions appear in your completion menu alongside LSP suggestions

### Key Mappings

#### Copilot Controls
- `<leader>cpd` - Disable Copilot
- `<leader>cpe` - Enable Copilot  
- `<leader>cpt` - Toggle Copilot
- `<leader>cps` - Show Copilot status

#### File Explorer (Neo-tree)
- `\` - Toggle file explorer

### Custom Settings
- **Indentation**: 4 spaces (defined in `lua/custom/base.lua`)
- **Theme**: OneDark
- **Autoformatting**: Enabled by default

## Setup Instructions

1. **First time setup**: After installing, run `:Copilot auth` to authenticate with GitHub
2. **Check status**: Use `<leader>cps` to see if Copilot is working
3. **Usage**: Start typing and Copilot suggestions will appear in your completion menu

## File Structure
```
~/.config/nvim/
├── init.lua                    # Main configuration
├── lua/custom/
│   ├── base.lua               # Custom settings and keymaps
│   └── plugins/
│       ├── init.lua           # Neo-tree file explorer
│       └── copilot.lua        # GitHub Copilot configuration
└── lua/kickstart/
    └── plugins/
        └── autoformat.lua     # Auto-formatting on save
```

## Prerequisites for Copilot
- Active GitHub Copilot subscription
- Node.js (v20 or higher)
- Internet connection for authentication and suggestions

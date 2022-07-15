local M = {}

function M.setup()
  -- vim.g.loaded_python3_provider = 0
  vim.g.python3_host_prog = "/bin/python3"
  vim.g.neovide_refresh_rate = 144

  vim.g.format_on_save = true
  vim.g.user_emmet_leader_key = ","
  vim.g.user_emmet_install_global = 0
  vim.g.mapleader = " "

  -----------------------------------------------------------
  -- Encodings
  -----------------------------------------------------------
  vim.opt.encoding = "utf-8"
  vim.opt.fileencoding = "utf-8"
  vim.opt.fileencodings = "utf-8"

  -----------------------------------------------------------
  -- General
  -----------------------------------------------------------
  vim.opt.guifont = "monospace:h11"
  vim.opt.mouse = "a"
  vim.opt.swapfile = false
  vim.opt.clipboard = "unnamedplus"
  vim.opt.backspace = "indent,eol,start"
  vim.opt.signcolumn = "yes:2"
  vim.opt.compatible = false
  vim.opt.completeopt = "menuone,noinsert,noselect"
  vim.opt.confirm = true
  vim.opt.title = true
  vim.opt.showbreak = "⮡   "
  vim.opt.listchars = { space = "·", eol = "⮠" }
  vim.opt.fillchars:append({ horiz = "─", vert = "│", eob = " ", fold = " ", diff = "╱" })

  -----------------------------------------------------------
  -- UI
  -----------------------------------------------------------
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.cursorline = true
  vim.opt.cursorlineopt = "number"
  vim.opt.showmatch = true
  vim.opt.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
  vim.opt.foldlevel = 99
  vim.opt.termguicolors = true
  vim.opt.wrap = true
  vim.opt.scrolloff = 5
  vim.opt.sidescroll = 1
  vim.opt.sidescrolloff = 5
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.laststatus = 3
  vim.opt.background = "dark"
  vim.opt.showtabline = 0
  vim.opt.cmdheight = 0

  -----------------------------------------------------------
  -- Search
  -----------------------------------------------------------
  vim.opt.hlsearch = true
  vim.opt.incsearch = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -----------------------------------------------------------
  -- Tabs
  -----------------------------------------------------------
  vim.opt.expandtab = true
  vim.opt.shiftwidth = 4
  vim.opt.tabstop = 4
  vim.opt.smartindent = true

  -----------------------------------------------------------
  -- Memory, CPU
  -----------------------------------------------------------
  vim.opt.hidden = true
  vim.opt.history = 100
  vim.opt.lazyredraw = true
  vim.opt.synmaxcol = 240
  vim.opt.updatetime = 700 -- ms to wait for trigger an event
  vim.opt.shortmess:append("sI")
  vim.opt.whichwrap:append("<>[]hl")

  local default_plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
  }

  for _, plugin in pairs(default_plugins) do
    vim.g["loaded_" .. plugin] = 1
  end

  vim.schedule(function()
    vim.opt.shadafile = vim.fn.expand("$HOME") .. "/.local/share/nvim/shada/main.shada"
    vim.cmd([[ silent! rsh ]])
  end)
end

return M

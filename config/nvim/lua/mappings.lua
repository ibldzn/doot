local M = {}

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.setup()
  local wk_ok, wk = pcall(require, "which-key")
  local map = vim.keymap.set

  if not wk_ok then
    vim.notify("which-key isn't installed", vim.log.levels.ERROR)
    return
  end

  map("n", "j", "gj", { noremap = true })
  map("n", "gj", "j", { noremap = true })
  map("n", "k", "gk", { noremap = true })
  map("n", "gk", "k", { noremap = true })
  map("n", "dd", function()
    return vim.api.nvim_get_current_line():match("^%s*$") and '"_dd' or "dd"
  end, { noremap = true, expr = true, desc = "Smart dd" })

  wk.register({
    ["S"] = {
      name = "Split",
      ["H"] = { "<C-w>t<C-w>K", "Vertical to horizontal" },
      ["V"] = { "<C-w>t<C-w>H", "Horizontal to vertical" },
      ["h"] = { vim.cmd.split, "Horizontal" },
      ["v"] = { vim.cmd.vsplit, "Vertical" },
    },
    ["<Tab>"] = { vim.cmd.bnext, "Next buffer" },
    ["<S-Tab>"] = { vim.cmd.bprev, "Previous buffer" },
    ["<C-s>"] = { vim.cmd.write, "Save file" },
    ["<C-q>"] = { "<C-w>q", "Close window" },
    ["<C-d>"] = { "<C-d>zz", "Scroll down" },
    ["<C-u>"] = { "<C-u>zz", "Scroll up" },
    ["n"] = { "nzzzv", "Next search occurence" },
    ["N"] = { "Nzzzv", "Next search occurence" },
    ["<C-t>"] = { vim.cmd.terminal, "Open terminal" },
    ["<Esc>"] = { vim.cmd.nohl, "Clear search highlights" },
    ["<leader>"] = {
      ["q"] = { ":bd!<CR>", "Delete current buffer" },
      ["Q"] = { ":%bd|e#|bd#<CR>", "Delete all buffer except current one" },
      ["<leader>"] = { "<C-^>", "Goto previous buffer" },
      ["t"] = {
        name = "Toggle",
        ["f"] = {
          function()
            vim.g.format_on_save = not vim.g.format_on_save
            vim.notify(vim.g.format_on_save and "Formatting enabled" or "Formatting disabled")
          end,
          "Formatting",
        },
        ["l"] = { ":set list!<CR>", "Listchars" },
        ["s"] = { ":set spell!<CR>", "Spelling" },
        ["w"] = { ":set wrap!<CR>", "Wrapping" },
      },
    },
    ["gx"] = {
      function()
        -- Basic URL opener
        local url =
          string.match(vim.fn.expand("<cfile>"), "https?://[%w-_%.%?%.:/%+=&]+[^ >\"',;`]*")
        if url ~= nil then
          if vim.fn.has("mac") == 1 then
            vim.fn.jobstart({ "open", url }, { detach = true })
          elseif vim.fn.has("unix") == 1 then
            vim.fn.jobstart({ "xdg-open", url }, { detach = true })
          else
            vim.notify("url_opener doesn't work on this OS", vim.log.levels.ERROR)
          end
        else
          vim.notify("No URL under the cursor", vim.log.levels.ERROR)
        end
      end,
      "Open URL under the cursor",
    },
  })

  wk.register({
    ["<C-s>"] = { "<Esc>:w<CR>a", "Save file" },

    ["<C-r>"] = { "<C-r><C-o>", 'Insert register "literally"' },
    ["<C-v>"] = { "<C-r><C-o>+", "Paste system clipboard" },

    ["<C-a>"] = { "<Esc>^i", "Move to the beginning of the line" },
    ["<C-e>"] = { "<End>", "Move to the end of the line" },

    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },
  }, { mode = "i" })

  wk.register({
    ["<A-u>"] = { "<Esc>:m .-2<CR>==gi", "Move current line up" },
    ["<A-d>"] = { "<Esc>:m .+1<CR>==gi", "Move current line down" },
  }, { mode = "i" })

  wk.register({
    ["<A-u>"] = { ":m .-2<CR>==", "Move current line up" },
    ["<A-d>"] = { ":m .+1<CR>==", "Move current line down" },
  }, { mode = "n" })

  wk.register({
    ["<C-c>"] = { '"+y', "Copy to system clipboard" },
    ["<A-u>"] = { ":m'<-2<CR>gv=gv", "Move current line up" },
    ["<A-d>"] = { ":m'>+1<CR>gv=gv", "Move current line down" },
    ["<"] = { "<gv", "Un-indent line(s)" },
    [">"] = { ">gv", "Indent line(s)" },
  }, { mode = "v" })

  wk.register({
    -- Do not override register after (p)asting in visual mode, see `:h v_P`
    ["p"] = { "P", "Paste" },
  }, { mode = "x" })

  wk.register({
    ["<C-x>"] = { termcodes("<C-\\><C-N>"), "Escape terminal mode" },
  }, { mode = "t" })
end

return M

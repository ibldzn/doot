local M = {}

local dap = require("dap")
local dap_ui = require("dapui")
local wk = require("which-key")
local util = require("util")
local Hydra = require("hydra")
local shared = require("shared")

local function run_dap(prompt)
  local ft = vim.bo.filetype
  if ft == "" then
    vim.notify(
      "Filetype option is required to determine which dap config to use",
      vim.log.levels.ERROR
    )
    return
  end

  local configs = dap.configurations[ft]
  if configs == nil then
    vim.notify(ft .. " has no dap config", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(configs, {
    prompt = "Select config to run: ",
    format_item = function(cfg)
      return cfg.name
    end,
  }, function(cfg)
    if prompt then
      cfg.args = vim.split(vim.fn.input("args: "), " ")
    end
    dap.run(cfg)
  end)
end

local function setup_bindings()
  local hint = [[
_d_: Launch
_D_: Launch (with args)
_r_: Rerun
_t_: Toggle breakpoint
_u_: Toggle UI
_C_: Continue
_i_: Step into
_o_: Step over
_O_: Step out
_n_: Run to cursor
_T_: Terminate
_e_: Evaluate at cursor
_E_: Evaluate expression
_?_: Evaluate scope
_X_: Clear breakpoints
_J_: Callstack (down)
_K_: Callstack (up)
^
_<Esc>_
]]

  Hydra({
    name = "Debug",
    hint = hint,
    mode = "n",
    body = "<leader>d",
    heads = {
      { "<Esc>", nil, { exit = true, nowait = true } },
      { "d", util.wrap(M.debuggables, false), { desc = "Launch" } },
      { "D", util.wrap(M.debuggables, true), { desc = "Launch (with args)" } },
      { "r", dap.run_last, { desc = "Rerun" } },
      { "t", dap.toggle_breakpoint, { desc = "Toggle breakpoint" } },
      { "u", dap_ui.toggle, { desc = "Toggle UI" } },
      { "C", dap.continue, { desc = "Continue" } },
      { "i", dap.step_into, { desc = "Step into" } },
      { "o", dap.step_over, { desc = "Step over" } },
      { "O", dap.step_out, { desc = "Step out" } },
      { "n", dap.run_to_cursor, { desc = "Run to cursor" } },
      { "X", dap.clear_breakpoints, { desc = "Clear breakpoints" } },
      { "T", dap.terminate, { exit = true, nowait = true, desc = "Terminate" } },
      { "J", dap.down, { desc = "Callstack (down)" } },
      { "K", dap.up, { desc = "Callstack (up)" } },
      {
        "e",
        function()
          dap_ui.eval(nil, { enter = true })
        end,
        { desc = "Evaluate at cursor" },
      },
      {
        "E",
        function()
          dap_ui.eval(vim.fn.input("Expression: "), { enter = true })
        end,
        { desc = "Evaluate expression" },
      },
      {
        "?",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        { exit = true, nowait = true, desc = "exit" },
      },
    },
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        border = shared.window.border,
        position = "bottom-right",
      },
      on_enter = function()
        vim.cmd.mkview()
        vim.cmd("silent! %foldopen!")
        vim.bo.modifiable = false
      end,
      on_exit = function()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd.loadview()
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        vim.cmd.normal("zv")
      end,
    },
  })
end

function M.debuggables(prompt)
  local filetype = vim.bo.filetype
  if filetype == "rust" then
    require("configs.dap.rust").debuggables(prompt)
  else
    run_dap(prompt)
  end
end

function M.setup()
  require("configs.dap.adapters").setup()
  require("configs.dap.configurations").setup()

  vim.fn.sign_define(
    "DapBreakpoint",
    { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" }
  )
  vim.fn.sign_define(
    "DapLogPoint",
    { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" }
  )
  vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })

  dap.listeners.after.event_initialized["dapui_config"] = util.wrap(dap_ui.open, nil)
  dap.listeners.before.event_terminated["dapui_config"] = util.wrap(dap_ui.close, nil)
  dap.listeners.before.event_exited["dapui_config"] = util.wrap(dap_ui.close, nil)

  dap_ui.setup({
    mappings = {
      expand = { "<CR>", "<Tab>" },
    },
    icons = { expanded = "▾", collapsed = "▸" },
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.4 },
          { id = "breakpoints", size = 0.3 },
          { id = "stacks", size = 0.3 },
        },
        size = 40,
        position = "left",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
  })

  setup_bindings()
end

return M

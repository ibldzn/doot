local M = {}

local highlights = function(pal)
  -- stylua: ignore start
  return {
    -- editor
    Normal          = { fg=pal.fg,       bg=pal.bg,                      },
    SignColumn      = {                  bg="none",                      },
    FoldColumn      = {                  bg="none",                      },
    LineNr          = { fg=pal.text3,                                    },
    CursorLineNr    = { fg=pal.text2,                       bold = true  },
    CursorColumn    = {                  bg=pal.ref_text,                },
    FloatBorder     = { fg=pal.surface3, bg=pal.bg,                      },
    Pmenu           = { fg=pal.text2,    bg=pal.surface3,                },
    PmenuSel        = {                  bg=pal.surface2,   bold = true  },
    PmenuSBar       = {                  bg=pal.scrollbg,                },
    PmenuThumb      = {                  bg=pal.scrollfg,                },
    Visual          = {                  bg=pal.texthl1,                 },
    WinSeparator    = { fg=pal.surface1, bg="none",                      },
    StatusLineNC    = { fg="none",       bg="none",                      },

    -- syntax
    Title           = { fg=pal.title,                       bold = true  },
    Comment         = { fg=pal.text3,                                    },
    Constant        = { fg=pal.lpurple,                                  },
    Identifier      = { fg=pal.lblue,                       bold = true  },
    Function        = { fg=pal.lcyan,                       bold = true  },
    Statement       = { fg=pal.lyellow,                                  },
    PreProc         = { fg=pal.preproc,                                  },
    Type            = { fg=pal.type,                                     },
    Special         = { fg=pal.special,                                  },
    Error           = {                  bg=pal.lred,                    },
    Todo            = { fg=pal.todo,     bg="none",         bold = true  },
    Directory       = { fg=pal.lgreen,                                   },
    Search          = { fg=pal.invtext,  bg=pal.lyellow,                 },
    MatchParen      = {                  bg=pal.ref_text,                },
    NonText         = { fg=pal.nontext,                                  },
    Whitespace      = { fg=pal.whitespace,                               },
    Folded          = { fg=pal.folded,   bg=pal.folded_bg,               },
    Conceal         = {                  bg="none"                       },

    -- treesitter
    ["@tag"]           = { fg=pal.lyellow,                      },
    ["@define"]        = { fg=pal.lyellow,                      },
    ["@include"]       = { fg=pal.lyellow,                      },
    ["@preproc"]       = { fg=pal.lyellow,                      },
    ["@property"]      = { fg=pal.lcyan,              bold=true },
    ["@namespace"]     = { fg=pal.preproc,                      },
    ["@storageclass"]  = { fg=pal.lyellow,                      },
    ["@tag.attribute"] = { link="Identifier",                   },
    ["@tag.delimiter"] = { link="Delimiter",                    },

    -- treesitter context
    TreesitterContextLineNumber = { link = "Pmenu" },

    -- cmp
    CmpItemMenuDefault      = { fg=pal.text3,   italic = true  },
    CmpItemKindDefault      = { fg=pal.special, bold = true    },
    CmpItemKindModule       = { fg=pal.preproc, bold = true    },
    CmpItemKindClass        = { fg=pal.type,    bold = true    },
    CmpItemKindStruct       = { fg=pal.type,    bold = true    },
    CmpItemKindInterface    = { fg=pal.type,    bold = true    },
    CmpItemKindTypeParamter = { fg=pal.type,    bold = true    },
    CmpItemKindEnum         = { fg=pal.type,    bold = true    },
    CmpItemKindEnumMember   = { fg=pal.lpurple, bold = true    },
    CmpItemKindConstant     = { fg=pal.lpurple, bold = true    },
    CmpItemKindField        = { fg=pal.lblue,   bold = true    },
    CmpItemKindProperty     = { fg=pal.lblue,   bold = true    },
    CmpItemKindVariable     = { fg=pal.special, bold = true    },
    CmpItemKindFunction     = { fg=pal.lcyan,   bold = true    },
    CmpItemKindMethod       = { fg=pal.lcyan,   bold = true    },
    CmpItemKindConstructor  = { fg=pal.lcyan,   bold = true    },
    CmpItemKindKeyword      = { fg=pal.lyellow, bold = true    },
    CmpItemKindOperator     = { fg=pal.lyellow, bold = true    },

    -- git
    diffAdded       = { fg=pal.diff_a_fg, bg="none",                      },
    diffRemoved     = { fg=pal.diff_d_fg, bg="none",                      },

    DiffAdd         = {                   bg=pal.diff_a_bg,               },
    DiffChange      = {                   bg=pal.diff_c_bg,               },
    DiffDelete      = { fg=pal.diff_d_fg, bg=pal.diff_d_bg,               },
    DiffText        = { fg=pal.text2,     bg=pal.diff_cd_bg, bold = true  },

    -- gitsigns
    GitSignsAdd       = { fg=pal.diff_a_fg  },
    GitSignsChange    = { fg=pal.diff_c_fg  },
    GitSignsDelete    = { fg=pal.diff_d_fg  },
    GitSignsChgDel    = { fg=pal.diff_cd_fg },

    GitSignsAddLn     = { bg=pal.diff_a_bg  },
    GitSignsChangeLn  = { bg=pal.diff_c_bg  },
    GitSignsDeleteLn  = { bg=pal.diff_d_bg  },
    GitSignsChgDelLn  = { bg=pal.diff_cd_bg },

    GitSignsAddNr     = { bg=pal.diff_a_bg  },
    GitSignsChangeNr  = { bg=pal.diff_c_bg  },
    GitSignsDeleteNr  = { bg=pal.diff_d_bg  },
    GitSignsChgDelNr  = { bg=pal.diff_cd_bg },

    -- nvim-tree
    NvimTreeGitDirty      = { fg=pal.dblue    },
    NvimTreeGitDeleted    = { fg=pal.dblue    },
    NvimTreeGitStaged     = { fg=pal.dblue    },
    NvimTreeGitMerge      = { fg=pal.dyellow  },
    NvimTreeGitRenamed    = { fg=pal.dpurple  },
    NvimTreeGitNew        = { fg=pal.dgreen   },
    NvimTreeWinSeparator  = { fg=pal.surface1 },
    NvimTreeRootFolder    = { fg=pal.text2    },

    -- harpoon
    HarpoonWindow = { link = "Pmenu"       },
    HarpoonBorder = { link = "FloatBorder" },

    -- telescope
    FloatTitle             = { fg=pal.text3, bg=pal.surface3 },
    TelescopeResultsNormal = { link = "Pmenu"       },
    TelescopeResultsBorder = { link = "FloatBorder" },
    TelescopeResultsTitle  = { link = "FloatTitle"  },
    TelescopePromptNormal  = { link = "Pmenu"       },
    TelescopePromptBorder  = { link = "FloatBorder" },
    TelescopePromptTitle   = { link = "FloatTitle"  },
    TelescopePreviewNormal = { link = "Pmenu"       },
    TelescopePreviewBorder = { link = "FloatBorder" },
    TelescopePreviewTitle  = { link = "FloatTitle"  },

    -- which-key
    WhichKey       = { fg = pal.special },
    WhichKeyBorder = { fg = pal.surface3 },

    -- indent-blankline
    IndentBlanklineChar      = { fg = pal.whitespace },
    IndentBlanklineSpaceChar = { fg = pal.whitespace },

    -- diagnostics
    InlineDiagnosticTextError  = { fg=pal.lred,    bg=pal.lred_bg    },
    InlineDiagnosticTextWarn   = { fg=pal.lyellow, bg=pal.lyellow_bg },
    InlineDiagnosticTextHint   = { fg=pal.lblue,   bg=pal.lblue_bg   },
    InlineDiagnosticTextInfo   = { fg=pal.lblue,   bg=pal.lblue_bg   },

    DiagnosticVirtualTextError = { fg=pal.lred,                      },
    DiagnosticVirtualTextWarn  = { fg=pal.lyellow,                   },
    DiagnosticVirtualTextHint  = { fg=pal.lblue,                     },
    DiagnosticVirtualTextInfo  = { fg=pal.lblue,                     },

    DiagnosticSignError        = { fg=pal.lred,    bold = true       },
    DiagnosticSignWarn         = { fg=pal.lyellow, bold = true       },
    DiagnosticSignHint         = { fg=pal.lblue,   bold = true       },
    DiagnosticSignInfo         = { fg=pal.lblue,   bold = true       },

    DiagnosticFloatingError    = { fg=pal.lred,                      },
    DiagnosticFloatingWarn     = { fg=pal.lyellow,                   },
    DiagnosticFloatingHint     = { fg=pal.lblue,                     },
    DiagnosticFloatingInfo     = { fg=pal.lblue,                     },

    DiagnosticUnderlineError   = { sp=pal.lred,    undercurl = true  },
    DiagnosticUnderlineWarn    = { sp=pal.lyellow, undercurl = true  },
    DiagnosticUnderlineHint    = { sp=pal.lblue,   undercurl = true  },
    DiagnosticUnderlineInfo    = { sp=pal.lblue,   undercurl = true  },

    -- lsp ocurrences
    LspReferenceText  = { bg=pal.ref_text  },
    LspReferenceRead  = { bg=pal.ref_read  },
    LspReferenceWrite = { bg=pal.ref_write },

    -- dap
    DapBreakpoint = { fg=pal.lred    },
    DapLogPoint   = { fg=pal.lyellow },
    DapStopped    = { fg=pal.lgreen  },

    -- indent-blankline
    IndentBlanklineIndent1     = { fg=pal.lred,    nocombine = true  },
    IndentBlanklineIndent2     = { fg=pal.lyellow, nocombine = true  },
    IndentBlanklineIndent3     = { fg=pal.lblue,   nocombine = true  },
    IndentBlanklineIndent4     = { fg=pal.lcyan,   nocombine = true  },
    IndentBlanklineIndent5     = { fg=pal.lyellow, nocombine = true  },
    IndentBlanklineIndent6     = { fg=pal.lgreen,  nocombine = true  },
    IndentBlanklineContextChar = { fg=pal.todo,    nocombine = true  },
  }
	-- stylua: ignore end
end

local lualine = function(pal)
    -- stylua: ignore start
  return {
    normal = {
      a = { bg=pal.surface1, fg=pal.lyellow, gui="bold" },
      b = { bg=pal.surface2, fg=pal.text2,              },
      c = { bg=pal.surface3, fg=pal.text3,              },
    },
    insert = {
      a = { bg=pal.surface1, fg=pal.lgreen,  gui="bold" },
      b = { bg=pal.surface2, fg=pal.text2,              },
      c = { bg=pal.surface3, fg=pal.text3,              },
    },
    visual = {
      a = { bg=pal.surface1, fg=pal.lpurple, gui="bold" },
      b = { bg=pal.surface2, fg=pal.text2,              },
      c = { bg=pal.surface3, fg=pal.text3,              },
    },
    replace = {
      a = { bg=pal.surface1, fg=pal.lred,    gui="bold" },
      b = { bg=pal.surface2, fg=pal.text2,              },
      c = { bg=pal.surface3, fg=pal.text3,              },
    },
    command = {
      a = { bg=pal.surface1, fg=pal.lblue,   gui="bold" },
      b = { bg=pal.surface2, fg=pal.text2,              },
      c = { bg=pal.surface3, fg=pal.text3,              },
    },
    inactive = {
      a = { bg=pal.surface3, fg=pal.text3,              },
      b = { bg=pal.surface3, fg=pal.text3,              },
      c = { bg=pal.surface3, fg=pal.text3,              },
    }
  }
	-- stylua: ignore end
end

local apply_term_colors = function(pal)
	vim.g.terminal_color_1 = pal.dred
	vim.g.terminal_color_2 = pal.dgreen
	vim.g.terminal_color_3 = pal.dyellow
	vim.g.terminal_color_4 = pal.dblue
	vim.g.terminal_color_5 = pal.dviolet
	vim.g.terminal_color_6 = pal.dcyan

	vim.g.terminal_color_9 = pal.lred
	vim.g.terminal_color_10 = pal.lgreen
	vim.g.terminal_color_11 = pal.lyellow
	vim.g.terminal_color_12 = pal.lblue
	vim.g.terminal_color_13 = pal.lviolet
	vim.g.terminal_color_14 = pal.lcyan
end

local apply_highlights = function(hl)
	vim.o.termguicolors = true

	for group, colors in pairs(hl) do
		vim.api.nvim_set_hl(0, group, colors)
	end
end

M.lualine = lualine
M.highlights = highlights
M.apply_highlights = apply_highlights
M.apply_term_colors = apply_term_colors

return M

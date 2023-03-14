local chars = {
	border_n = "▄",
	border_e = "█",
	border_s = "▀",
	border_w = "█",

	corner_nw = "",
	corner_ne = "",
	corner_se = "",
	corner_sw = "",
}

local icons = {
	modified = "",
	readonly = "",
}

local window_border = {
	chars.corner_nw,
	chars.border_n,
	chars.corner_ne,
	chars.border_e,
	chars.corner_se,
	chars.border_s,
	chars.corner_sw,
	chars.border_w,
}

local plenary_border = {
	chars.border_n,
	chars.border_e,
	chars.border_s,
	chars.border_w,
	chars.corner_nw,
	chars.corner_ne,
	chars.corner_se,
	chars.corner_sw,
}

local M = {
	icons = icons,
	window = {
		border = window_border,
		plenary_border = plenary_border,
	},
}

return M

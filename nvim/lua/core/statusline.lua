local M = {}

-- Helper functions
--- Global function for statusline component rendering. Can be called directly from the statusline
--- @param name string The name of the component to render
--- @param hl string|nil The highlight group to use for the component
--- @return string
function _G._statusline_component(name, hl)
    ---@diagnostic disable-next-line: call-non-callable, need-check-nil
    return M[name](hl)
end

--- Escape statusline control characters in dynamic text
--- @param val string The value to escape
--- @return string
local function esc(val)
    return (tostring(val):gsub("%%", "%%%%"))
end

--- Format a given component value with a highlight group in the format expected by the statusline
--- @param val string The value to format
--- @param hl string|nil The highlight group to use
--- @param l_sep string|nil The left separator to use
--- @param r_sep string|nil The right separator to use
--- @return string
local function format_component(val, hl, l_sep, r_sep)
    l_sep = l_sep or " "
    r_sep = r_sep or " "
    hl = hl or "Comment"
    return l_sep .. "%#" .. hl .. "#" .. val .. "%*" .. r_sep
end

--- Generate a statusline component with optional highlight group
--- @param val string The value to render
--- @param hl string|nil The highlight group to use
--- @return string
local function component(val, hl)
    if val == nil or val == "" then
        return ""
    end

    if hl == nil then
        return "%{%v:lua._statusline_component('" .. val .. "')%}"
    end
    return "%{%v:lua._statusline_component('" .. val .. "', '" .. hl .. "')%}"
end

-- Components
--- Mode component with dynamic highlights
--- @return string
M.mode = function()
    local mode_info = {
        ["n"] = { "NORMAL", "Directory" },
        ["no"] = { "NORMAL", "Directory" },
        ["v"] = { "VISUAL", "Number" },
        ["V"] = { "V-LINE", "Number" },
        ["\22"] = { "V-BLOCK", "Number" },
        ["i"] = { "INSERT", "String" },
        ["c"] = { "COMMAND", "Keyword" },
        ["r"] = { "REPLACE", "Error" },
        ["r?"] = { "CONFIRM", "Error" },
        ["!"] = { "SHELL", "Keyword" },
        ["t"] = { "TERMINAL", "Keyword" },
        ["nt"] = { "TERMINAL", "Keyword" },
    }

    local mode = vim.api.nvim_get_mode().mode
    local info = mode_info[mode]
    local val = info and info[1] or mode:sub(1, 1):upper()
    local hl = info and info[2]
    return format_component(" " .. string.lower(val), hl)
end

--- Git branch component based on CWD - depends on gitsigns.nvim
--- @param hl string|nil The highlight group to use
--- @return string
M.git_branch = function(hl)
    local branch = vim.g.gitsigns_head
    if not branch then
        return ""
    end
    return format_component(" " .. esc(branch), hl)
end

--- Git diff component - current buffer, depends on gitsigns.nvim
--- @param hl string|nil The highlight group to use
--- @return string
M.git_diff = function(hl)
    local summary = vim.b.gitsigns_status
    if not summary or summary == "" then
        return ""
    end

    summary = summary:gsub("+", " ")
    summary = summary:gsub("-", " ")
    summary = summary:gsub("~", " ")

    return format_component(esc(summary), hl)
end

--- Buffer diagnostics component
--- @return string
M.diagnostics = function()
    local counts = vim.diagnostic.count(0)
    local components = {}
    local items = {
        { severity = vim.diagnostic.severity.ERROR, icon = " ", hl = "DiagnosticError" },
        { severity = vim.diagnostic.severity.WARN, icon = " ", hl = "DiagnosticWarn" },
        { severity = vim.diagnostic.severity.HINT, icon = " ", hl = "DiagnosticHint" },
        { severity = vim.diagnostic.severity.INFO, icon = "󰝶 ", hl = "DiagnosticInfo" },
    }

    for _, item in ipairs(items) do
        local count = counts[item.severity]
        if count and count > 0 then
            components[#components + 1] = format_component(item.icon .. count, item.hl, "", "")
        end
    end

    if #components == 0 then
        return ""
    end

    return " " .. table.concat(components, " ") .. " "
end

--- Status messages component. Shows @recording messages.
--- @param hl string|nil The highlight group to use
--- @return string
M.status_messages = function(hl)
    local reg = vim.fn.reg_recording()
    if reg ~= "" then
        return format_component("recording @" .. esc(reg), hl)
    end
    return ""
end

--- Lazy updates component - show pending lazy.nvim updates
--- @param hl string|nil The highlight group to use
--- @return string
M.lazy_updates = function(hl)
    local updates = require("lazy.status").updates()
    if type(updates) == "string" then
        return format_component(esc(updates), hl)
    end
    return ""
end

--- Copilot status component - depends on copilot.lua
--- @return string
M.copilot_status = function()
    local highlights = {
        [""] = "Comment",
        ["Normal"] = "Comment",
        ["Warning"] = "DiagnosticError",
        ["InProgress"] = "DiagnosticWarn",
    }

    local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
    if not (ok and #clients > 0) then
        return ""
    end

    local status = require("copilot.status").data.status
    return format_component(" ", highlights[status])
end

--- Search count component - show current and total search matches when searching a buffer
--- @param hl string|nil The highlight group to use
--- @return string
M.search_count = function(hl)
    if vim.v.hlsearch == 0 then
        return ""
    end

    local ok, s_count = pcall(vim.fn.searchcount, { maxcount = 999 })
    if not ok or s_count.current == nil or s_count.total == 0 then
        return ""
    end

    if s_count.incomplete == 1 then
        return format_component("?/?", hl)
    end

    return format_component(s_count.current .. "/" .. s_count.total, hl)
end

--- File name component - show the current buffer's file name and coloured icon. Depends on mini.icons.
--- @param hl string|nil The highlight group to use
--- @return string
M.file_name = function(hl)
    local ft_overrides = {
        ["copilot-chat"] = { name = "copilot", icon = "󰚩", icon_hl = "MiniIconsAzure" },
        ["grug-far"] = { name = "grug-far", icon = "", icon_hl = "DiagnosticWarn" },
        ["lazy"] = { name = "lazy.nvim", icon = "󰒲", icon_hl = "Directory" },
        ["minifiles"] = { name = "files", icon = "󰝰", icon_hl = "Directory" },
        ["snacks_picker_input"] = { name = "picker", icon = "󰦨", icon_hl = "Changed" },
    }

    local fn_overrides = {
        ["k9s"] = { icon = "󱃾", icon_hl = "Directory" },
        ["lazygit"] = { icon = "", icon_hl = "Changed" },
        ["pi"] = { icon = "󰐀", icon_hl = "MiniIconsAzure" },
        ["zsh"] = { icon = "", icon_hl = "Keyword" },
    }

    local ft = vim.bo.filetype
    local override = ft_overrides[ft]
    if override then
        return format_component(esc(override.icon), override.icon_hl, " ", "")
            .. format_component(esc(override.name), hl)
    end

    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
    if filename == "" then
        filename = vim.bo.buftype ~= "" and ("[" .. vim.bo.buftype .. "]") or "[No Name]"
    end

    local icon, icon_hl = require("mini.icons").get("file", filename)

    -- Override or set custom icons
    if fn_overrides[filename] then
        icon = fn_overrides[filename].icon
        icon_hl = fn_overrides[filename].icon_hl
    end

    local flags = (vim.bo.modified and " [+]" or "") .. (vim.bo.readonly and " [RO]" or "")
    local icon_part = icon and icon ~= "" and format_component(esc(tostring(icon)), icon_hl, " ", "") or ""
    return icon_part .. format_component(esc(filename) .. flags, hl)
end

--- Buffer count component - show the number of other open buffers
--- @param hl string|nil The highlight group to use
--- @return string
M.other_buffers = function(hl)
    local current = vim.api.nvim_get_current_buf()
    local other_bufs = 0

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.bo[buf].buflisted and vim.bo[buf].buftype ~= "nofile" then
            other_bufs = other_bufs + 1
        end
    end

    if other_bufs < 1 then
        return ""
    end
    return format_component("+" .. other_bufs .. " ", hl, "", " ")
end

--- Progress component - show percentage of buffer scrolled
--- @param hl string|nil The highlight group to use
--- @return string
M.progress = function(hl)
    return format_component("%2p%%", hl)
end

--- Line and column component
--- @param hl string|nil The highlight group to use
--- @return string
M.line_col = function(hl)
    return format_component("%l:%c", hl)
end

-- Statusline components
local components = {
    component("mode"),
    component("git_branch", "Changed"),
    component("git_diff", "Type"),
    component("diagnostics"),
    "%=", -- mark end of left alignment
    component("status_messages"),
    component("lazy_updates", "String"),
    component("copilot_status"),
    component("search_count", "Directory"),
    "%<", -- truncate long file names here
    component("file_name", "Normal"),
    component("other_buffers", "Comment"),
    component("progress", "Special"),
    component("line_col", "Changed"),
}

--- Return the statusline as a concatenated string - use with vim.opt.statusline to set
--- @type string
M.statusline = table.concat(components, "")

return M

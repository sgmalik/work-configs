local wezterm             = require 'wezterm'
local config              = wezterm.config_builder()
local act                 = wezterm.action

-- ============================================================
-- COLORS
-- Catppuccin Mocha palette for UI chrome, Tokyo Night for the
-- terminal background — identical to your tmux setup.
-- ============================================================
local C                   = {
    bg        = '#16161e', -- Tokyo Night (tmux status bar bg override)
    term_bg   = '#1a1b26', -- Tokyo Night terminal background
    green     = '#a6e3a1', -- catppuccin mocha green     (workspace name)
    red       = '#f38ba8', -- catppuccin mocha red       (leader active / battery critical)
    maroon    = '#eba0ac', -- catppuccin mocha maroon    (current command)
    blue      = '#89b4fa', -- catppuccin mocha blue      (cwd)
    overlay_0 = '#6c7086', -- catppuccin mocha overlay0  (separators │)
    peach     = '#fab387', -- catppuccin mocha peach     (active tab)
    yellow    = '#f9e2af', -- catppuccin mocha yellow    (zoom indicator)
    pink      = '#f5c2e7', -- catppuccin mocha pink      (battery normal)
    mauve     = '#cba6f7', -- catppuccin mocha mauve     (online status)
    rosewater = '#f5e0dc', -- catppuccin mocha rosewater (inactive tabs)
}

-- ============================================================
-- APPEARANCE
-- ============================================================
config.color_scheme       = 'Tokyo Night'
config.colors             = {
    background = C.term_bg,
    tab_bar    = { background = C.bg },
}

-- Change this to your actual Nerd Font if needed
config.font               = wezterm.font('JetBrains Mono')
config.font_size          = 13.0

config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_padding     = { left = 25, right = 25, top = 8, bottom = 2 }
config.enable_scroll_bar  = false
config.window_frame       = {
    active_titlebar_bg   = C.bg,
    inactive_titlebar_bg = C.bg,
    font                 = wezterm.font('JetBrains Mono'),
    font_size            = 13.0,
}
config.scrollback_lines   = 10000

-- Suppress OS-level window title changes (tmux: set -g set-titles off)
wezterm.on('format-window-title', function() return '' end)

-- ============================================================
-- TAB BAR  (= tmux window list)
-- Retro mode, positioned at the bottom (tmux: status-position bottom)
-- ============================================================
config.use_fancy_tab_bar      = true
config.tab_max_width          = 32
config.status_update_interval = 1000 -- ms, drives update-status below

-- Tab title format:  " #: name "
-- Active  → peach bg, bg-coloured text, bold  (tmux window-status-current-style)
-- Inactive → bg bg, rosewater text            (tmux window-status-style)
--
-- NOTE: tabs are left-aligned in WezTerm retro mode; tmux had absolute-centre.
-- This is the one cosmetic difference that cannot be replicated in retro mode.
wezterm.on('format-tab-title', function(tab, tabs, _, _, _, max_width)
    -- Prefer user-set title (leader+,) over the auto process title
    local title
    if tab.tab_title and tab.tab_title ~= '' then
        title = tab.tab_title
    else
        -- Basename of the foreground process, matching tmux automatic-rename-format
        title = tab.active_pane.title:match('([^/\\]+)[/\\]?$')
            or tab.active_pane.title
    end

    local label = string.format(' %d: %s ', tab.tab_index + 1, title)
    if wezterm.column_width(label) > max_width then
        label = wezterm.truncate_right(label, max_width - 1) .. '…'
    end

    if tab.is_active then
        return {
            { Background = { Color = C.peach } },
            { Foreground = { Color = C.bg } },
            { Attribute = { Intensity = 'Bold' } },
            { Text = label },
        }
    end

    return {
        { Background = { Color = C.bg } },
        { Foreground = { Color = C.rosewater } },
        { Text = label },
    }
end)

-- ============================================================
-- STATUS BAR  (left + right, mirrors your tmux status line exactly)
-- ============================================================
wezterm.on('update-status', function(window, pane)
    -- ── LEFT ──────────────────────────────────────────────────────────────
    local leader_active = window:leader_is_active()
    local workspace     = window:active_workspace()

    local ws_bg         = leader_active and C.red or C.bg
    local ws_fg         = leader_active and C.bg or C.green
    local ws_bold       = leader_active and 'Bold' or 'Normal'

    -- Current working directory, last 3 segments, ~ for $HOME
    local cwd           = ''
    local cwd_obj       = pane:get_current_working_dir()
    if cwd_obj then
        local path = (type(cwd_obj) == 'userdata') and cwd_obj.file_path
            or tostring(cwd_obj)
        path = path:gsub('^' .. (os.getenv('HOME') or ''), '~')
        -- collect segments, keep last 3
        local parts = {}
        for seg in path:gmatch('[^/]+') do table.insert(parts, seg) end
        if #parts >= 3 then
            cwd = parts[#parts - 2] .. '/' .. parts[#parts - 1] .. '/' .. parts[#parts]
        elseif #parts > 0 then
            cwd = path
        end
    end

    local left = {
        -- leading gap (always titlebar bg, never coloured red)
        { Background = { Color = C.bg } },
        { Text = '    ' },
        { Text = '│' },
        -- workspace chip (red bg when leader active)
        { Background = { Color = leader_active and C.red or C.bg } },
        { Foreground = { Color = ws_fg } },
        { Attribute = { Intensity = ws_bold } },
        { Text = '  ' .. workspace .. ' ' },
        -- │
        { Background = { Color = C.bg } },
        { Foreground = { Color = C.overlay_0 } },
        { Text = '│' },
        -- cwd
        { Background = { Color = C.bg } },
        { Foreground = { Color = C.blue } },
        { Text = '  ' .. cwd .. ' │' },
    }

    window:set_left_status(wezterm.format(left))

    local cells = {}

    -- Figure out the hostname of the pane on a best-effort basis
    local hostname = wezterm.hostname()
    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri and cwd_uri.host then
        hostname = cwd_uri.host
    end
    table.insert(cells, ' ' .. hostname)

    -- Format date/time in this style: "Wed Mar 3 08:14"
    local date = wezterm.strftime ' %a %b %-d %H:%M'
    table.insert(cells, date)

    -- Add an entry for each battery (typically 0 or 1)
    local batt_icons = { '', '', '', '', '' }
    for _, b in ipairs(wezterm.battery_info()) do
        local curr_batt_icon = batt_icons[math.ceil(b.state_of_charge * #batt_icons)]
        table.insert(cells, string.format('%s %.0f%%', curr_batt_icon, b.state_of_charge * 100))
    end

    local text_fg = '#c0c0c0'
    local colors = {
        C.bg,
        '#3c1361',
        '#52307c',
        '#663a82',
        '#7c5295',
        '#b491c8',
    }

    local elements = {}
    while #cells > 0 and #colors > 1 do
        local text       = table.remove(cells, 1)
        local prev_color = table.remove(colors, 1)
        local curr_color = colors[1]
        table.insert(elements, { Background = { Color = prev_color } })
        table.insert(elements, { Foreground = { Color = curr_color } })
        table.insert(elements, { Text = '' })
        table.insert(elements, { Background = { Color = curr_color } })
        table.insert(elements, { Foreground = { Color = text_fg } })
        table.insert(elements, { Text = ' ' .. text .. ' ' })
    end
    window:set_right_status(wezterm.format(elements))
end)

-- ============================================================
-- LEADER KEY
-- Karabiner maps:  tap left_command (alone) → Ctrl+B
-- This is your tmux prefix, now the WezTerm leader.
-- Held left_command → Cmd+Ctrl+Opt (super, for yabai) — no conflict.
-- ============================================================
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

-- ============================================================
-- KEY BINDINGS
-- All leader-based, matching your tmux muscle memory exactly.
-- Default WezTerm bindings (Cmd+C/V copy/paste etc.) are kept.
-- ============================================================
config.keys = {

    -- New tab ──── tmux: leader + c
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain'
    },

    -- Rename tab ── tmux: leader + ,
    {
        key = ',',
        mods = 'LEADER',
        action = wezterm.action_callback(function(window, pane)
            local tab = window:active_tab()
            local current = tab:get_title()
            local _, stdout = wezterm.run_child_process({
                'osascript', '-e',
                string.format('display dialog "Rename tab:" default answer "%s" with title "WezTerm"', current)
            })
            local name = stdout:match('text returned:([^,\n]+)')
            if name and name ~= '' then
                tab:set_title(name)
            end
        end)
    },

    -- Jump to tab by number ── tmux: leader + 1-9
    -- (WezTerm is 0-indexed internally; leader+1 → tab index 0, etc.)
    { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
    { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
    { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
    { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
    { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
    { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
    { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
    { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
    { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },

    -- Split right (horizontal pane) ── tmux: leader + |
    -- '|' is Shift+\ on standard keyboards, so SHIFT must be in mods here.
    {
        key = '|',
        mods = 'LEADER|SHIFT',
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },

    -- Split down (vertical pane) ── tmux: leader + -
    {
        key = '-',
        mods = 'LEADER',
        action = act.SplitVertical { domain = 'CurrentPaneDomain' }
    },

    -- Navigate panes ── tmux: leader + h/j/k/l
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

    -- Zoom / maximise pane ── tmux: leader + m
    { key = 'm', mods = 'LEADER', action = act.TogglePaneZoomState },

    -- Close current pane ── leader + x
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },

    -- Copy mode (vim visual selection) ── leader + v
    { key = 'v', mods = 'LEADER', action = act.ActivateCopyMode },
}

return config

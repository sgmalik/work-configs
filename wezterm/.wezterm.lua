local wezterm = require 'wezterm'
local config = {}

-- Use config builder if available (WezTerm 20220807-113146-c2fee766 and later)
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Color scheme - Tokyo Night blue background
config.colors = {
    background = '#1a1b26',  -- Tokyo Night blue
}

-- Optional: Set opacity for a modern look
-- config.window_background_opacity = 0.95

return config

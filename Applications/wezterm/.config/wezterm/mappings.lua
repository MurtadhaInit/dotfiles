local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
    config.keys = {
        -- <<< Wezterm behaviour >>>
        -- CMD + Shift + m: toggle fullscreen for the Wezterm window
        {
            key = 'm',
            mods = 'CMD|SHIFT',
            -- action = wezterm.action.EmitEvent 'window:maximize()'
            action = wezterm.action.ToggleFullScreen -- ideally we want a maximise option
        },
        -- CMD + Shift + n: new Wezterm window
        {
            key = 'n',
            mods = 'CMD|SHIFT',
            action = wezterm.action.SpawnWindow
        },

        -- <<< nvim behaviour >>>
        -- CMD + s: save current buffer (Esc first, in case in insert mode)
        {
            key = 's',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = 'Escape' },
                wezterm.action.SendKey { key = ':' },
                wezterm.action.SendKey { key = 'w' },
                wezterm.action.SendKey { key = 'Enter' },
            }
        },

        -- <<< tmux behaviour >>>
        -- \x02 = control-b (default tmux prefix)
        -- CMD + m: maximise current pane
        {
            key = 'm',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = 'z' },
            }
        },
        -- CMD + t: create a new tmux window
        {
            key = 't',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = 'c' },
            }
        },
        -- CMD + Shift + t: pass prefix + t to invoke tmux-sessionzier
        {
            key = 't',
            mods = 'CMD|SHIFT',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = 't' },
            }
        },
        -- CMD + w: close current pane (close window if it has one pane)
        {
            key = 'w',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = 'x' },
            }
        },
        -- CMD + l: toggle between the two most recent windows
        {
            key = 'l',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = 'l' },
            }
        },
        -- CMD + Shift + l: toggle between the two most recent sessions
        {
            key = 'l',
            mods = 'CMD|SHIFT',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = 'L' },
            }
        },
        -- CMD + k: open session manager
        {
            key = 'k',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = 's' },
            }
        },
        -- CMD + [: enter vi mode (to select and yank)
        {
            key = '[',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '[' },
            }
        },
        -- CMD + Shift + [ or ]: switch to previous or next window
        -- {
        --     key = 'phys:LeftBracket',
        --     mods = 'CMD|SHIFT',
        --     action = wezterm.action.Multiple {
        --         wezterm.action.SendKey { key = '\x02' },
        --         wezterm.action.SendKey { key = 'p' },
        --     }
        -- },
        -- {
        --     key = ']',
        --     mods = 'CMD|SHIFT',
        --     action = wezterm.action.Multiple {
        --         wezterm.action.SendKey { key = '\x02' },
        --         wezterm.action.SendKey { key = 'n' },
        --     }
        -- },
        -- CMD + 1, 2, 3... 9: switch to the window with that number
        {
            key = '1',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '1' },
            }
        },
        {
            key = '2',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '2' },
            }
        },
        {
            key = '3',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '3' },
            }
        },
        {
            key = '4',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '4' },
            }
        },
        {
            key = '5',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '5' },
            }
        },
        {
            key = '6',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '6' },
            }
        },
        {
            key = '7',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '7' },
            }
        },
        {
            key = '8',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '8' },
            }
        },
        {
            key = '9',
            mods = 'CMD',
            action = wezterm.action.Multiple {
                wezterm.action.SendKey { key = '\x02' },
                wezterm.action.SendKey { key = '9' },
            }
        }
    }
end

return module

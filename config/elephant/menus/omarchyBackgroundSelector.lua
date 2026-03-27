#!/usr/bin/env lua

Name = "omarchyBackgroundSelector"
NamePretty = "Background Selector"
Icon = "preferences-desktop-wallpaper"
Cache = false
Action = "romarchy-bg-set '%VALUE%'"
HideFromProviderlist = false
Description = "Select a background wallpaper"
SearchName = true

function GetEntries()
    local entries = {}
    
    -- Get current theme name
    local theme_name = ""
    local theme_file = io.open(os.getenv("HOME") .. "/.local/share/romarchy/.current-theme", "r")
    if theme_file then
        theme_name = theme_file:read("*line")
        theme_file:close()
    end
    
    -- Background directories to search
    local bg_dirs = {
        os.getenv("HOME") .. "/.config/romarchy/backgrounds/" .. theme_name,
        os.getenv("HOME") .. "/.config/romarchy/backgrounds/common",
        os.getenv("HOME") .. "/.local/share/romarchy/themes/" .. theme_name .. "/backgrounds"
    }
    
    -- Image file extensions to look for
    local extensions = {"jpg", "jpeg", "png", "gif", "bmp", "webp"}
    
    -- Scan each directory
    for _, dir in ipairs(bg_dirs) do
        local cmd = "find '" .. dir .. "' -maxdepth 1 -type f 2>/dev/null"
        local handle = io.popen(cmd)
        if handle then
            for line in handle:lines() do
                -- Check if file has image extension
                local ext = line:match("%.([^%.]+)$")
                if ext then
                    ext = ext:lower()
                    local is_image = false
                    for _, valid_ext in ipairs(extensions) do
                        if ext == valid_ext then
                            is_image = true
                            break
                        end
                    end
                    
                    if is_image then
                        local filename = line:match("([^/]+)$")
                        table.insert(entries, {
                            Text = filename,
                            Subtext = dir:match("([^/]+)$"),
                            Value = line,
                            Preview = line,
                            PreviewType = "file",
                            Icon = "image-x-generic"
                        })
                    end
                end
            end
            handle:close()
        end
    end
    
    -- Sort entries by filename
    table.sort(entries, function(a, b) return a.Text < b.Text end)
    
    return entries
end

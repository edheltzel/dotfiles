function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function explode(div, str)
    if (div == '') then
        return false
    end
    local pos, arr = 0, {}
    for st, sp in function()
        return string.find(str, div, pos, true)
    end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

function parse_string_to_table(s)
    local result = {}
    for line in s:gmatch("([^\n]+)") do
        table.insert(result, line)
    end
    return result
end

function get_workspaces()
    local file = io.popen("aerospace list-workspaces --all")
    local result = file:read("*a")
    file:close()

    return parse_string_to_table(result)
end

function get_current_workspace()
    local file = io.popen("aerospace list-workspaces --focused")
    local result = file:read("*a")
    file:close()

    return parse_string_to_table(result)[1]
end

function get_monitors()
    local file = io.popen("aerospace list-monitors | awk '{print $1}'")
    local result = file:read("*a")
    file:close()

    return parse_string_to_table(result)
end

function get_workspaces_on_monitor(monitor)
    local file = io.popen("aerospace list-workspaces --monitor " .. monitor)
    local result = file:read("*a")
    file:close()

    return parse_string_to_table(result, "\n")
end

function get_visible_workspace_on_monitor(monitor)
    local file = io.popen("aerospace list-workspaces --monitor " .. monitor .. " --visible")
    local result = file:read("*a")
    file:close()

    return parse_string_to_table(result)[1]
end

function is_workspace_selected(workspace)
    local available_monitors = get_monitors()
    -- print("Checking: " .. workspace .. " Available monitors: " .. dump(available_monitors))
    for _, monitor in ipairs(available_monitors) do
        local visible_workspace = get_visible_workspace_on_monitor(monitor)
        -- print('types' .. type(visible_workspace) .. ' - ' .. type(workspace))
        -- print("Checking: " .. workspace .. " On Monitor: " .. monitor .. " Result: " .. visible_workspace .. ' - ', (visible_workspace == workspace))
        if visible_workspace == workspace then
            return true
        end
    end

    return false
end

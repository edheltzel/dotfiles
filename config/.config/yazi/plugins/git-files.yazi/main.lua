--- @since 25.5.28

local root = ya.sync(function() return cx.active.current.cwd end)

local function fail(content) return ya.notify { title = "Git files", content = content, timeout = 5, level = "error" } end

local function entry()
    local root = root()
    local git_root_cmd, err = Command("git"):cwd(tostring(root)):arg({ "rev-parse", "--show-toplevel" }):output()
    if err then
        return fail("Failed to run `git rev-parse --show-toplevel`, error: " .. err)
    elseif git_root_cmd and not git_root_cmd.status.success then
        return fail("Failed to run `git rev-parse --show-toplevel`, stderr: " .. git_root_cmd.stderr)
    end

    local git_root_str = git_root_cmd and git_root_cmd.stdout or tostring(root)
    -- trim \n because it's from stdout
    git_root_str = git_root_str:gsub("[\r\n]+", "")

    local git_root = Url(git_root_str)

    ya.dbg("git_root_url", tostring(git_root))
    ya.dbg("root", tostring(root))
    local output, err = Command("git"):cwd(tostring(git_root)):arg({ "status", "--porcelain", "-u" }):output()
    if err then
        return fail("Failed to run `git status --porcelain`, error: " .. err)
    elseif output and not output.status.success then
        return fail("Failed to run `git status --porcelain`, stderr: " .. output.stderr)
    end

    local id = ya.id("ft")
    local cwd = git_root:into_search("Git status files")
    ya.emit("cd", { Url(cwd) })
    ya.emit("update_files", { op = fs.op("part", { id = id, url = Url(cwd), files = {} }) })
    local files = {}
    for line in output.stdout:gmatch("[^\r\n]+") do
        local filename = line:match("..%s(.+)$")
        local url = cwd:join(filename)
        local cha = fs.cha(url, true)
        if cha then
            files[#files + 1] = File { url = url, cha = cha }
        end
    end
    ya.emit("update_files", { op = fs.op("part", { id = id, url = Url(cwd), files = files }) })
    ya.emit("update_files", { op = fs.op("done", { id = id, url = cwd, cha = Cha { kind = 16 } }) })
end

return { entry = entry }

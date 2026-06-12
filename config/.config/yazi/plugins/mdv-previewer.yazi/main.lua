--- @since 25.5.28

local M = {}

local options = ya.sync(function(state, update)
	if update then
		state.theme = update.theme
		state.custom_args = update.custom_args
		state.scroll_step = update.scroll_step
		state.code_theme = update.code_theme
	end
	return {
		theme = state.theme,
		custom_args = state.custom_args,
		scroll_step = state.scroll_step,
		code_theme = state.code_theme,
	}
end)

local emit = ya.emit

local MEM_LIMIT = 4
local MEM = { entries = {}, order = {} }
local LAST = { key = nil, skip = -1, w = 0, h = 0 }
local MDV_VERSION = nil

local function strip_osc8(s)
	return s
		:gsub("\27%]8;.-\7", ""):gsub("\27%]8;.-\27\\", "")
		:gsub("\27%]8;;\7", ""):gsub("\27%]8;;\27\\", "")
		:gsub("\r", "")
end

local function strip_unsupported_args(args)
	if not args[1] then return args end
	local filtered, i = {}, 1
	while i <= #args do
		local token = args[i]
		local drop = token == "-m" or token == "--monitor" or token:match("^%-%-monitor=")
			or token == "-H" or token == "--html" or token:match("^%-%-html=")
		if token == "--monitor" then
			local next_token = args[i + 1]
			if next_token and not next_token:match("^%-") then
				i = i + 1
			end
		end
		if not drop then filtered[#filtered + 1] = token end
		i = i + 1
	end
	return filtered
end

local function normalize_custom_args(input)
	if input == nil then return nil, false end
	if type(input) ~= "table" then return nil, true end

	local args = {}
	for _, value in ipairs(input) do
		if type(value) ~= "string" then return nil, true end
		if value ~= "" then args[#args + 1] = value end
	end

	args = strip_unsupported_args(args)
	return args[1] and args or nil, false
end

local function normalize_scroll_step(value)
	if value == nil then return nil, false end
	if type(value) == "string" then
		local trimmed = value:match("^%s*(.-)%s*$")
		if trimmed == "" then return nil, false end
		if trimmed:lower() == "auto" then return nil, false end
		value = trimmed
	end
	local n = tonumber(value)
	if not n then return nil, true end
	if n <= 0 or math.floor(n) ~= n then return nil, true end
	return math.floor(n), false
end

local function preview_tab_size()
	return (rt.preview and rt.preview.tab_size) or 4
end

local function mdv_version()
	if MDV_VERSION ~= nil then return MDV_VERSION end
	local out = Command("mdv")
		:arg("--version")
		:stdout(Command.PIPED)
		:output()
	MDV_VERSION = out.stdout:match("^%s*(.-)%s*$")
	return MDV_VERSION
end

local function render_variant(job, opts, src)
	opts = opts or {}
	local custom_args = opts.custom_args
	return table.concat({
		tostring(job.area and job.area.w or 0),
		opts.theme or "",
		opts.code_theme or "",
		(custom_args and #custom_args > 0) and table.concat(custom_args, "\0") or "",
		tostring(preview_tab_size()),
		tostring(src and src.mtime or 0),
		tostring(src and src.len or 0),
		mdv_version(),
	}, "\0")
end

local function cache_url(job, opts, src)
	opts = opts or options() or {}
	local base = ya.file_cache({
		file = job.file,
		skip = 0,
	})
	return base and Url(tostring(base) .. "." .. ya.hash(render_variant(job, opts, src)))
end

local function mem_touch(key)
	for i = 1, #MEM.order do
		if MEM.order[i] == key then
			table.remove(MEM.order, i)
			break
		end
	end
	MEM.order[#MEM.order + 1] = key
end

local function mem_get(key)
	local entry = MEM.entries[key]
	if entry then mem_touch(key) end
	return entry
end

local function mem_put(key, entry)
	entry.key = key
	MEM.entries[key] = entry
	mem_touch(key)
	while #MEM.order > MEM_LIMIT do
		local old = table.remove(MEM.order, 1)
		MEM.entries[old] = nil
	end
	return entry
end

local function build_mdv_args(width, theme, code_theme, custom_args)
	local args
	if custom_args and #custom_args > 0 then
		args = {}
		for i = 1, #custom_args do args[i] = custom_args[i] end
	else
		args = {
			"--no-config",
			"-c", tostring(width),
			"-u", "it",
			"-l", "cut",
			"--wrap", "word",
			"--heading-layout", "level",
            "--smart-indent",
            "--table-smart-indent",
			"--callout-style", "pretty:show-icons;fold-icons"
		}
	end

	local has_no_config, has_width, has_theme, has_code_theme = false, false, false, false
	for _, token in ipairs(args) do
		local is_width = token == "-c" or token == "--cols" or token:match("^%-c=") or token:match("^%-%-cols=")
		local is_theme = token == "--theme" or token == "-t" or token:match("^%-%-theme=") or token:match("^%-t=")
		local is_code_theme = token == "--code-theme" or token == "-T"
			or token:match("^%-%-code%-theme=") or token:match("^%-T=")
		if token == "--no-config" then
			has_no_config = true
		elseif not has_width and is_width then
			has_width = true
		elseif not has_theme and is_theme then
			has_theme = true
		elseif not has_code_theme and is_code_theme then
			has_code_theme = true
		end
	end

	if not has_no_config then table.insert(args, 1, "--no-config") end
	if not has_width then
		args[#args + 1] = "-c"
		args[#args + 1] = tostring(width)
	end
	if theme and not has_theme then
		args[#args + 1] = "--theme"
		args[#args + 1] = theme
	end
	if code_theme and not has_code_theme then
		args[#args + 1] = "--code-theme"
		args[#args + 1] = code_theme
	end

	return args
end

local function read_all(path)
	local f = io.open(tostring(path), "rb")
	if not f then return "" end
	local s = f:read("*a") or ""
	f:close()
	return s
end

local function split_lines(blob)
	local lines, i = {}, 0
	for line in (blob .. "\n"):gmatch("([^\n]*)\n") do
		i = i + 1
		lines[i] = line
	end
	return lines, i
end

local function show(job, widget)
	ya.preview_widget({
		area = job.area,
		file = job.file,
		mime = job.mime or "text/plain",
		skip = job.skip or 0,
	}, widget)
end


local function render_to_cache(job, opts)
	opts = opts or options() or {}
	local theme = opts.theme
	local code_theme = opts.code_theme
	local src = fs.cha(job.file.url)
	local cache = cache_url(job, opts, src)
	if not cache then return true end

	local cha = fs.cha(cache)
	if cha and (cha.len > 0 or (src and src.len == 0)) then
		return true
	end

	if src and src.len == 0 then
		return fs.write(cache, "")
	end

	local width = job.area and job.area.w or 0
	local custom_args = opts.custom_args
	local cmd_args = build_mdv_args(width, theme, code_theme, custom_args)
	cmd_args[#cmd_args + 1] = tostring(job.file.url)

	local command = Command("mdv")
	for _, arg in ipairs(cmd_args) do
		command:arg(arg)
	end
	local out, err = command
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not out then
		return true, tostring(err or "mdv: failed to start")
	elseif out.status and not out.status.success then
		local msg = (out.stderr and out.stderr ~= "") and out.stderr or "mdv: rendering error"
		fs.write(cache, msg)
		return true, msg
	end

	local normalized = strip_osc8(out.stdout)
	normalized = normalized:gsub("\t", string.rep(" ", preview_tab_size()))
	return fs.write(cache, normalized)
end

function M:preload(job)
	return render_to_cache(job)
end

function M:load_into_mem(job)
	local function build_prefixes_replay(blob)
		local prefixes, acc, ln = { "" }, {}, 1
		for line in (blob .. "\n"):gmatch("([^\n]*)\n") do
			for params in line:gmatch("\27%[([0-9:;]*)m") do
				local reset = (params == "")
				if not reset then
					for tok in params:gmatch("%d+") do
						if tok == "0" then
							reset = true
							break
						end
					end
				end
				if reset then
					acc = {}
				else
					acc[#acc + 1] = "\27[" .. params .. "m"
				end
			end
			ln = ln + 1
			prefixes[ln] = (#acc > 0) and table.concat(acc) or ""
		end
		return prefixes
	end

	local meta = fs.cha(job.file.url)
	local opts = options() or {}
	local key = table.concat({
		tostring(job.file.url),
		render_variant(job, opts, meta),
	}, "#")

	local cached = mem_get(key)
	if cached then return cached end

	local cache = cache_url(job, opts, meta)
	if not cache then
		return mem_put(key, { lines = { "cache disabled" }, total = 1 })
	end

	local blob = read_all(cache)
	local lines, total = split_lines(blob)
	local prefixes = build_prefixes_replay(blob)

	local function is_visually_blank(s)
		s = strip_osc8(s)
		s = s:gsub("\27%[[0-9:;]*m", "")
		s = s:gsub("[ \t\r]", "")
		return s == ""
	end

	local first = 1
	while first <= total and is_visually_blank(lines[first]) do
		first = first + 1
	end

	local last = total
	while last >= first and is_visually_blank(lines[last]) do
		last = last - 1
	end

	if first > last then
		lines, prefixes, total = {}, prefixes and {}, 0
	else
		local new_len = last - first + 1
		if first > 1 or last < total then
			table.move(lines, first, last, 1, lines)
			for i = new_len + 1, total do lines[i] = nil end
			if prefixes then
				local plen = #prefixes
				table.move(prefixes, first, last, 1, prefixes)
				for i = new_len + 1, plen do prefixes[i] = nil end
			end
		end
		total = new_len
	end

	return mem_put(key, { lines = lines, total = total, prefixes = prefixes })
end

function M:peek(job)
	local area, file = job.area, job.file
	local skip = math.max(0, job.skip or 0)

	local complete, err = self:preload(job)
	if err then
		return show(job, ui.Text(tostring(err)):area(area))
	elseif not complete then
		return
	end

	local mem = self:load_into_mem(job)
	if not mem or mem.total == 0 then
		return show(job, ui.Text.parse("\27[38;2;15;17;26m\27[48;2;143;147;162mEmpty file\27[0m"):area(area))
	end

	local bound = math.max(0, mem.total - area.h)
	local eff_skip = math.min(skip, bound)
	if skip > bound and emit then emit("peek", { bound, only_if = file.url, upper_bound = true }) end
	if LAST.key == mem.key and LAST.skip == eff_skip and LAST.w == area.w and LAST.h == area.h then return end

	local start_line = eff_skip + 1
	local end_line = math.min(mem.total, start_line + area.h - 1)
	local prefix = mem.prefixes and mem.prefixes[start_line] or ""
	show(job, ui.Text.parse(prefix .. table.concat(mem.lines, "\n", start_line, end_line) .. "\27[0m"):area(area))
	LAST.key = mem.key
	LAST.skip = eff_skip
	LAST.w, LAST.h = area.w, area.h
end

function M:seek(job)
	local h = cx.active and cx.active.current and cx.active.current.hovered
	if not (h and h.url == job.file.url and emit) then
		return
	end

	local units = job.units or 0
	if units == 0 then
		return
	end

	local opts = options()
	local configured = opts.scroll_step
	local height = (job.area and job.area.h) or 0
	local step = (configured and configured > 0) and units * configured or math.floor(units * height / 10)
	if step == 0 then step = ya.clamp(-1, units, 1) end
	if step == 0 then return end

	local current_skip = cx.active.preview.skip or 0
	local next_skip = math.max(0, current_skip + step)
	if next_skip ~= current_skip then emit("peek", { next_skip, only_if = job.file.url }) end
end

function M:setup(user)
	user = user or {}
	local theme = user.theme
	if theme == "" then theme = nil end -- Will be removed in newer versions of mdv
	local code_theme = user.code_theme
	local custom_args, invalid_custom_args = normalize_custom_args(user.custom_args)
	local scroll_step, invalid_scroll_step = normalize_scroll_step(user.scroll_step)
	if invalid_custom_args and ya and ya.notify then
		ya.notify {
			title = "mdv previewer",
			content = "Invalid value for `custom_args`",
			timeout = 2,
			level = "warn",
		}
	end
	if invalid_scroll_step and ya and ya.notify then
		ya.notify {
			title = "mdv previewer",
			content = "Invalid value for `scroll_step`",
			timeout = 2,
			level = "warn",
		}
	end
	options({
		theme = theme,
		code_theme = code_theme,
		custom_args = custom_args,
		scroll_step = scroll_step,
	})
end

return M

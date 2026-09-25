local M = {}

local set_config = ya.sync(function(st, opts)
  st.opts = opts
end)

local get_config = ya.sync(function(st)
  return st.opts
    or { --
      text = 'ABCDEF abcdef\n0123456789 \noO08 iIlL1 g9qCGQ\n8%& <([{}])>\n.,;: @#$-_="\n== <= >= != ffi\nâéùïøçÃĒÆœ\n및개요これ直楽糸',
      canvas_size = "750x800",
      font_size = 80,
      fg = "white",
      bg = "black",
    }
end)

local function tbl_strict_extend(default, config)
  if type(default) ~= type(config) then
    return default
  end
  if type(default) ~= "table" then
    if config ~= nil then
      return config
    else
      return default
    end
  end

  for key, _ in pairs(default) do
    default[key] = tbl_strict_extend(default[key], config[key])
  end

  return default
end

function M:setup(config)
  set_config(tbl_strict_extend(get_config(), config))
end

function M:peek(job)
  local start, cache = os.clock(), ya.file_cache(job)
  if not cache then
    return
  end

  local ok, err

  ok, err = self:preload(job)
  if not ok or err then
    return
  end

  ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

  _, err = ya.image_show(cache, job.area)
  ya.preview_widget(job, err and ui.Text(err):area(job.area))
end

-- TODO: change text on seek
function M:seek() end

function M:preload(job)
  local cache = ya.file_cache(job)
  if not cache or fs.cha(cache) then
    return true
  end
  local opts = get_config()

  local status, err = Command("magick"):arg({
    "-size",
    opts.canvas_size,
    "-gravity",
    "center",
    "-font",
    tostring(job.file.path):gsub("\\", "\\\\"),
    "-pointsize",
    opts.font_size,
    "xc:" .. opts.bg,
    "-fill",
    opts.fg,
    "-annotate",
    "+0+0",
    opts.text,
    "PNG:" .. tostring(cache),
  }):status()

  if status then
    return status.success
  else
    return true, Err("Failed to start `magick`, error: %s", err)
  end
end

return M

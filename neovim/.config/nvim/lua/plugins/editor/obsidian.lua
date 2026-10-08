-- Store URL for template substitution (module-level for access in substitutions)
local reading_url = ""
local book_title = ""

-- Fetch Open Graph title from URL (macOS compatible)
local function fetch_og_title(url)
  -- Try og:title first using sed (macOS compatible)
  local handle = io.popen(
    string.format(
      [[curl -sL --max-time 10 "%s" 2>/dev/null | tr '\n' ' ' | sed -n 's/.*<meta[^>]*property="og:title"[^>]*content="\([^"]*\)".*/\1/p' | head -1]],
      url
    )
  )
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and vim.trim(result) ~= "" then
      return vim.trim(result)
    end
  end

  -- Try alternate og:title format (content before property)
  handle = io.popen(
    string.format(
      [[curl -sL --max-time 10 "%s" 2>/dev/null | tr '\n' ' ' | sed -n 's/.*<meta[^>]*content="\([^"]*\)"[^>]*property="og:title".*/\1/p' | head -1]],
      url
    )
  )
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and vim.trim(result) ~= "" then
      return vim.trim(result)
    end
  end

  -- Fallback to <title> tag
  handle = io.popen(
    string.format(
      [[curl -sL --max-time 10 "%s" 2>/dev/null | tr '\n' ' ' | sed -n 's/.*<title>\([^<]*\)<\/title>.*/\1/p' | head -1]],
      url
    )
  )
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and vim.trim(result) ~= "" then
      return vim.trim(result)
    end
  end

  return nil
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    local vault_path = vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱"

    require("obsidian").setup({
      legacy_commands = false,
      -- Use title as filename instead of zettel ID
      note_id_func = function(title)
        if title ~= nil and title ~= "" then
          -- Sanitize title for filename
          return title:gsub('[/\\:*?"<>|]', "-"):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""):gsub("%-+", "-")
        end
        -- Fallback to timestamp if no title
        return tostring(os.time())
      end,
      workspaces = {
        {
          name = "FieldNotes✱",
          path = vault_path,
        },
      },
      daily_notes = {
        folder = "HUB/TheLog",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "New-DailyLog.md",
      },
      templates = {
        folder = "HUB/Attachments/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          yesterday = function()
            return os.date("%Y-%m-%d", os.time() - 86400)
          end,
          tomorrow = function()
            return os.date("%Y-%m-%d", os.time() + 86400)
          end,
          date_long = function()
            return os.date("%A, %B %d, %Y")
          end,
          url = function()
            return reading_url
          end,
          title = function()
            return book_title
          end,
        },
        -- Per-template customizations for directory placement
        -- Keys are matched against the template filename WITHOUT its extension
        customizations = {
          ["New-Reading"] = {
            notes_subdir = "HUB/ReadingList",
          },
          ["New-Book"] = {
            notes_subdir = "HUB/ReadingList",
          },
          ["New-Devotional"] = {
            notes_subdir = "HUB/Devotionals",
          },
        },
      },
    })

    -- Create custom command for URL-based reading notes
    vim.api.nvim_create_user_command("ObsidianNewReading", function()
      vim.ui.input({ prompt = "Enter URL: " }, function(url)
        if not url or url == "" then
          vim.notify("No URL provided", vim.log.levels.WARN)
          return
        end

        -- Store URL for template substitution
        reading_url = url

        vim.notify("Fetching page title...", vim.log.levels.INFO)

        -- Fetch OG title
        local title = fetch_og_title(url)
        if not title then
          vim.notify("Could not fetch title, using domain", vim.log.levels.WARN)
          -- Extract domain as fallback title
          title = url:match("https?://([^/]+)") or url:match("://([^/]+)") or "Reading Note"
        end

        vim.notify("Creating note: " .. title, vim.log.levels.INFO)

        -- Use Obsidian command API for stability across plugin updates
        vim.schedule(function()
          vim.cmd("Obsidian new_from_template '" .. title:gsub("'", "\\'") .. "' 'New-Reading'")
        end)
      end)
    end, { desc = "Create a new reading note from URL" })

    -- Create custom command for book notes
    vim.api.nvim_create_user_command("ObsidianNewBook", function()
      vim.ui.input({ prompt = "Enter book title: " }, function(title)
        if not title or title == "" then
          vim.notify("No title provided", vim.log.levels.WARN)
          return
        end

        -- Store title for template substitution
        book_title = title

        vim.notify("Creating book note: " .. title, vim.log.levels.INFO)

        -- Use Obsidian command API for stability across plugin updates
        vim.schedule(function()
          vim.cmd("Obsidian new_from_template '" .. title:gsub("'", "\\'") .. "' 'New-Book'")
        end)
      end)
    end, { desc = "Create a new book note" })

    -- Which-Key group and keybindings
    local wk = require("which-key")
    wk.add({
      { "<leader>fo", group = "Obsidian", icon = { icon = "󰠮", color = "purple" } },
      { "<leader>fot", ":Obsidian tags ", desc = "Search by tags", icon = { icon = "", color = "orange" } },
      { "<leader>fob", ":Obsidian backlinks<CR>", desc = "Show backlinks", icon = { icon = "⬅", color = "cyan" } },
      {
        "<leader>fo0",
        ":Obsidian open<CR>",
        desc = "Open in Obsidian app",
        icon = { icon = "󱓞", color = "purple" },
      },
      { "<leader>fos", ":Obsidian search<CR>", desc = "Search notes", icon = { icon = "", color = "cyan" } },
      { "<leader>foq", ":Obsidian quick_switch<CR>", desc = "Quick switch", icon = { icon = "⚡", color = "purple" } },
      { "<leader>fol", ":Obsidian link<CR>", desc = "Insert Link", icon = { icon = "", color = "blue" } },
      { "<leader>foL", ":Obsidian link_new ", desc = "Create & Link Note", icon = { icon = "", color = "green" } },
      {
        "<leader>foc",
        ":Obsidian toggle_checkbox<CR>",
        desc = "Toggle checkbox",
        icon = { icon = "", color = "green" },
      },
      {
        "<leader>foNr",
        ":ObsidianNewReading<CR>",
        desc = "Add new read later",
        icon = { icon = "", color = "orange" },
      },
      { "<leader>foNb", ":ObsidianNewBook<CR>", desc = "Add new book", icon = { icon = "󱉟", color = "orange" } },
      { "<leader>foNn", ":Obsidian new ", desc = "New note", icon = { icon = "", color = "blue" } },
      { "<leader>foNt", ":Obsidian today<CR>", desc = "Daily Note for Today", icon = { icon = "󰃶", color = "red" } },
      {
        "<leader>foNm",
        ":Obsidian tomorrow<CR>",
        desc = "Daily Note for Tomorrow",
        icon = { icon = "▶", color = "grey" },
      },
      {
        "<leader>foNy",
        ":Obsidian yesterday<CR>",
        desc = "Daily Note for Yesterday",
        icon = { icon = "◀", color = "grey" },
      },
    })
  end,
}

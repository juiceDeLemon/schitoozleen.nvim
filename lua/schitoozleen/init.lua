-- kinda like how the mini series works
local M = {}
local Schit = {}

--- The git status (changes) component of the schitoozleen
---@return string
function Schit.git_status()
   if not (vim.b.gitsigns_head or vim.b.gitsigns_status_dict) then
      return ""
   end

   -- could've easily used the b.gitsigns_status but it looked disgusting imo
   local dict = vim.b.gitsigns_status_dict
   if dict.added == nil or dict.removed == nil or dict.changed == nil then -- prevent edge case
      return ""
   end
   local added = (dict.added > 0) and "+" .. dict.added or ""
   local removed = (dict.removed > 0) and "-" .. dict.removed or ""
   local changed = (dict.changed > 0) and "~" .. dict.changed or ""
   if added == "" and removed == "" and changed == "" then
      return ""
   end
   return "[" .. added .. removed .. changed .. "]"
end

--- The diagnostics component of the schitoozleen
---@return string
function Schit.diagnostics()
   if not (#vim.diagnostic.get(0) > 0) then
      return ""
   end

   local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
   local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
   local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
   local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
   return "["
      .. (errors > 0 and "E" .. errors or "")
      .. (warnings > 0 and "W" .. warnings or "")
      .. (info > 0 and "I" .. info or "")
      .. (hints > 0 and "H" .. hints or "")
      .. "]"
end

--- The dap status component of the schitoozleen
---@return string
function Schit.dap_status()
   local dap = require "dap"
   if not (dap.session() ~= nil) then
      return ""
   end
   return "[" .. dap.status() .. "]"
end

--- The file_name component of the schitoozleen
---@return string
function Schit.file_name()
   if vim.bo.filetype == "help" then
      local filename = vim.api.nvim_buf_get_name(0)
      return vim.fn.fnamemodify(filename, ":t")
   end
   return "%f"
end

-- stolen from https://github.com/chrisgrieser/.config/nvim/lua/plugins/lualine.lua
local function read_file(path)
   local file, err = io.open(path, "r")
   if not file then
      vim.notify_once("Could not read: " .. err, vim.log.levels.ERROR)
      return false
   end
   local content = file:read "*a"
   file:close()
   return content
end
function Schit.harpoon()
   local harpoon_json_path = vim.fn.stdpath "data" .. "/harpoon.json"
   local file_exists = vim.fn.filereadable(harpoon_json_path) ~= 0
   if not file_exists then
      return ""
   end
   local harpoon_json = read_file(harpoon_json_path)
   if not harpoon_json then
      return ""
   end

   local harpoon_data = vim.json.decode(harpoon_json)
   local pwd = vim.loop.cwd()
   if not pwd or not harpoon_data then
      return ""
   end
   local current_project = harpoon_data.projects[pwd]
   if not current_project then
      return ""
   end
   local marked_file = current_project.mark.marks
   local current_file = vim.fn.expand "%"

   for _, file in pairs(marked_file) do
      if file.filename == current_file then
         return "[harpoon]"
      end
   end

   return "" -- edge case
end

--- The file size component of schitoozleen
--- Stolen from lualine
---@return string
function Schit.file_size()
   local file = vim.fn.expand "%:p"
   if file == nil or #file == 0 then
      return ""
   end
   local size = vim.fn.getfsize(file)
   if size <= 0 then
      return ""
   end

   local suffixes = { "b", "k", "m", "g" }

   local i = 1
   while size > 1024 and i < #suffixes do
      size = size / 1024
      i = i + 1
   end

   local format = i == 1 and "%d%s" or "%.1f%s"
   return "[" .. string.format(format, size, suffixes[i]) .. "]"
end

--- The venv component of the schitoozleen
---@return string
function Schit.venv()
   if not (vim.fn.environ()["VIRTUAL_ENV"] ~= nil) then
      return ""
   end
   return string.sub(vim.fn.environ()["VIRTUAL_ENV_PROMPT"], 1, -2)
end

--- The encoding component of schitoozleen
---@return string
function Schit.encoding()
   local display = vim.opt.fileencoding:get()
   -- "" there is no, utf-8 too common
   return (display == "" or display == "utf-8") and "" or "[" .. display .. "]"
end

--- Setups the schitoozleen
---@param opts table jokes on you. there are no opts
function M.setup(opts)
   _G.Schit = Schit

   vim.opt.laststatus = 3 -- global statusline
   vim.opt.statusline = "[ඞ %{mode()}]" -- mode
      .. "%{v:lua.Schit.git_status()}" -- git
      .. "%{v:lua.Schit.diagnostics()}" -- diagnostics
      .. "%{v:lua.Schit.harpoon()}" -- harpoon
      .. "%{v:lua.Schit.dap_status()}" -- dap status
      .. "%="
      .. Schit.file_name() -- filename
      .. "%m%r%h%w%q" -- flags: m:modified,r:RO,h:help,w:preview,q:quickfix list/loc list
      .. "%="
      .. "%{v:lua.Schit.venv()}" -- venv
      .. "%{v:lua.Schit.file_size()}" -- file_size
      .. "%{v:lua.Schit.encoding()}" -- encoding (inactive if utf-8)
      .. "%y" -- filetype
      .. "[%7(%l/%3L%):%2c %P]" -- ruler
end

return M

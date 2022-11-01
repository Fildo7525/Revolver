local M = {}
local saveDir = vim.fn.stdpath("cache") .. "/revolver/"

local function ignoreLetters( c )
	return (c:gsub("['/']+", ""))
end

--- Get the project name
---
---@return string The project name
M.project = function()
	return ignoreLetters(vim.fn.getcwd()) .. ".list"
end

--- Creates file and the required directories.
---
---@param mode string In which the file should be opened.
---@return file*? Opened file
local function createFile(mode)
	if not vim.fn.isdirectory(saveDir) then
		os.execute("mkdir -p " .. saveDir)
	end
	vim.notify("Creating file " .. saveDir .. M.project(), vim.log.levels.INFO)
	return io.open(saveDir .. M.project(), mode)
end

--- Writes data to a file only if the file exists.
---
---@param file file*? Where to write.
---@param data string What to write.
local function writeFile(file, data)
	if file and vim.fn.filewritable(saveDir) then
		file:write(data .. "\n")
	else
		vim.notify("Could not write \"" .. data .. "\" to a file\n", vim.log.levels.ERROR)
	end
end

-- Read a line from the file. Only if exists.
---
---@param file file*? from where to write
local function readLine(file)
	if file and vim.fn.filereadable(saveDir) then
		return file:read("l")
	else
		vim.notify("Could not read from the " .. saveDir .. " file", vim.log.levels.ERROR)
		return nil
	end
end

--- Saves opened files to a file. Files are representations of projects.
-- If two projects have the same name of the last directory. The newer save overwrites the older one.
---@return table string Table of strings of opened files
M.SaveOpenedFiles = function ()
	local blist = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })
	local file = createFile("w")
	if not file then
		vim.notify("Could not create file " .. saveDir .. M.project(),vim.log.levels.ERROR)
	else
		vim.notify("File created " .. saveDir .. M.project(), vim.log.levels.INFO)
	end
	local result = {}

	for k,item in ipairs(blist) do
		if item.name then
			writeFile(file, item.name)
			result[k] = item.name
		end
	end
	if file ~= nil then
		file:close()
	end
	return result
end

--- Opens the files from the saved file.
---@param deleteAfterLoad boolean Flag controlling whether the reopener file should be deleted after opening the files.
---@return boolean true on success.
M.OpenSavedFiles = function (deleteAfterLoad)
	local file = io.open(saveDir .. M.project(), "r")
	if not file then
		vim.notify("Could not open file " .. saveDir .. M.project(), vim.log.levels.ERROR)
		return false
	end
	local files = 0
	while true do
		local line = readLine(file)
		if not line then
			break
		end
		vim.cmd("e " .. line)
		files = files + 1
	end
	file:close()
	if deleteAfterLoad then
		vim.fn.delete(saveDir .. M.project())
	end
	return true
end

return M


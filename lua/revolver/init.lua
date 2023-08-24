local M = {}
local saveDir = vim.fn.stdpath("cache") .. "/revolver/"

local function ignoreLetters( c )
	return (c:gsub("['/:']+", ""))
end

--- Get the project name
---
---@return string The project name
M.project = function()
	return ignoreLetters(vim.fn.getcwd()) .. ".list"
end

--- Creates file and the required directories.
local function createFile()
	if vim.fn.isdirectory(saveDir) then
		os.execute("mkdir -p " .. saveDir)
	end
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
		error("Could not read from the " .. saveDir .. " file")
		return nil
	end
end

--- Saves opened files to a file. Files are representations of projects.
-- If two projects have the same name of the last directory. The newer save overwrites the older one.
M.SaveOpenedFiles = function ()
	local blist = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })
	createFile()
	vim.cmd("mksession! " .. saveDir .. M.project())
end

--- Opens the files from the saved file.
---@param deleteAfterLoad boolean Flag controlling whether the reopener file should be deleted after opening the files.
---@return boolean true on success.
M.OpenSavedFiles = function (deleteAfterLoad)
	local file = io.open(saveDir .. M.project(), "r")
	if not file then
		error("Could not open file " .. saveDir .. M.project())
		return false
	end
	file:close()

	vim.cmd("source " .. saveDir .. M.project())
	return true
end

return M


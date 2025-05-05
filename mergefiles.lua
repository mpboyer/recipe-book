local lfs = require("lfs")

function inputAllFiles(dirname)
	local path = "Recettes/" .. dirname
	local output = path .. "/main.tmp"
	local out = io.open(output, "w")

	for file in lfs.dir(path) do
		local fullpath = path .. "/" .. file
		if lfs.attributes(fullpath, "mode") == "file" then
			for line in io.lines(fullpath) do
				out:write(line, "\n")
			end
		end
	end

	out:close()
end

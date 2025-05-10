local lfs = require("lfs")

local unit_map = {
	["g"] = "gr",
	["kg"] = "kg",
	["mg"] = "mg",

	["L"] = "Lit",
	["cL"] = "cL",
	["cl"] = "cL",
	["mL"] = "mL",

	["mn"] = "mn",
	["h"] = "hr",

	["°C"] = "celsius",
}

local function format_units(line)
	-- Iterate over the unit_map and replace each unit
	for unit, macro in pairs(unit_map) do
		-- This pattern will match numbers with optional spaces followed by the unit
		local pattern = "(%d+%.?%d*)%s*" .. unit
		line = line:gsub(pattern, function(num)
			return string.format("\\%s{%s}", macro, num)
		end)
	end

	-- Handle ranges: e.g., "30-45mn", "1.5 - 2h"
	line = line:gsub("(%d+%.?%d*)%s*%-+%s*(%d+%.?%d*)%s*(%a+)", function(num1, num2, unit)
		local macro = unit_map[unit]
		if macro then
			return string.format("\\%srange{%s-%s}", macro, num1, num2)
		end
		return line
	end)

	-- Handle compound time like "1h30mn"
	line = line:gsub("(%d+%.?%d*)h(%d%d?)mn", function(h, m)
		return string.format("\\hr{%s}\\mn{%s}", h, m)
	end)

	return line
end

local function format_multiline(s)
	local res = {}
	for line in s:gmatch("[^\n]*\n?") do
		if line ~= "" then
			local formatted = format_units(line)
			table.insert(res, formatted)
		end
	end
	return table.concat(res, "")
end

local function format_recipe(data)
	local formatted = {}

	local unit_fields = { "prep", "cuisson", "four", "frigo", "portions" }
	for _, key in ipairs(unit_fields) do
		if data[key] then
			formatted[key] = format_units(data[key])
		end
	end

	for key, value in pairs(data) do
		if not formatted[key] then
			formatted[key] = value
		end
	end

	if data.ingredients then
		formatted.ingredients = format_multiline(data.ingredients)
	end

	if data.etapes then
		formatted.etapes = format_multiline(data.etapes)
	end

	return formatted
end

local function escape_latex_argument(s)
	if not s then
		return ""
	end
	return s
end

function inputAllFiles(folder)
	local recipeList = {}
	local tex = {}

	for file in lfs.dir("Recettes/" .. folder) do
		if file:match("%.recipe$") then
			local filepath = "Recettes/" .. folder .. "/" .. file
			local chunk, err = loadfile(filepath)
			if not chunk then
				error("Failed to load " .. filepath .. ": " .. err)
			end
			local recipe = chunk()
			table.insert(recipeList, recipe)
		end
	end

	table.sort(recipeList, function(a, b)
		return a.titre:lower() < b.titre:lower()
	end)

	for _, oldr in ipairs(recipeList) do
		r = format_recipe(oldr)
		if r.image ~= nil then
			table.insert(tex, "\\illus{" .. r.image .. "}")
			table.insert(tex, "\\newpage")
			currentImage = r.image
		else
			table.insert(tex, "\\newpage\n \\phantom{.}\n")
		end

		table.insert(
			tex,
			string.format(
				"\\newrecipe{%s}{%s}{%s}{%s}{%s}{%s}{%s}",
				r.titre,
				r.portions or "",
				r.prep or "",
				r.cuisson or "",
				r.four or "",
				r.frigo or "",
				r.robots or ""
			)
		)

		table.insert(
			tex,
			string.format(
				"\\therecipe{%s}{%s}{%s}",
				escape_latex_argument(r.ingredients),
				escape_latex_argument(r.etapes),
				escape_latex_argument(r.note)
			)
		)
	end

	local f = io.open("Recettes/" .. folder .. "/main.tmp", "w")
	f:write(table.concat(tex, "\n\n"))
	f:write("\n")
	f:close()
end

function cleanupTempFile(folder)
	os.remove("Recettes/" .. folder .. "/main.tmp")
end

inputAllFiles("Entrees")

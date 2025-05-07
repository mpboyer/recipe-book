local lfs = require("lfs")

-- Parses time strings like 45mn, 1.5h, 30-45mn, 1h30mn
local function format_unit(s)
	if not s then
		return ""
	end
	s = s:match("^%s*(.-)%s*$") -- trim

	-- Range in mn or h (e.g. 30-45mn, 1.5-2h)
	local num1, num2, unit = s:match("^(%d%.?%d*)%s*%-%s*(%d%.?%d*)(mn|h)$")
	if num1 and num2 and unit then
		return string.format("\\%s{%s-%s}", unit == "mn" and "mn" or "hr", num1, num2)
	end

	-- Separate h and mn (e.g. 1h30mn)
	local h, m = s:match("^(%d%.?%d*)h(%d%d?)mn$")
	if h and m then
		return string.format("\\hr{%s}\\mn{%s}", h, m)
	end

	-- Just mn
	local m_only = s:match("^(%d+%.?%d*)mn$")
	if m_only then
		return "\\mn{" .. m_only .. "}"
	end

	-- Just h
	local h_only = s:match("^(%d+%.?%d*)h$")
	if h_only then
		return "\\hr{" .. h_only .. "}"
	end

	local cels = s:match("^(%d+%.?%d*)°C$")
	if cels then
		return "\\celsius{" .. cels .. "}"
	end

	local gram = s:match("^(%d+%.?%d*)g$")
	if gram then
		return "\\gr{" .. gram .. "}"
	end

	return s -- fallback: unchanged
end

local function escape_latex_argument(s)
	if not s then
		return ""
	end
	return s
end

function inputAllFiles(folder)
	local recipeList = {}

	for file in lfs.dir("Recettes/" .. folder) do
		if file:match("%.recipe$") then
			local chunk = loadfile("Recettes/" .. folder .. "/" .. file)
			local recipe = chunk()
			table.insert(recipeList, recipe)
		end
	end

	table.sort(recipeList, function(a, b)
		return a.titre:lower() < b.titre:lower()
	end)

	-- Build LaTeX
	local tex = {}
	local currentImage = nil

	for _, r in ipairs(recipeList) do
		if r.image ~= currentImage and r.image ~= nil then
			table.insert(tex, "\\illus{" .. r.image .. "}")
			table.insert(tex, "\\newpage")
			currentImage = r.image
		end
		if r.image == nil then
			table.insert(tex, "\\newpage\n \\phantom{.}\n")
		end

		table.insert(
			tex,
			string.format(
				"\\newrecipe{%s}{%s}{%s}{%s}{%s}{%s}{%s}",
				r.titre,
				r.portions or "",
				format_unit(r.prep),
				format_unit(r.cuisson),
				format_unit(r.four),
				format_unit(r.frigo),
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

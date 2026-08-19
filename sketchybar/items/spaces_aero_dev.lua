-- items/aerospace.lua
local colors = require("colors")
local settings = require("settings")
local icons = require("icons")
local app_icons = require("helpers.app_icons")

sbar.add("event", "SPACE_TRIGGER")
local max_workspaces = 10
local workspace_monitor = {}

-- Add padding to the left
sbar.add("item", {
	icon = {
		color = colors.white,
		highlight_color = colors.red,
		drawing = false,
	},
	label = {
		color = colors.grey,
		highlight_color = colors.white,
		drawing = false,
	},
	background = {
		-- color = colors.with_alpha(colors.bg1, colors.transparency),
		color = colors.bg3,
		border_width = 0,
		height = 28,
		border_color = colors.bg3,
		corner_radius = 9,
		drawing = false,
	},
	padding_left = 6,
	padding_right = 0,
})

local workspaces = {}
local empty_workspaces = {}

local wm_adapter = {
	cli = {
		query_workspaces = "aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json",
		query_empty_workspaces = "aerospace list-workspaces --empty --monitor all",
		query_visible_workspaces = "aerospace list-workspaces --visible --monitor all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json",
		query_focused_workspace = "aerospace list-workspaces --focused",
		query_windows = function(workspace_index)
			return string.format("aerospace list-windows --workspace %s --format '%%{app-name}' --json", workspace_index)
		end,
		focus_workspace = function(workspace_index)
			return string.format("aerospace workspace %s", workspace_index)
		end,
	},
}

local function executeShellCommand(command)
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()

	local outputTable = {}
	for line in result:gmatch("[^\r\n]+") do
		table.insert(outputTable, tonumber(line))
	end

	return outputTable
end

function wm_adapter.query_workspaces(callback)
	sbar.exec(wm_adapter.cli.query_workspaces, callback)
end

function wm_adapter.query_empty_workspaces_sync()
	return executeShellCommand(wm_adapter.cli.query_empty_workspaces)
end

function wm_adapter.query_visible_workspaces(callback)
	sbar.exec(wm_adapter.cli.query_visible_workspaces, callback)
end

function wm_adapter.query_focused_workspace(callback)
	sbar.exec(wm_adapter.cli.query_focused_workspace, callback)
end

function wm_adapter.query_windows(workspace_index, callback)
	sbar.exec(wm_adapter.cli.query_windows(workspace_index), callback)
end

function wm_adapter.focus_workspace(workspace_index)
	sbar.exec(wm_adapter.cli.focus_workspace(workspace_index))
end

empty_workspaces_list = wm_adapter.query_empty_workspaces_sync()
-- local max_workspaces_command = "aerospace list-workspaces --count --all"
-- local max_workspaces = executeShellCommand(max_workspaces_command)
-- print("empty_workspaces_list: ", table.concat(max_workspaces, ", "))

local function updateWindows(workspace_index)
	wm_adapter.query_windows(workspace_index, function(open_windows)
		wm_adapter.query_focused_workspace(function(focused_workspaces)
			wm_adapter.query_visible_workspaces(function(visible_workspaces)
				local icon_line = ""
				local no_app = true
				for i, open_window in ipairs(open_windows) do
					no_app = false
					local app = open_window["app-name"]
					local lookup = app_icons[app]
					local icon = ((lookup == nil) and app_icons["Default"] or lookup)
					icon_line = icon_line .. " " .. icon
				end

				sbar.animate("sin", 15, function()
					for i, visible_workspace in ipairs(visible_workspaces) do
						if no_app and workspace_index == tonumber(visible_workspace["workspace"]) then
							local monitor_id = visible_workspace["monitor-appkit-nsscreen-screens-id"]
							icon_line = " —"
							workspaces[workspace_index]:set({
								icon = { drawing = true },
								label = {
									string = icon_line,
									drawing = true,
									-- padding_right = 20,
									font = "sketchybar-app-font:Regular:16.0",
									y_offset = -1,
								},
								background = { drawing = true },
								padding_right = 1,
								padding_left = 1,
								display = monitor_id,
							})
							return
						end
					end

					if no_app and workspace_index ~= tonumber(focused_workspaces) then
						workspaces[workspace_index]:set({
							icon = { drawing = false },
							label = { drawing = false },
							background = { drawing = false },
							padding_right = 0,
							padding_left = 0,
						})
						return
					end
					if no_app and workspace_index == tonumber(focused_workspaces) then
						icon_line = " —"
						workspaces[workspace_index]:set({
							icon = { drawing = true },
							label = {
								string = icon_line,
								drawing = true,
								-- padding_right = 20,
								font = "sketchybar-app-font:Regular:16.0",
								y_offset = -1,
							},
							background = { drawing = true },
							padding_right = 1,
							padding_left = 1,
						})
					end

					workspaces[workspace_index]:set({
						icon = { drawing = true },
						label = { drawing = true, string = icon_line },
						background = { drawing = true },
						padding_right = 1,
						padding_left = 1,
					})
				end)
			end)
		end)
	end)
end

local function updateWorkspaceMonitor(workspace_index)
	wm_adapter.query_workspaces(function(workspaces_and_monitors)
		for _, entry in ipairs(workspaces_and_monitors) do
			local space_index = tonumber(entry.workspace)
			local monitor_id = math.floor(entry["monitor-appkit-nsscreen-screens-id"])
			workspace_monitor[space_index] = monitor_id
		end
		workspaces[workspace_index]:set({
			display = workspace_monitor[workspace_index],
		})
	end)
end

local function isInList(list, element)
	for _, v in ipairs(list) do
		if v == element then
			return true
		end
	end
	return false
end

local function updateWorkspaceHover(workspace_index, trigger)
	if trigger == true then
		sbar.animate("sin", 15, function()
			local icon_line = " —"
			workspaces[workspace_index]:set({
				icon = { drawing = true },
				label = {
					string = icon_line,
					drawing = true,
					font = "sketchybar-app-font:Regular:16.0",
					y_offset = -1,
				},
				background = { drawing = true },
				padding_right = 1,
				padding_left = 1,
			})
		end)
	else
		sbar.animate("sin", 15, function()
			workspaces[workspace_index]:set({
				icon = { drawing = false },
				label = { drawing = false },
				background = { drawing = false },
				padding_right = 0,
				padding_left = 0,
			})
			return
		end)
	end
end

for workspace_index = 1, max_workspaces do
	local workspace = sbar.add("item", {
		icon = {
			color = colors.aerospace_label_color, -- 未聚焦：暗灰
			highlight_color = colors.aerospace_icon_highlight_color, -- 聚焦：亮灰
			drawing = false,
			font = { family = settings.font.numbers },
			string = workspace_index,
			padding_left = 10,
			padding_right = 5,
		},
		label = {
			padding_right = 10,
			color = colors.aerospace_label_color, -- 未聚焦：暗灰
			highlight_color = colors.aerospace_label_highlight_color, -- 聚焦：亮灰
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = -1,
		},
		padding_right = 2,
		padding_left = 2,
		background = {
			color = colors.transparent,
			border_width = 0,
			height = 28,
			border_color = colors.aerospace_border_color,
		},
	})

	workspaces[workspace_index] = workspace

	workspace:subscribe("mouse.clicked", function()
		wm_adapter.focus_workspace(workspace_index)
	end)

	workspace:subscribe("aerospace_workspace_change", function(env)
		local focused_workspace = tonumber(env.FOCUSED_WORKSPACE)
		local is_focused = focused_workspace == workspace_index

		sbar.animate("circ", 15, function()
			workspace:set({
				icon = { highlight = is_focused },
				label = { highlight = is_focused },
				background = {
					-- 聚焦时：显示极微透明白色玻璃底 + 高光白边；非聚焦：完全透明
					color = is_focused and 0x20ffffff or colors.transparent,
					border_width = is_focused and 1 or 0,
					border_color = colors.aerospace_border_color,
				},
				blur_radius = 70,
			})
		end)
	end)

	-- workspace:subscribe("mouse.entered", function()
	-- 	sbar.animate("tanh", 30, function()
	-- 		workspace:set({
	-- 			background = {
	-- 				color = colors.with_alpha(colors.white, 0.15),
	-- 				border_color = colors.with_alpha(colors.white, 0.35),
	-- 			},
	-- 		})
	-- 	end)
	-- end)

	-- workspace:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
	-- 	sbar.animate("tanh", 30, function()
	-- 		workspace:set({
	-- 			background = {
	-- 				color = colors.transparent,
	-- 				height = 28,
	-- 				border_color = colors.aerospace_border_color,
	-- 			},
	-- 		})
	-- 	end)
	-- end)

	workspace:subscribe("SPACE_TRIGGER", function(env)
		local empty_workspaces_list = wm_adapter.query_empty_workspaces_sync()
		-- local trigger_detail = env.detail == "true"
		if env.detail == "true" then
			for _, index_enter in ipairs(empty_workspaces_list) do
				updateWorkspaceHover(index_enter, true)
			end
		elseif env.detail == "false" then
			for _, index_exited in ipairs(empty_workspaces_list) do
				updateWindows(index_exited)
				-- print(index_exited)
				-- updateWorkspaceHover(index_exited, false)
			end
		end
	end)
	--
	-- workspace:subscribe("mouse.exited", function()
	-- 	updateWindows(workspace_index)
	-- end)

	workspace:subscribe("aerospace_focus_change", function()
		updateWindows(workspace_index)
	end)

	workspace:subscribe("display_change", function()
		updateWorkspaceMonitor(workspace_index)
		updateWindows(workspace_index)
	end)

	-- initial setup
	updateWorkspaceMonitor(workspace_index)
	updateWindows(workspace_index)

	wm_adapter.query_focused_workspace(function(focused_workspace)
		sbar.animate("sin", 15, function()
			workspaces[tonumber(focused_workspace)]:set({
				icon = { highlight = true },
				label = { highlight = true },
				background = {
					color = 0x20ffffff,
					border_width = 1,
					border_color = colors.aerospace_border_color,
				},
			})
		end)
	end)
end

return workspaces

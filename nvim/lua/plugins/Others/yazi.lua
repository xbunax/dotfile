return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>-",
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},

		-- {
		--   -- Open in the current working directory
		--   "<leader>cw",
		--   "<cmd>Yazi cwd<cr>",
		--   desc = "Open the file manager in nvim's working directory",
		-- },
		-- {
		--   -- NOTE: this requires a version of yazi that includes
		--   -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
		--   "<c-up>",
		--   "<cmd>Yazi toggle<cr>",
		--   desc = "Resume the last yazi session",
		-- },
	},
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = false,
		keymaps = {
			show_help = "<f1>",
			open_file_in_vertical_split = "<c-v>",
			open_file_in_horizontal_split = "<c-x>",
			open_file_in_tab = "<c-t>",
			grep_in_directory = "<c-s>",
			replace_in_directory = "<c-g>",
			cycle_open_buffers = "<tab>",
			copy_relative_path_to_selected_files = "<c-y>",
			send_to_quickfix_list = "<c-q>",
			change_working_directory = "<c-\\>",
			open_and_pick_window = "<c-o>",
		},
	},
}

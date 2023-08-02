local home = vim.fn.expand("~/docs/zk")
require('telekasten').setup({
	home         = home,
	take_over_my_home = true,
	auto_set_filetype = true,
	auto_set_syntax = true,
	dailies      = home .. '/' .. 'daily',
	weeklies     = home .. '/' .. 'weekly',
	templates    = home .. '/' .. 'templates',
	image_subdir = "img",
	extension    = ".md",
	new_note_filename = "title",
	uuid_type = "%Y%m%d%H%M",
	uuid_sep = "-",
	filename_space_subst = nil,
	follow_creates_nonexisting = true,
	dailies_create_nonexisting = true,
	weeklies_create_nonexisting = true,
	journal_auto_open = false,
	template_new_note = home .. '/' .. 'templates/new_note.md',
	template_new_daily = home .. '/' .. 'templates/daily.md',
	template_new_weekly= home .. '/' .. 'templates/weekly.md',
	image_link_style = "markdown",
	sort = "filename",
	plug_into_calendar = true,
	calendar_opts = {
		weeknm = 4,
		calendar_monday = 1,
		calendar_mark = 'left-fit',
	},
	close_after_yanking = false,
	insert_after_inserting = true,
	tag_notation = "#tag",
	command_palette_theme = "dropdown",
	show_tags_theme = "ivy",
	subdirs_in_links = true,
	template_handling = "smart",
	new_note_location = "smart",
	rename_update_links = true,
	media_previewer = "telescope-media-files",
	follow_url_fallback = nil,
	vaults = {
		Driving = {
			home = home .. "/" .. "Driving",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		SoftwareDesign = {
			home = home .. "/" .. "SoftwareDesign",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		C = {
			home = home .. "/" .. "C",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		businessIT = {
			home = home .. "/" .. "businessIT",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		}
	}
})

vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<cr>")
vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<cr>")
vim.keymap.set("n", "<leader>zN", "<cmd>Telekasten new_templated_note<cr>")
vim.keymap.set("n", "<leader>zT", "<cmd>Telekasten goto_today<cr>")
vim.keymap.set("n", "<leader>zW", "<cmd>Telekasten goto_thisweek<cr>")
vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten find_daily_notes<cr>")
vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<cr>")
vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<cr>")
vim.keymap.set("n", "<leader>zm", "<cmd>Telekasten browse_media<cr>")
vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<cr>")
vim.keymap.set("n", "<leader>zp", "<cmd>Telekasten preview_img<cr>")
vim.keymap.set("n", "<leader>zs", "<cmd>Telekasten switch_vault<cr>")
vim.keymap.set("n", "<leader>zt", "<cmd>Telekasten panel<cr>")
vim.keymap.set("n", "<leader>zw", "<cmd>Telekasten find_weekly_notes<cr>")
vim.keymap.set("n", "<leader>#", "<cmd>Telekasten show_tags<cr>")

local home = vim.fn.expand("~/docs/zk")

require("telekasten").setup({
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
		BusinessEnglish = {
			home = home .. "/" .. "BusinessEnglish",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		DataEssentials = {
			home = home .. "/" .. "DataEssentials",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		SoftwareDesign = {
			home = home .. "/" .. "SoftwareDesign",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		BusinessCommunication = {
			home = home .. "/" .. "BusinessCommunication",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		AIEssentials = {
			home = home .. "/" .. "AIEssentials",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		NETEssentials = {
			home = home .. "/" .. "NETEssentials",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		iTalent = {
			home = home .. "/" .. "iTalent",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		ScalingNetworks = {
			home = home .. "/" .. "ScalingNetworks",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		RoutingSwitchingEssentials = {
			home = home .. "/" .. "RoutingSwitchingEssentials",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		SoftwareDesignAndQualityAssurance = {
			home = home .. "/" .. "SoftwareDesignAndQualityAssurance",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
		C = {
			home = home .. "/" .. "C",
			template_new_note = home .. "/" .. "templates/new_note.md",
			new_note_filename = "title",
		},
	}
})

vim.keymap.set("n", "<leader>z", require("telekasten").panel)
vim.keymap.set("n", "<leader>zb", require("telekasten").show_backlinks)
vim.keymap.set("n", "<leader>zz", require("telekasten").follow_link)
vim.keymap.set("n", "<leader>zN", require("telekasten").new_templated_note)
vim.keymap.set("n", "<leader>zT", require("telekasten").goto_today)
vim.keymap.set("n", "<leader>zW", require("telekasten").goto_thisweek)
vim.keymap.set("n", "<leader>zd", require("telekasten").find_daily_notes)
vim.keymap.set("n", "<leader>zf", require("telekasten").find_notes)
vim.keymap.set("n", "<leader>zg", require("telekasten").search_notes)
vim.keymap.set("n", "<leader>zm", require("telekasten").browse_media)
vim.keymap.set("n", "<leader>zn", require("telekasten").new_note)
vim.keymap.set("n", "<leader>zp", require("telekasten").preview_img)
vim.keymap.set("n", "<leader>zr", require("telekasten").rename_note)
vim.keymap.set("n", "<leader>zs", require("telekasten").switch_vault)
vim.keymap.set("n", "<leader>zS", require("telekasten").search_notes)
vim.keymap.set("n", "<leader>zt", require("telekasten").panel)
vim.keymap.set("n", "<leader>zw", require("telekasten").find_weekly_notes)
vim.keymap.set("n", "<leader>z#", require("telekasten").show_backlinks)

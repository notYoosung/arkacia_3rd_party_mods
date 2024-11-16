local used_minetest_fields = {
  get_modpath = {},
  get_node = {},
  set_node = {},
  remove_node = {},
  register_tool = {},
  register_privilege = {},
  check_player_privs = {},
  privs_to_string = {},
  chat_send_player = {},
  show_formspec = {},
  register_on_player_receive_fields = {},
  is_yes = {},
}

stds.minetest = {
  read_globals = {
    minetest = {
      fields = used_minetest_fields,
    },
	vector = {
	  fields = {
		new = {},
		to_string = {},
		from_string = {},
		add = {},
        subtract = {},
		direction = {},
	  },
	},
  },
}

std = "luajit+minetest"

globals = {
  extruder = {
    other_fields = true,
  },
}

local modname = "extruder"
extruder = {}

local lib = dofile(minetest.get_modpath(modname) .. "/lib.lua")

minetest.register_privilege("extruder")

-- TODO look into integrating with stuff like worldedit undo

local function meta_get_amount(meta)
  return math.max(1, meta:get_int("amount"))
end

local function meta_set_amount(meta, amount)
  if (not amount) or (amount < 1) then amount = 1 end
  meta:set_int("amount", amount)
  return amount
end


local function visit_wrapped(visited, to_visit, direction, neighbors, node_name)
  local pos = table.remove(to_visit)
  while pos do
    if visited[vector.to_string(pos)] == nil then
      local above = vector.add(pos, direction)
      local node = minetest.get_node(pos)
      local node_above = minetest.get_node(above)
      if node.name == "air" or
         node.name == "ignore" or
         node_above.name ~= "air" or
         (node_name and node_name ~= node.name) then
        visited[vector.to_string(pos)] = false
      else
        visited[vector.to_string(pos)] = node
        for _,visit_direction in pairs(neighbors) do
          table.insert(to_visit, vector.add(pos, visit_direction))
        end
      end
    end
    pos = table.remove(to_visit)
  end
end

local function visit(pos, direction, meta)
  local diagonal = lib.meta_get_bool(meta, "diagonal")
  local same_node = lib.meta_get_bool(meta, "same_node")

  local neighbors = lib.get_perpendiculars(direction)
  if diagonal then
    for _,v in ipairs(lib.get_diagonals(direction)) do
      table.insert(neighbors, v)
    end
  end

  local node_name = same_node and minetest.get_node(pos).name or nil

  local visited = {}
  visit_wrapped(visited, {pos}, direction, neighbors, node_name)
  return visited
end

local function extrude(surface, direction, meta, remove)
  local amount = meta_get_amount(meta)
  local overwrite = lib.meta_get_bool(meta, "overwrite")

  -- TODO use VoxelManip (and accumulate two of the bounding coordinates in visit()?)
  -- or at least bulk_set_node
  for pos_str,node in pairs(surface) do
    if node then
      local pos = vector.from_string(pos_str)
      if not remove then pos = vector.add(pos, direction) end
      for _ = 1, amount do
        if remove then
          minetest.remove_node(pos)
          pos = vector.subtract(pos, direction)
        else
          if overwrite or minetest.get_node(pos).name == "air" then
            minetest.set_node(pos, node)
          end
          pos = vector.add(pos, direction)
        end
      end
    end
  end
end

local function use(placer, pointed_thing, meta, remove)
  if placer == nil or pointed_thing == nil or pointed_thing.type ~= "node" then return end
  if not lib.check_privs_with_msg(placer, "extruder") then return end
  local direction = vector.direction(pointed_thing.under, pointed_thing.above)
  local surface = visit(pointed_thing.under, direction, meta)
  -- TODO ask for confirmation if surface is too big (block limit field/checkbox in formspec?)
  -- confirmation can be "click again" (store previous above and under)
  extrude(surface, direction, meta, remove)
end

local settings_formspec = [[
  formspec_version[3]
  size[8,5.2]
  button_exit[0.5,3.9;7,0.8;confirm;Confirm]
  field[0.5,0.7;4,0.8;amount;Extrusion amount;%d]
  checkbox[0.5,2;overwrite;Allow overwriting;%s]
  checkbox[0.5,2.7;diagonal;Select through vertices (diagonally);%s]
  checkbox[0.5,3.4;same_node;Only select nodes of the same type;%s]
]]

minetest.register_tool(modname .. ":extruder", {
  description = "Extruder tool\n" ..
    "Place (right click) to extrude a surface,\n" ..
    "use (left click) to remove a surface,\n" ..
    "right click on air to adjust options.",
  inventory_image = "extruder.png",
  stack_max = 1,
  liquids_pointable = true,

  on_use = function(itemstack, placer, pointed_thing)
    use(placer, pointed_thing, itemstack:get_meta(), true)
  end,
  on_place = function(itemstack, placer, pointed_thing)
    use(placer, pointed_thing, itemstack:get_meta(), false)
  end,

  on_secondary_use = function(itemstack, placer, _)
    local meta = itemstack:get_meta()
    minetest.show_formspec(placer:get_player_name(), modname .. ":settings",
      string.format(settings_formspec,
        meta_get_amount(meta),
        tostring(lib.meta_get_bool(meta, "overwrite")),
        tostring(lib.meta_get_bool(meta, "diagonal")),
        tostring(lib.meta_get_bool(meta, "same_node"))
      )
    )
  end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
  if formname ~= (modname .. ":settings") then return end
  if player == nil then return end
  if not lib.check_privs_with_msg(player, "extruder") then return end

  local inventory = player:get_inventory()
  local wield_index = player:get_wield_index()
  local itemstack = inventory:get_stack("main", wield_index)
  if (not itemstack) or (itemstack:get_name() ~= (modname .. ":extruder")) then return end
  local meta = itemstack:get_meta()

  local amount
  if fields.amount then
    amount = tonumber(fields.amount)
    -- We assign it back because meta_set_amount sanitizes the value too
    amount = meta_set_amount(meta, amount)
  else
    amount = meta_get_amount(meta)
  end

  -- TODO do all the checkboxes in a loop
  local overwrite
  if fields.overwrite then
    overwrite = fields.overwrite == "true"
    lib.meta_set_bool(meta, "overwrite", overwrite)
  else
    overwrite = lib.meta_get_bool(meta, "overwrite")
  end

  local diagonal
  if fields.diagonal then
    diagonal = fields.diagonal == "true"
    lib.meta_set_bool(meta, "diagonal", diagonal)
  else
    diagonal = lib.meta_get_bool(meta, "diagonal")
  end

  local same_node
  if fields.same_node then
    same_node = fields.same_node == "true"
    lib.meta_set_bool(meta, "same_node", same_node)
  else
    same_node = lib.meta_get_bool(meta, "same_node")
  end

  meta:set_string("count_meta", table.concat({
    amount == 1 and "" or tostring(amount),
    overwrite and "!" or "",
    diagonal and "✳" or "",
    same_node and "=" or "",
  }, ""))

  inventory:set_stack("main", wield_index, itemstack)
end)

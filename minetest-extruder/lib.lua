local lib = {}

function lib.check_privs_with_msg(player_or_name, privs)
  local success, missing_privs = minetest.check_player_privs(player_or_name, privs)
  if not success then
    local player_name = type(player_or_name) == "string" and player_or_name or player_or_name:get_player_name()
    minetest.chat_send_player(player_name, "Missing privileges: " .. minetest.privs_to_string(missing_privs))
    return false
  end
  return true
end

-- https://github.com/minetest/minetest/pull/12894
function lib.meta_get_bool(meta, name)
  return minetest.is_yes(meta:get(name) or "true")
end
function lib.meta_set_bool(meta, name, value)
  meta:set_string(name, value and "true" or "false")
end

-- Get the four unit vectors parallel to axes
-- that are perpendicular to a given one (also parallel to an axis)
function lib.get_perpendiculars(vec)
  if vec.x ~= 0 then
    return {
      vector.new(0,  1,  0),
      vector.new(0, -1,  0),
      vector.new(0,  0,  1),
      vector.new(0,  0, -1),
    }
  end
  if vec.y ~= 0 then
    return {
      vector.new( 1, 0,  0),
      vector.new(-1, 0,  0),
      vector.new( 0, 0,  1),
      vector.new( 0, 0, -1),
    }
  end
  -- if vec.z ~= 0 then
  return {
    vector.new( 1,  0, 0),
    vector.new(-1,  0, 0),
    vector.new( 0,  1, 0),
    vector.new( 0, -1, 0),
  }
end

-- Get the four diagonal (wrt axes) "manhattan-unit" vectors
-- perpendicular to a given one (parallel to an axis)
function lib.get_diagonals(vec)
  if vec.x ~= 0 then
    return {
      vector.new(0,  1,  1),
      vector.new(0,  1, -1),
      vector.new(0, -1,  1),
      vector.new(0, -1, -1),
    }
  end
  if vec.y ~= 0 then
    return {
      vector.new( 1, 0,  1),
      vector.new( 1, 0, -1),
      vector.new(-1, 0,  1),
      vector.new(-1, 0, -1),
    }
  end
  -- if vec.z ~= 0 then
  return {
    vector.new( 1,  1, 0),
    vector.new( 1, -1, 0),
    vector.new(-1,  1, 0),
    vector.new(-1, -1, 0),
  }
end

return lib

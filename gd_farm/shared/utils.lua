-- Fetched from ImagicTheCat's vRP base
local modules = {}
function module(rsc, path) -- load a LUA resource file as module
  if path == nil then -- shortcut for vrp, can omit the resource parameter
    path = rsc
    rsc = "gd_farm"
  end

  local key = rsc..path

  if modules[key] then -- cached module
    return table.unpack(modules[key])
  else
    local f,err = load(LoadResourceFile(rsc, path..".lua"))
    if f then
      local ar = {pcall(f)}
      if ar[1] then
        table.remove(ar,1)
        modules[key] = ar
        return table.unpack(ar)
      else
        modules[key] = nil
        print("[gd_farm] error loading module "..rsc.."/"..path..":"..ar[2])
      end
    else
      print("[gd_farm] error parsing module "..rsc.."/"..path..":"..err)
    end
  end
end
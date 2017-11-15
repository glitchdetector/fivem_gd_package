print(loader)

awp = loader.load("BusModel1.obj")
function print_r (t, indent, done)
  done = done or {}
  indent = indent or ''
  local nextIndent -- Storage for next indentation value
  for key, value in pairs (t) do
    if type (value) == "table" and not done [value] then
      nextIndent = nextIndent or
          (indent .. string.rep(' ',string.len(tostring (key))+2))
          -- Shortcut conditional allocation
      done [value] = true
      print (indent .. "[" .. tostring (key) .. "] => Table {");
      print  (nextIndent .. "{");
      print_r (value, nextIndent .. string.rep(' ',2), done)
      print  (nextIndent .. "}");
    else
      print  (indent .. "[" .. tostring (key) .. "] => " .. tostring (value).."")
    end
  end
end

--[[
print("{")
for k,v in next, awp.f do
    print("    ["..k.."] = {")
    for c,w in next, v do
        print("        {x=" .. awp.v[w.v].x .. ", y="..awp.v[w.v].y..", z="..awp.v[w.v].z.."}")
    end
    print("    }")
end
print("}")
for k,f in next, awp.v do
    print(string.format("{x = %f, y = %f, z = %f, w = %f}", f.x, f.y, f.z, f.w))
end
]]
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

local function isThisGuyPartOfAnotherCompany(id, corpno)
	local r = false
	for i = 1, 10 do
		if vRP.hasPermission({id, "corp"..i..".employee"}) then
			r = true
			break
		end
	end
	return (r and (not vRP.hasPermission({id, "corp"..corpno..".employee"})))
end

function tryGive(user, group)
	local source = user
	local group = group
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "User ID to give " .. group, "", function(player,result)
            local sel_id = tonumber(result)
            if sel_id then
				local user_source = vRP.getUserSource({sel_id})
				if user_source then
					if not isThisGuyPartOfAnotherCompany(sel_id, "0") then
						local secret = "Tycoon"
						vRP.prompt({source, "Confirm by typing: " .. secret, "", function(player,result)
							if result == secret then
								vRP.request({user_source, "You've been invited as " .. group, 120, function(player,ok)
									if ok then
										vRP.addUserGroup({sel_id, group})	
									end
								end})   
							end
						end})   
					else
						vRP.request({source, "This person is already in a company!", 120, function(player,ok)
						end})   					
					end
				end
            end
        end})
    end
end

function tryFire(user, corp)
	local source = user
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "User ID to fire", "", function(player,result)
            local sel_id = tonumber(result)
            if sel_id then
				local user_source = vRP.getUserSource({sel_id})
				if user_source then
					if not isThisGuyPartOfAnotherCompany(sel_id, corp) then
						local secret = "Hellfire"
						vRP.prompt({source, "Confirm by typing: " .. secret, "", function(player,result)
							if result == secret then
								if vRP.hasPermission({sel_id,"corp"..corp..".ceo"}) then
									vRP.request({source, "You cannot fire the CEO.", 120, function(player,ok)
									end})   								
								else
									vRP.addUserGroup({sel_id, "nocorp"})
									vRP.request({user_source, "You've have been fired from your company.", 120, function(player,ok)
									end})   
								end
							end
						end})   
					else
						vRP.request({source, "This person is part of another company!", 120, function(player,ok)
						end})   
					end
				end
            end
        end})
    end	
end

vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}
		if isThisGuyPartOfAnotherCompany(user_id, "0") then
			choices["Manage Company"] = {function(player,choice)
				vRP.buildMenu({"companymanager", {player = player}, function(menu)
				
					local isCEO = false
					menu.name = "Company Manager"
					menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
					
					if vRP.hasPermission({user_id,"corp1.ceo"}) then
						menu["(FRLLC)"] = {function(p) end,"You're the CEO of FRLLC!"}
						menu["FRLLC EMS"] = {function(p) tryGive(p,"corp1.responders.ems") end,""}
						menu["FRLLC Air"] = {function(p) tryGive(p,"corp1.responders.air") end,""}
						menu["FRLLC Firefighter"] = {function(p) tryGive(p,"corp1.responders.firefighter") end,""}
						menu["FRLLC Trucker"] = {function(p) tryGive(p,"corp1.responders.trucker") end,""}
						menu["{Fire from company} FRLLC"] = {function(p) tryFire(p,"1") end,""}
						isCEO = true
					end
					if vRP.hasPermission({user_id,"corp2.ceo"}) then
						menu["(CollinsCo)"] = {function(p) end,"You're the CEO of CollinsCo!"}
						menu["CollinsCo Trucker"] = {function(p) tryGive(p,"corp2.collinsco.trucker") end,""}
						menu["CollinsCo Manager"] = {function(p) tryGive(p,"corp2.collinsco.manager") end,""}
						menu["CollinsCo Supervisor"] = {function(p) tryGive(p,"corp2.collinsco.supervisor") end,""}
						menu["CollinsCo Co-Owner"] = {function(p) tryGive(p,"corp2.collinsco.coowner") end,""}
						menu["{Fire from company} CollinsCo"] = {function(p) tryFire(p,"2") end,""}
						isCEO = true
					end
					if vRP.hasPermission({user_id,"corp3.ceo"}) then
						menu["(NarwhalCorp)"] = {function(p) end,"You're the CEO of NarwhalCorp!"}
						menu["NarwhalCorp Analyst"] = {function(p) tryGive(p,"corp3.narwal.annalist") end,""}
						menu["NarwhalCorp Technician"] = {function(p) tryGive(p,"corp3.narwal.technician") end,""}
						menu["NarwhalCorp Specialist"] = {function(p) tryGive(p,"corp3.narwal.specialist") end,""}
						menu["NarwhalCorp Transporter"] = {function(p) tryGive(p,"corp3.narwal.transporter") end,""}
						menu["NarwhalCorp Trucker"] = {function(p) tryGive(p,"corp3.narwal.trucker") end,""}
						menu["{Fire from company} NarwhalCorp"] = {function(p) tryFire(p,"3") end,""}
						isCEO = true
					end
					if vRP.hasPermission({user_id,"corp4.ceo"}) then
						menu["(SAL)"] = {function(p) end,"You're the CEO of SAL!"}
						menu["SAL Board of Directors"] = {function(p) tryGive(p,"corp4.sal.boardofdirectors") end,""}
						menu["SAL Regional Manager"] = {function(p) tryGive(p,"corp4.sal.regionalmanager") end,""}
						menu["SAL Manager"] = {function(p) tryGive(p,"corp4.sal.manager") end,""}
						menu["SAL Team Leader"] = {function(p) tryGive(p,"corp4.sal.teamleader") end,""}
						menu["SAL Trucker"] = {function(p) tryGive(p,"corp4.sal.trucker") end,""}
						menu["{Fire from company} SAL"] = {function(p) tryFire(p,"4") end,""}
						isCEO = true
					end
					
					if not isCEO then
						menu["You're not a CEO"] = {function(p) end, ""}
					end
					
					vRP.openMenu({player,menu})
				end})
			end, "Manage your company if you're a CEO"}
		end
        add(choices)
    end
end})
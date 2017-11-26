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
local function isCEO(id)
	local r = false
	for i = 1, 10 do
		if vRP.hasPermission({id, "corp"..i..".ceo"}) then
			return true
		end
	end
	return false
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
					local name = GetPlayerName(user_source)
					if not isThisGuyPartOfAnotherCompany(sel_id, "0") then
						local secret = "Tycoon"
						vRP.prompt({source, "Confirm by typing: " .. secret, "", function(player,result)
							if result == secret then
								if isCEO(sel_id) then
									vRP.request({source, "You cannot hire a CEO.", 120, function(player,ok)
									end})   								
								else
									vRP.request({user_source, "You've been invited as " .. group, 120, function(player,ok)
										if ok then
											vRP.addUserGroup({sel_id, group})	
											vRP.request({user_source, "You've successfully joined the company.", 120, function(player,ok)
											end})   
											vRP.request({source, name .. " was successfully added to the company.", 120, function(player,ok)
											end})   
										end
									end})   
								end
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
					local name = GetPlayerName(user_source)
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
									vRP.request({source, name .. " was fired from your company.", 120, function(player,ok)
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
						menu["FRLLC EMS"] = {function(p) tryGive(p,"corp1.responders.ems") end,"Hire a person as EMS"}
						menu["FRLLC Air"] = {function(p) tryGive(p,"corp1.responders.air") end,"Hire a person as Air"}
						menu["FRLLC Firefighter"] = {function(p) tryGive(p,"corp1.responders.firefighter") end,"Hire a person as Firefighter"}
						menu["FRLLC Trucker"] = {function(p) tryGive(p,"corp1.responders.trucker") end,"Hire a person as Trucker"}
						menu["{Fire from company} FRLLC"] = {function(p) tryFire(p,"1") end,"Fire a person from the company"}
						isCEO = true
					end
					if vRP.hasPermission({user_id,"corp2.ceo"}) then
						menu["(CollinsCo)"] = {function(p) end,"You're the CEO of CollinsCo!"}
						menu["CollinsCo Trucker"] = {function(p) tryGive(p,"corp2.collinsco.trucker") end,"Hire a person as Trucker"}
						menu["CollinsCo Manager"] = {function(p) tryGive(p,"corp2.collinsco.manager") end,"Hire a person as Manager"}
						menu["CollinsCo Supervisor"] = {function(p) tryGive(p,"corp2.collinsco.supervisor") end,"Hire a person as Supervisor"}
						menu["CollinsCo Co-Owner"] = {function(p) tryGive(p,"corp2.collinsco.coowner") end,"Hire a person as Co-Owner"}
						menu["{Fire from company} CollinsCo"] = {function(p) tryFire(p,"2") end,"Fire a person from the company"}
						isCEO = true
					end
					if vRP.hasPermission({user_id,"corp3.ceo"}) then
						menu["(NarwhalCorp)"] = {function(p) end,"You're the CEO of NarwhalCorp!"}
						menu["NarwhalCorp Analyst"] = {function(p) tryGive(p,"corp3.narwal.annalist") end,"Hire a person as Analyst"}
						menu["NarwhalCorp Technician"] = {function(p) tryGive(p,"corp3.narwal.technician") end,"Hire a person as Technician"}
						menu["NarwhalCorp Specialist"] = {function(p) tryGive(p,"corp3.narwal.specialist") end,"Hire a person as Specialist"}
						menu["NarwhalCorp Transporter"] = {function(p) tryGive(p,"corp3.narwal.transporter") end,"Hire a person as Transporter"}
						menu["NarwhalCorp Trucker"] = {function(p) tryGive(p,"corp3.narwal.trucker") end,"Hire a person as Trucker"}
						menu["{Fire from company} NarwhalCorp"] = {function(p) tryFire(p,"3") end,"Fire a person from the company"}
						isCEO = true
					end
					if vRP.hasPermission({user_id,"corp4.ceo"}) then
						menu["(SAL)"] = {function(p) end,"You're the CEO of SAL!"}
						menu["SAL Board of Directors"] = {function(p) tryGive(p,"corp4.sal.boardofdirectors") end,"Hire a person as Board of Directors"}
						menu["SAL Regional Manager"] = {function(p) tryGive(p,"corp4.sal.regionalmanager") end,"Hire a person as Regional Manager"}
						menu["SAL Manager"] = {function(p) tryGive(p,"corp4.sal.manager") end,"Hire a person as Manager"}
						menu["SAL Team Leader"] = {function(p) tryGive(p,"corp4.sal.teamleader") end,"Hire a person as Team Leader"}
						menu["SAL Trucker"] = {function(p) tryGive(p,"corp4.sal.trucker") end,"Hire a person as Trucker"}
						menu["{Fire from company} SAL"] = {function(p) tryFire(p,"4") end,"Fire a person from the company"}
						isCEO = true
					end
					
					if not isCEO then
						if vRP.hasPermission({user_id,"corp1.employee"}) then
							menu["(FRLLC)"] = {function(p) end,"You're an employee for FRLLC!"}
						end
						if vRP.hasPermission({user_id,"corp2.employee"}) then
							menu["(CollinsCo)"] = {function(p) end,"You're an employee for CollinsCo!"}
						end
						if vRP.hasPermission({user_id,"corp3.employee"}) then
							menu["(NarwhalCorp)"] = {function(p) end,"You're an employee for NarwhalCorp!"}
						end
						if vRP.hasPermission({user_id,"corp4.employee"}) then
							menu["(SAL)"] = {function(p) end,"You're an employee for SAL!"}
						end
						menu["You're not a CEO"] = {function(p) end, ""}
					end
					
					vRP.openMenu({player,menu})
				end})
			end, "Manage your company if you're a CEO"}
		end
        add(choices)
    end
end})
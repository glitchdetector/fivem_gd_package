--====================================================================================
-- PD Callout script made by GlitchDetector for Transport Tycoon
-- Original Menu Script Author: Jonathan D @ Gannon
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

function takeoffMarker(pos)
    createFlashingBlip(pos, 549, 15)
end

function landMarker(pos)
    createFlashingBlip(pos, 556, 30)
end

function createFlashingBlip(pos, blipid, time, col, override)
    TriggerServerEvent('gd_pd:flashingBlip', pos, blipid, time, col or 46, override or 0)
end

function callATC(region, method, runway, p4, override)
    local msg = "^1%s ATC: ^3%s ^0is preparing ^1%s ^0at runway ^2%s"
    if p4 or 0 then
        msg = "^1%s ATC: ^3%s ^0is preparing ^1%s ^0at ^2%s"
    end
    local name = GetPlayerName(-1)
    msg = string.format(msg, region, name, method, runway)
    TriggerServerEvent('gd_pd:message', msg, override or 0)
end

function sendLocation()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    pos = {x=pos.x,y=pos.y,z=pos.z}
    createFlashingBlip(pos, 307, 30, 4)
end

function emergencyLanding()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    callATC("Emergency", "emergency landing", string.format("%i°N %i°E", math.floor(pos.y), math.floor(pos.x)), 0, true)    
    pos = {x=pos.x,y=pos.y,z=pos.z}
    createFlashingBlip(pos, 556, 30, true)
end

function mayday()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    callATC("Emergency", "emergency landing", string.format("%i°N %i°E", math.floor(pos.y), math.floor(pos.x)), 0, true)    
    pos = {x=pos.x,y=pos.y,z=pos.z}
    createFlashingBlip(pos, 556, 30, true, true)    
end

--====================================================================================
--  Build Menu
--====================================================================================
Menu = {}
Menu.item = {
    ['Title'] = 'Police Menu',
    ['Items'] = {
        {['Title'] = 'Callouts', ['SubMenu'] = {
            ['Title'] = 'Police Callouts',
            ['Items'] = {
                { ['Title'] = '10-4 Acknowledgment', ['Function'] = callout, ['extraData'] = {name = '10-4'} },
                { ['Title'] = 'Land 30L / 12R', ['Function'] = landLSIA, ['extraData'] = {runway = '30L / 12R', pos = {x = -1386.934204, y = -3114.256836, z = 12.944432}} },
            }
        }},
        {['Title'] = 'Sandy Shores', ['SubMenu'] = {
            ['Title'] = 'ATC Sandy Shores',
            ['Items'] = {
                { ['Title'] = 'Land 5 / 23 (Jet)', ['Function'] = landSandy, ['extraData'] = {runway = '5 / 23', pos = {x = 1500.337769, y = 3094.885986, z = 39.531616}} },
                { ['Title'] = 'Land 26L / 8R (Side)', ['Function'] = landSandy, ['extraData'] = {runway = '26L / 8R', pos = {x = 1354.870361, y = 3088.605713, z = 39.534142}} },
                { ['Title'] = 'Land 26R / 8L (Main)', ['Function'] = landSandy, ['extraData'] = {runway = '26R / 8L', pos = {x = 1337.828125, y = 3151.860107, z = 39.414097}} },
                { ['Title'] = 'Takeoff 5 / 23 (Jet)', ['Function'] = takeoffSandy, ['extraData'] = {runway = '5 / 23', pos = {x = 1500.337769, y = 3094.885986, z = 39.531616}} },
                { ['Title'] = 'Takeoff 26L / 8R (Side)', ['Function'] = takeoffSandy, ['extraData'] = {runway = '26L / 8R', pos = {x = 1354.870361, y = 3088.605713, z = 39.534142}} },
                { ['Title'] = 'Takeoff 26R / 8L (Main)', ['Function'] = takeoffSandy, ['extraData'] = {runway = '26R / 8L', pos = {x = 1337.828125, y = 3151.860107, z = 39.414097}} },
            }
        }},
        {['Title'] = 'Zanduco', ['SubMenu'] = {
            ['Title'] = 'ATC Zancudo',
            ['Items'] = {
                { ['Title'] = 'Land 30 / 12 (Main)', ['Function'] = landZancudo, ['extraData'] = {runway = '30 / 12', pos = {x = -2375.579834, y = 3070.625732, z = 31.825928}} },
                { ['Title'] = 'Land 33 / 15 (Jet)', ['Function'] = landZancudo, ['extraData'] = {runway = '33 / 15', pos = {x = -2480.605225, y = 3235.851807, z = 31.925560}} },
                { ['Title'] = 'Takeoff 30 / 12 (Main)', ['Function'] = takeoffZancudo, ['extraData'] = {runway = '30 / 12', pos = {x = -2375.579834, y = 3070.625732, z = 31.825928}} },
                { ['Title'] = 'Takeoff 33 / 15 (Jet)', ['Function'] = takeoffZancudo, ['extraData'] = {runway = '33 / 15', pos = {x = -2480.605225, y = 3235.851807, z = 31.925560}} },
            }
        }},
        {['Title'] = 'McKenzie', ['SubMenu'] = {
            ['Title'] = 'ATC McKenzie',
            ['Items'] = {
                { ['Title'] = 'Land 25 / 7 (Main)', ['Function'] = landMcKenzie, ['extraData'] = {runway = '25 / 7', pos = {x = 2030.718628, y = 4755.413574, z = 40.124157}} },
                { ['Title'] = 'Takeoff 25 / 7 (Main)', ['Function'] = takeoffMcKenzie, ['extraData'] = {runway = '25 / 7', pos = {x = 2030.718628, y = 4755.413574, z = 40.124157}} },
            }
        }},
        {['Title'] = 'Paleto Bay', ['SubMenu'] = {
            ['Title'] = 'ATC Paleto Bay',
            ['Items'] = {
                { ['Title'] = 'Land 5 / 23 (Main)', ['Function'] = landPaleto, ['extraData'] = {runway = '5 / 23', pos = {x = -380.410980, y = 6497.020508, z = 7.386814}} },
                { ['Title'] = 'Takeoff 5 / 23 (Main)', ['Function'] = takeoffPaleto, ['extraData'] = {runway = '5 / 23', pos = {x = -380.410980, y = 6497.020508, z = 7.386814}} },
            }
        }},
        {['Title'] = 'Aircraft Carrier', ['SubMenu'] = {
            ['Title'] = 'ATC Carrier',
            ['Items'] = {
                { ['Title'] = 'Land 34 / 16 (Main)', ['Function'] = landCarrier, ['extraData'] = {runway = '34 / 16', pos = {x = 3049.651367, y = -4702.908691, z = 13.837625}} },
                { ['Title'] = 'Takeoff 34 / 16 (Main)', ['Function'] = takeoffCarrier, ['extraData'] = {runway = '34 / 16', pos = {x = 3049.651367, y = -4702.908691, z = 13.837625}} }
            }
        }},
        {['Title'] = '~y~Misc ATC', ['SubMenu'] = {
            ['Title'] = 'Misc ATC',
            ['Items'] = {
                { ['Title'] = 'Broadcast Location', ['Function'] = sendLocation},
                { ['Title'] = '~y~Emergency Landing', ['Function'] = emergencyLanding},
                { ['Title'] = '~r~Mayday', ['Function'] = mayday},
            }
        }},
    }
}
--====================================================================================
--  Option Menu
--====================================================================================
Menu.backgroundColor = { 52, 73, 94, 196 }
Menu.backgroundColorActive = { 22, 160, 134, 255 }
Menu.tileTextColor = { 22, 160, 134, 255 }
Menu.tileBackgroundColor = { 255,255,255, 255 }
Menu.textColor = { 255,255,255,255 }
Menu.textColorActive = { 255,255,255, 255 }

Menu.keyOpenMenu = 29 -- B
Menu.keyUp = 172 -- PhoneUp
Menu.keyDown = 173 -- PhoneDown
Menu.keyLeft = 174 -- PhoneLeft || Not use next release Maybe 
Menu.keyRight =	175 -- PhoneRigth || Not use next release Maybe 
Menu.keySelect = 176 -- PhoneSelect
Menu.KeyCancel = 177 -- PhoneCancel

Menu.posX = 1 - 0.3
Menu.posY = 1 - 0.7

Menu.ItemWidth = 0.20
Menu.ItemHeight = 0.03

Menu.isOpen = false   -- /!\ Ne pas toucher
Menu.currentPos = {1} -- /!\ Ne pas toucher

--====================================================================================
--  Menu System
--====================================================================================

function Menu.drawRect(posX, posY, width, heigh, color)
    DrawRect(posX + width / 2, posY + heigh / 2, width, heigh, color[1], color[2], color[3], color[4])
end

function Menu.initText(textColor, font, scale)
    font = font or 0
    scale = scale or 0.35
    SetTextFont(font)
    SetTextScale(0.0,scale)
    SetTextCentre(true)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(textColor[1], textColor[2], textColor[3], textColor[4])
    SetTextEntry("STRING")
end

function Menu.draw() 
    -- Draw Rect
    local pos = 0
    local menu = Menu.getCurrentMenu()
    local selectValue = Menu.currentPos[#Menu.currentPos]
    local nbItem = #menu.Items
    -- draw background title & title
    Menu.drawRect(Menu.posX, Menu.posY , Menu.ItemWidth, Menu.ItemHeight * 2, Menu.tileBackgroundColor)    
    Menu.initText(Menu.tileTextColor, 4, 0.7)
    AddTextComponentString(menu.Title)
    DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY)

    -- draw bakcground items
    Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * 2, Menu.ItemWidth, Menu.ItemHeight + (nbItem-1)*Menu.ItemHeight, Menu.backgroundColor)
    -- draw all items
    for pos, value in pairs(menu.Items) do
        if pos == selectValue then
            Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * (1+pos), Menu.ItemWidth, Menu.ItemHeight, Menu.backgroundColorActive)
            Menu.initText(Menu.textColorActive)
        else
            Menu.initText(Menu.textColor)
        end
        AddTextComponentString(value.Title)
        DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY + Menu.ItemHeight * (pos+1))
    end
    
end

function Menu.getCurrentMenu()
    local currentMenu = Menu.item
    for i=1, #Menu.currentPos - 1 do
        local val = Menu.currentPos[i]
        currentMenu = currentMenu.Items[val].SubMenu
    end
    return currentMenu
end

function Menu.initMenu()
    Menu.currentPos = {1}
end

function Menu.keyControl()
    if IsControlJustPressed(1, Menu.keyDown) then 
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = (Menu.currentPos[slcp] % size) + 1

    elseif IsControlJustPressed(1, Menu.keyUp) then 
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = ((Menu.currentPos[slcp] - 2 + size) % size) + 1

    elseif IsControlJustPressed(1, Menu.KeyCancel) then 
        table.remove(Menu.currentPos)
        if #Menu.currentPos == 0 then
            Menu.isOpen = false 
        end

    elseif IsControlJustPressed(1, Menu.keySelect)  then
        local cSelect = Menu.currentPos[#Menu.currentPos]
        local cMenu = Menu.getCurrentMenu()
        if cMenu.Items[cSelect].SubMenu ~= nil then
            Menu.currentPos[#Menu.currentPos + 1] = 1
        else
            if cMenu.Items[cSelect].Function ~= nil then
                cMenu.Items[cSelect].Function(cMenu.Items[cSelect])
            end
            if cMenu.Items[cSelect].Event ~= nil then
                TriggerEvent(cMenu.Items[cSelect].Event, cMenu.Items[cSelect])
            end
            if cMenu.Items[cSelect].Close == nil or cMenu.Items[cSelect].Close == true then
                Menu.isOpen = false
            end
        end
    end

end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        if IsPedInAnyPlane(GetPlayerPed(-1)) or IsPedInAnyHeli(GetPlayerPed(-1)) or 1 then
            if IsControlJustPressed(1, Menu.keyOpenMenu) then
                Menu.initMenu()
                Menu.isOpen = not Menu.isOpen
            end
            if Menu.isOpen then
                Menu.draw()
                Menu.keyControl()
            end
        end
	end
end)
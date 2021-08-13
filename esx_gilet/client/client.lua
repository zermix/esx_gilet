ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- MENU F6 --

openedGiletMenu = false
RMenu.Add("esx_gilet", "menugilet_main", RageUI.CreateMenu("Menu Gilets", "~b~Menu Gilets - ZerMix#0195"))
RMenu:Get("esx_gilet", "menugilet_main"):SetRectangleBanner(51, 162, 255)
RMenu:Get("esx_gilet", "menugilet_main").Closed = function()

    openedGiletMenu = false

end

function openGiletMenu()
    local pos = GetEntityCoords(PlayerPedId())

    if openedGiletMenu then
        RageUI.Visible(RMenu:Get("esx_gilet", "v"), false)
        openedGiletMenu = false
        return
    else
        openedGiletMenu = true
        RageUI.Visible(RMenu:Get("esx_gilet", "menugilet_main"), true)
        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
                Citizen.Wait(0)
            end
        
            while ESX.GetPlayerData().job == nil do
                Citizen.Wait(10)
            end
        
            ESX.PlayerData = ESX.GetPlayerData()
            while openedGiletMenu do
                Wait(1.0)


                local myCoords = GetEntityCoords(PlayerPedId())
                local dist = GetDistanceBetweenCoords(myCoords, ConfigPolice.Pos.Gilet, true)

                if dist > 2.5 then
                    RageUI.CloseAll()
                    openedGiletMenu = false
                else
                    local playerPed = PlayerPedId()
                    RageUI.IsVisible(RMenu:Get("esx_gilet", "menugilet_main"), true, false, false, function()

                        RageUI.Separator("↓ ~s~Gilet Par Balle~s~ ↓")

                        RageUI.ButtonWithStyle("🛡️ Mettre Gilet Par Balle", "~b~Description :~s~ Mettre un ~b~Gilet Par Balle", {RightLabel = "~b~→→"}, true, function(h,a,s)
                            if s then
                                SetPedComponentVariation(GetPlayerPed(-1) , 9, 11, 1)
                                SetPedArmour(playerPed, 100)
                            end
                        end, RMenu:Get("esx_gilet", "menugilet_main"))

                        RageUI.ButtonWithStyle("🛡️ Enlever Gilet Par Balle", "~b~Description :~s~ Mettre un ~b~Gilet Par Balle", {RightLabel = "~b~→→"}, true, function(h,a,s)
                            if s then
                                SetPedComponentVariation(GetPlayerPed(-1) , 9, 0, 0)
                                SetPedArmour(playerPed, 0)
                            end
                        end, RMenu:Get("esx_gilet", "menugilet_main"))
                        
                    end)
                end
            end
        end)
    end
end


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    while true do
        local myCoords = GetEntityCoords(PlayerPedId(), true)
        local noFps = false

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then

            if not openedGiletMenu then
                if #(myCoords-ConfigPolice.Pos.Gilet) < 1.5 then
                    noFps = true
                    AddTextEntry("GILET", "Appuyez sur [~b~E~s~] pour accéder au ~b~Vestiaires d'Equipements")
				    DisplayHelpTextThisFrame("GILET", false)
                    if IsControlJustReleased(0,38) then
                        openGiletMenu()
                    end
                    DrawMarker(22, ConfigPolice.Pos.Gilet, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 51, 162, 255, 155, 55555, false, true, 2, false, false, false, false)
                elseif #(myCoords-ConfigPolice.Pos.Gilet) < 5.5 then
                    noFps = true
                    DrawMarker(22, ConfigPolice.Pos.Gilet, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 51, 162, 255, 155, 55555, false, true, 2, false, false, false, false)
                end
            end
            
        end

        if noFps then
            Wait(1)
        else
            Wait(850)
        end
    end
end)
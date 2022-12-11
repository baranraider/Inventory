QBCore = nil
local isLoggedIn = false
local busy = false
local CurrentWeaponData = nil
local PlayerData = {}
local charModelLoaded = false

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('QBCore:Player:SetPlayerData')
AddEventHandler('QBCore:Player:SetPlayerData', function(data)
	PlayerData = data
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local time = 250

        if IsPedArmed(ped, 7) then 
            time = 1
            local selectedWeapon = GetSelectedPedWeapon(ped)
            local ammo = GetAmmoInPedWeapon(ped, selectedWeapon)
            if selectedWeapon == `weapon_marksmanpistol` then
                SetPedAmmo(ped, selectedWeapon, 10)
            end

            if IsPedShooting(ped) then
                if ammo - 1 < 1 then
                    SetAmmoInClip(ped, selectedWeapon, 1)
                end
            end

            if ammo == 1 and selectedWeapon ~= `weapon_molotov` and selectedWeapon ~= `weapon_flare` and selectedWeapon ~= `weapon_snowball` then
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                if IsPedInAnyVehicle(ped, true) then
                    SetPlayerCanDoDriveBy(PlayerId(), false)
                end
            end
        end
        Citizen.Wait(time)
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(((1000 * 60) * 5))
        if isLoggedIn then
            TriggerServerEvent("weapons:server:SaveWeaponAmmo", CurrentWeaponData, CurrentWeaponData and GetAmmoInPedWeapon(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId())) or 0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local time = 250
        if IsPedArmed(playerPed, 7) then 
            time = 10
            if IsPedShooting(playerPed) then
                local weapon = GetSelectedPedWeapon(playerPed)
                if weapon ~= -1569615261 and weapon ~= `WEAPON_SNOWBALL` then
                    local hastToName = QBCore.Shared.WeaponsHashtoName[weapon]
                    if (CurrentWeaponData and CurrentWeaponData.name == hastToName) then
                        local ammo = GetAmmoInPedWeapon(playerPed, weapon)
                        if QBCore.Shared.Items[hastToName]["name"] == "weapon_snowball" then
                            TriggerServerEvent('QBCore:Server:RemoveItem', "snowball", 1)
                        else
                            TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData.info.serie, tonumber(ammo))
                        end
                    else
                        if hastToName == nil then hastToName = "NULL" end
                        if CurrentWeaponData and CurrentWeaponData.name then
                            TriggerEvent("tgiann-hackkoruma:client:kick", "Seri Numarası Olmayan Silah Kullanımı data:" .. CurrentWeaponData.name .." kullandığı:" ..hastToName)
                        else
                            TriggerEvent("tgiann-hackkoruma:client:kick", "Seri Numarası Olmayan Silah Kullanımı data: NULL kullandığı:" ..hastToName)
                        end
                    end
                end
            end
        end
        Citizen.Wait(time)
    end 
end)

RegisterNetEvent('weapon:client:AddAmmo')
AddEventHandler('weapon:client:AddAmmo', function(type, amount, key)
    if QBCore.Key == key then
        if not busy then
            local playerPed = PlayerPedId()
            local weapon = GetSelectedPedWeapon(playerPed)

            local hastToName = QBCore.Shared.WeaponsHashtoName[weapon]
            if QBCore.Shared.Items[hastToName] ~= nil and QBCore.Shared.Items[hastToName]["ammotype"] == type:upper() then
                local total = (GetAmmoInPedWeapon(playerPed, weapon) + amount)
                local found, maxAmmo = GetMaxAmmo(playerPed, weapon)
                if total < maxAmmo then
                    busy = true
                    TaskReloadWeapon(playerPed)
                    QBCore.Functions.Progressbar("ammo_load", "Mermi Dolduruluyor", 1000, false, true, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        SetPedAmmo(playerPed, weapon, total)
                        TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData.info.serie, total) 
                        TriggerServerEvent("weapons:server:SaveWeaponAmmo", CurrentWeaponData, total)
                        TriggerServerEvent("weapons:server:remove-ammo-item", type)
                        busy = false
                    end, function() -- Cancel
                        busy = false
                    end)
                else
                    QBCore.Functions.Notify("Silahın Mermisi Zaten Dolu", "error") 
                end
            end
        end
    else
        TriggerEvent("tgiann-hackkoruma:client:kick", "İzinsiz Mermi Doldurma Eventi, Gönderilen Key: "..key)
    end
end)



RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data then
        CurrentWeaponData = data
        QBCore.Functions.Notify("Silahı Eline Aldın; ".. CurrentWeaponData.label, "success", 1500)
    else
        QBCore.Functions.Notify("Silahı Elinden Bıraktın; ".. CurrentWeaponData.label, "error", 1500)
        CurrentWeaponData = nil
    end
    CanShoot = bool
end)

RegisterNetEvent('weapons:client:KapaLaWep')
AddEventHandler('weapons:client:KapaLaWep', function(data, bool)
    if data then

    else
        QBCore.Functions.Notify("Araca Bindiğin İçin Sİlahı Elinden Bıraktın; ".. CurrentWeaponData.label, "error", 1500)
        CurrentWeaponData = nil
    end
    CanShoot = bool
end)

RegisterNetEvent("weapons:client:EquipAttachment")
AddEventHandler("weapons:client:EquipAttachment", function(ItemData, attachment)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local weaponName = QBCore.Shared.WeaponsHashtoName[weapon]
    local WeaponData = QBCore.Shared.Items[weaponName]
    if weapon ~= `WEAPON_UNARMED` then
        WeaponData.name = WeaponData.name:upper()
        if Config.WeaponAttachments[WeaponData.name] ~= nil then
            if Config.WeaponAttachments[WeaponData.name][attachment] ~= nil then
                TriggerServerEvent("weapons:server:EquipAttachment", ItemData, CurrentWeaponData, Config.WeaponAttachments[WeaponData.name][attachment])
            else
                QBCore.Functions.Notify("Bu Silaha Bu Eklentiyi Takamazsın!", "error")
            end
        end
    else
        QBCore.Functions.Notify("Elinde Bu Eklentiyi Takabilecek Bir Silah Yok!", "error")
    end
end)

RegisterNetEvent("addAttachment")
AddEventHandler("addAttachment", function(component)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    GiveWeaponComponentToPed(ped, weapon, GetHashKey(component))
end)



RegisterNetEvent('tgian-hud:load-data')
AddEventHandler('tgian-hud:load-data', function()
    QBCore.Functions.TriggerCallback("weapons:server:LoadWeaponAmmo", function(data)
        PlayerData = QBCore.Functions.GetPlayerData()
        
        lastStringHash = nil
        armed = false
        Citizen.Wait(1000)
        charModelLoaded = true
        isLoggedIn = true
    end)
end)




RegisterNetEvent('qb-weapons:client:SetWeaponAmmoManual', function(weapon, ammo)
    local ped = PlayerPedId()
        if weapon ~= "current" then
            weapon = weapon:upper()
            SetPedAmmo(ped, GetHashKey(weapon), ammo)
        else
            weapon = GetSelectedPedWeapon(ped)
            if weapon ~= nil then
                SetPedAmmo(ped, weapon, ammo)
            else
        end
    end
end)
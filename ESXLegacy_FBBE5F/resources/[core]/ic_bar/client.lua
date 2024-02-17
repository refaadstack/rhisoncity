local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local asu = 0
local voice = {default = 8.0, shout = 20.0, whisper = 2.5, current = 0, level = nil}

RegisterNetEvent('ESX_FWD_UI:updateStatus')
AddEventHandler('ESX_FWD_UI:updateStatus', function(Status)
    status = Status
    SendNUIMessage({
        action = "updateStatus",
        st = Status,
    })
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)

        if GetPedMaxHealth(ped) ~= 200 and not IsEntityDead(ped) then
            SetPedMaxHealth(ped, 200)
            SetEntityHealth(ped, GetEntityHealth(ped) + 25)
        end

        local armor = GetPedArmour(ped)
        local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
        SendNUIMessage({
            heal = health,
            armor = armor,
            stamina = stamina
        });

        Citizen.Wait(500)
    end
end)

AddEventHandler('onClientMapStart', function()
    if voice.current == 0 then
        NetworkSetTalkerProximity(voice.default)
        SendNUIMessage({
            voice = 52
        });
    elseif voice.current == 1 then
        NetworkSetTalkerProximity(voice.shout)
        SendNUIMessage({
            voice = 100
        });
    elseif voice.current == 2 then
        NetworkSetTalkerProximity(voice.whisper)
        SendNUIMessage({
            voice = 25
        });
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         if IsControlJustPressed(0, Keys['Z']) then
--             voice.current = (voice.current + 1) % 3
--             if voice.current == 0 then
--                 NetworkSetTalkerProximity(voice.default)
--                 SendNUIMessage({
--                     voice = 52
--                 });
--             elseif voice.current == 1 then
--                 NetworkSetTalkerProximity(voice.shout)
--                 SendNUIMessage({
--                     voice = 100
--                 });
--             elseif voice.current == 2 then
--                 NetworkSetTalkerProximity(voice.whisper)
--                 SendNUIMessage({
--                     voice = 25
--                 });
--             end
--         end
--     end
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         asu = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), "voip:talking")
--         if NetworkIsPlayerTalking(PlayerId()) then
--             SendNUIMessage({
--                 talking = true
--             })
--         elseif asu == 1 then
--             SendNUIMessage({
--                 talking = true
--             })
--         elseif asu == 0 then
--             SendNUIMessage({
--                 talking = false
--             })
--         elseif asu == nil then
--             SendNUIMessage({
--                 talking = false
--             })
--         elseif not NetworkIsPlayerTalking(PlayerId()) then
--             SendNUIMessage({
--                 talking = false
--             })
--         end
--         Citizen.Wait(200)
--     end
-- end)

Citizen.CreateThread(function()
    while true do
	    Citizen.Wait(1)
		if (not IsPedInAnyVehicle(PlayerPedId(), false) )then
            DisplayRadar(false)
        else
            DisplayRadar(true)
        end
	end
end)
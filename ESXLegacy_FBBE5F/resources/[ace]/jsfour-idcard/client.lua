local open = false

local open = false


-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end


-- Key events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
		
	end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)

-- 		if IsControlJustReleased(0, 57) then
--             local data = {} -- Isi dengan data yang sesuai
--             TriggerEvent('jsfour-idcard:open', data, 'driver')
-- 			print 'hello'
--         end
        
--     end
-- end)
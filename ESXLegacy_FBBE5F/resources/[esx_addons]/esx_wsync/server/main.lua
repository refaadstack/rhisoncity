local DynamicWeather = Config.DynamicWeather
local AvailableWeatherTypes = {
	'EXTRASUNNY',
	'CLEAR',
	'NEUTRAL',
	'SMOG',
	'FOGGY',
	'OVERCAST',
	'CLOUDS',
	'CLEARING',
	'RAIN',
	'THUNDER',
	'SNOW',
	'BLIZZARD',
	'SNOWLIGHT',
	'XMAS',
	'HALLOWEEN'
}
local CurrentWeather = "EXTRASUNNY"
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = Config.WeatherDuration
-- ESX = nil

-- TriggerEvent('esx:getSharedObject', function(obj)
-- 	ESX = obj
-- end)

function getWeatherDuration(weather)
	local mult = 1

	if Config.WeatherDurationMult[weather] ~= nil then
		local minmax = Config.WeatherDurationMult[weather]

		if minmax ~= nil then
			if #minmax >= 2 then
				mult = math.random(minmax[1], minmax[2])
			elseif #minmax > 0 then
				mult = minmax[1]
			else
				mult = 1
			end
		end
	end

	return Config.WeatherDuration * mult
end

RegisterNetEvent('esx_wsync:requestSync', function()
	TriggerClientEvent('esx_wsync:updateWeather', -1, CurrentWeather, blackout)
	TriggerClientEvent('esx_wsync:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

RegisterNetEvent('esx_wsync:freeze_time', function(source)
	-- check for console user
	if source ~= 0 then
		freezeTime = not freezeTime

		if freezeTime then
			TriggerClientEvent('esx:showNotification', source, 'Time is now ~b~frozen~s~.')
		else
			TriggerClientEvent('esx:showNotification', source, 'Time is ~y~no longer frozen~s~.')
		end
	else
		freezeTime = not freezeTime

		if freezeTime then
			print("Time is now frozen.")
		else
			print("Time is no longer frozen.")
		end
	end
end)

RegisterNetEvent('esx_wsync:freeze_weather', function(source)
	if source ~= 0 then
		DynamicWeather = not DynamicWeather

		if not DynamicWeather then
			TriggerClientEvent('esx:showNotification', source, 'Dynamic weather changes are now ~r~disabled~s~.')
		else
			TriggerClientEvent('esx:showNotification', source, 'Dynamic weather changes are now ~b~enabled~s~.')
		end
	else
		DynamicWeather = not DynamicWeather

		if not DynamicWeather then
			print("Weather is now frozen.")
		else
			print("Weather is no longer frozen.")
		end
	end
end)

ESX.RegisterCommand('weather', 'admin', function(xPlayer, args, showError)
	local validWeatherType = false
	local weatherType = ""

	for _, weatherType in ipairs(AvailableWeatherTypes) do
		if weatherType == string.upper(args.weatherType) then
			validWeatherType = true
			break
		end
	end

	if validWeatherType then
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Weather will change to: ~y~' .. string.lower(args.weatherType) .. "~s~.")

		CurrentWeather = string.upper(args.weatherType)
		newWeatherTimer = getWeatherDuration(weatherType)

		TriggerEvent('esx_wsync:requestSync')
	else
		showError('^1Invalid weather type, valid weather types are: ^0\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN')
	end
end, false, {help = "Set weather type", validate = true, arguments = {
	{name = "weatherType", help = "Available types: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween", type = 'string'}
}})

RegisterNetEvent('esx_wsync:blackout', function(source)
	if source == 0 then
		blackout = not blackout

		if blackout then
			print("Blackout is now enabled.")
		else
			print("Blackout is now disabled.")
		end
	else
		blackout = not blackout

		if blackout then
			TriggerClientEvent('esx:showNotification', source, 'Blackout is now ~b~enabled~s~.')
		else
			TriggerClientEvent('esx:showNotification', source, 'Blackout is now ~r~disabled~s~.')
		end

		TriggerEvent('esx_wsync:requestSync')
	end
end)

ESX.RegisterCommand('blackout', 'admin', function(xPlayer, args, showError)
	TriggerEvent('esx_wsync:blackout', xPlayer.source)
end, false)

ESX.RegisterCommand('freezetime', 'admin', function(xPlayer, args, showError)
	TriggerEvent('esx_wsync:freeze_time', xPlayer.source)
end, false)

ESX.RegisterCommand('freezeweather', 'admin', function(xPlayer, args, showError)
	TriggerEvent('esx_wsync:freeze_weather', xPlayer.source)
end, false)

RegisterNetEvent('esx_wsync:set_time', function(hh, mm, cb)
	hh = tonumber(hh)
	mm = tonumber(mm)

	if mm > 60 or mm < 0 then
		mm = 0
	end

	if hh > 23 or hh < 0 then
		hh = 0
	end

	ShiftToMinute(mm)
	ShiftToHour(hh)

	TriggerEvent('esx_wsync:requestSync')

	print(string.format("Time has changed to %02d:%02d.", hh, mm))

	if cb ~= nil then
		cb()
	end
end)

function ShiftToMinute(minute)
	timeOffset = timeOffset - ((math.floor(baseTime + timeOffset) % 60 ) - minute)
end

function ShiftToHour(hour)
	timeOffset = timeOffset - ((math.floor((baseTime + timeOffset) / 60) % 24 ) - hour) * 60
end

ESX.RegisterCommand('time', 'admin', function(xPlayer, args, showError)
	TriggerEvent('esx_wsync:set_time', args.hours, args.minutes, function()
		local h, m, _ = timeToHMS(baseTime + timeOffset)

		TriggerClientEvent('esx:showNotification', source, string.format('Time has changed to: ~y~%02d:%02d~s~!', h, m))
	end)
end, false, {help = "Change the time", validate = true, arguments = {
	{name = "hours", help = "A number between 0 - 23", type = "number"},
	{name = "minutes", help = "A number between 0 - 59", type = "number"}
}})

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		local newBaseTime = os.time(os.date("!*t")) / 2 + 360

		if freezeTime then
			timeOffset = timeOffset + baseTime - newBaseTime
		end

		local h1, _, _ = timeToHMS(baseTime + timeOffset)
		local h2, _, _ = timeToHMS(newBaseTime + timeOffset)

		if h2 ~= h1 then
			TriggerEvent('esx_wsync:hour_started', h2)
			TriggerClientEvent('esx_wsync:hour_started', -1, h2)
		end

		baseTime = newBaseTime
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		TriggerClientEvent('esx_wsync:updateTime', -1, baseTime, timeOffset, freezeTime)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)

		TriggerClientEvent('esx_wsync:updateWeather', -1, CurrentWeather, blackout)
	end
end)

Citizen.CreateThread(function()
	while true do
		newWeatherTimer = newWeatherTimer - 1

		Citizen.Wait(60000)

		if newWeatherTimer == 0 then
			if DynamicWeather then
				NextWeatherStage()
			end

			newWeatherTimer = getWeatherDuration(CurrentWeather)

			if Config.Debug then
				print("[esx_wsync] New random weather type has been generated: " .. CurrentWeather .. ".\n")
				print("[esx_wsync] Resetting timer to " .. newWeatherTimer .. " min.\n")
			end
		end
	end
end)

function NextWeatherStage()
	if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY" then
		local new = math.random(1, 2)

		if new == 1 then
			CurrentWeather = "CLEARING"
		else
			CurrentWeather = "OVERCAST"
		end
	elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
		local new = math.random(1, 6)

		if new == 1 then
			if CurrentWeather == "CLEARING" then
				CurrentWeather = "FOGGY"
			else
				CurrentWeather = "RAIN"
			end
		elseif new == 2 then
			CurrentWeather = "CLOUDS"
		elseif new == 3 then
			CurrentWeather = "CLEAR"
		elseif new == 4 then
			CurrentWeather = "EXTRASUNNY"
		elseif new == 5 then
			CurrentWeather = "SMOG"
		else
			CurrentWeather = "FOGGY"
		end
	elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
		CurrentWeather = "CLEARING"
	elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
		CurrentWeather = "CLEAR"
	end

	TriggerEvent("esx_wsync:requestSync")
end

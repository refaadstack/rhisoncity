RegisterServerEvent('esx_farmer:createFarmBlips')
AddEventHandler('esx_farmer:createFarmBlips', function()
    for _, farmArea in ipairs(Config.FarmAreas) do
        local blip = AddBlipForCoord(farmArea.coords)

        SetBlipSprite(blip, farmArea.Blip.Sprite)
        SetBlipDisplay(blip, farmArea.Blip.Display)
        SetBlipScale(blip, farmArea.Blip.Scale)
        SetBlipColour(blip, farmArea.Blip.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(farmArea.Blip.Label)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterServerEvent('esx_farmer:buyBibit')
AddEventHandler('esx_farmer:buyBibit', function(bibitType, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local bibitData = Config.Bibit[bibitType]

    if bibitData then
        local bibitPrice = bibitData.price * amount

        if xPlayer.getMoney() >= bibitPrice then
            xPlayer.removeMoney(bibitPrice)
            xPlayer.addInventoryItem(bibitType, amount) -- Menambahkan jumlah bibit ke inventori pemain
            TriggerClientEvent('esx:showNotification', _source, 'Anda telah membeli ' .. amount .. ' bibit ' .. bibitType .. '.')
        else
            TriggerClientEvent('esx:showNotification', _source, 'Uang Anda tidak cukup untuk membeli bibit ' .. bibitType .. '.')
        end
    else
        TriggerClientEvent('esx:showNotification', _source, 'Bibit tidak valid.')
    end
end)

RegisterServerEvent('esx_farmer:sellItem')
AddEventHandler('esx_farmer:sellItem', function(item, quantity)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.getInventoryItem(item).count >= quantity then
        local totalPrice = Config.Bibit[item].price * quantity
        xPlayer.removeInventoryItem(item, quantity)
        xPlayer.addMoney(totalPrice)
        TriggerClientEvent('esx:showNotification', _source, 'Penjualan berhasil: ' .. quantity .. ' ' .. Config.Bibit[item].label)
    else
        TriggerClientEvent('esx:showNotification', _source, 'Anda tidak memiliki cukup ' .. Config.Bibit[item].label .. ' untuk dijual.')
    end
end)

-- local plantedPlants = {}

-- -- Fungsi untuk mengecek apakah pemain berada di dalam area ladang

-- Fungsi untuk menanam bibit
RegisterServerEvent('esx_farmer:tanamBibit')
AddEventHandler('esx_farmer:tanamBibit', function(bibitType)

    
    -- print(('Player planted bibit: %s'):format(bibitType))
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerCoords = xPlayer.getCoords()
--     local playerPed = PlayerPedId()
--     local coords = GetEntityCoords(playerPed)

--     local function IsInFarmArea(coords)
--         for _, farmArea in ipairs(Config.FarmAreas) do
--             local distance = GetDistanceBetweenCoords(playerCoords, farmArea.coords, true)
--             if distance <= farmArea.radius then
--                 return true
--             end
--         end
--         return false
--     end
--    print(xPlayer)
    -- Cek apakah pemain berada di dalam area ladang
    -- if IsInFarmArea(playerCoords) then
        local bibitItem = xPlayer.getInventoryItem(bibitType)
        
        -- Verifikasi apakah pemain memiliki bibit yang ingin ditanam
        if bibitItem.count > 0 then
            -- Kurangi jumlah bibit yang dimiliki pemain
            xPlayer.removeInventoryItem(bibitType, 1)
            
            -- Memperbarui data server dengan informasi tentang tanaman yang ditanam
            local timeToGrow = Config.Bibit[bibitType].waktuTumbuh * 60 -- konversi menit ke detik
            table.insert(plantedPlants, {bibitType = bibitType, plantedAt = os.time(), timeToGrow = timeToGrow})
            
            -- Panggil event di sisi klien untuk memainkan animasi menanam
            TriggerClientEvent('esx_farmer:playPlantAnimation', _source)
        else
            TriggerClientEvent('esx:showNotification', _source, 'Anda tidak memiliki cukup bibit ' .. Config.Bibit[bibitType].label .. '.')
        end
    -- else
    --     TriggerClientEvent('esx:showNotification', _source, 'Anda harus berada di dalam area ladang untuk menanam bibit.')
    -- end
end)



ESX.RegisterServerCallback('esx_farmer:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local inventory = xPlayer.getInventory()
        local playerInventory = {}

        for k, v in pairs(inventory) do
            if Config.Bibit[k] then
                table.insert(playerInventory, {
                    label = Config.Bibit[k].label,
                    count = v.count,
                    value = k
                })
            end
        end

        cb(playerInventory)
    else
        cb(nil)
    end
end)


CreateThread(function()
	local blip = AddBlipForCoord(Config.Farmer.Toko.Pos.x,Config.Farmer.Toko.Pos.y,Config.Farmer.Toko.Pos.z)
	SetBlipSprite (blip, 88)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.7)
	SetBlipColour (blip, 25)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString("Toko Farmer")
	EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('esx_farmer:openMenu')
AddEventHandler('esx_farmer:openMenu', function()
    local elements = {
        {label = 'Beli Bibit', value = 'beli_bibit'},
        {label = 'Jual Hasil Panen', value = 'jual_hasil_panen'}
    }

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'farmer_menu',
        {
            title = 'Toko Petani',
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            if data.current.value == 'beli_bibit' then
                OpenBuyMenu()
            elseif data.current.value == 'jual_hasil_panen' then
                OpenSellMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end)

function OpenBuyMenu()
    local elements = {
        -- {label = 'Bibit Jagung', value = 'bibit_jagung', price= 100},
        -- {label = 'Bibit Timun', value = 'bibit_timun', price = 100}
    }

    for bibit, info in pairs(Config.Bibit) do
        table.insert(elements, {
            label = info.label .. ' - $' .. info.price,
            value = bibit
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_menu',
        {
            title = 'Pilih Bibit yang Ingin Dibeli',
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            OpenAmountMenu(data.current.value, 'beli')
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenSellMenu()
    local playerInventory = ESX.Player.GetInventory()
    local elements = {}

    for item, quantity in pairs(playerInventory) do
        if Config.Bibit[item] then
            table.insert(elements, {
                label = Config.Bibit[item].label .. ' - ' .. quantity,
                value = item
            })
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sell_menu',
        {
            title = 'Pilih Barang yang Ingin Dijual',
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            OpenAmountMenu(data.current.value, 'jual')
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenAmountMenu(item, type)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'amount_menu',
        {
            title = 'Masukkan Jumlah'
        },
        function(data, menu)
            local quantity = tonumber(data.value)
            if quantity and quantity > 0 then
                if type == 'beli' then
                    TriggerServerEvent('esx_farmer:buyBibit', item, quantity)
                elseif type == 'jual' then
                    TriggerServerEvent('esx_farmer:sellItem', item, quantity)
                end
                menu.close()
            else
                ESX.ShowNotification('Jumlah tidak valid.')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

RegisterCommand('farmer', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local isInFarmerArea = false
    
    -- Memeriksa apakah pemain berada di area petani berdasarkan koordinat
    local shopCoords = Config.Farmer.Toko.Pos
    local distance = #(coords - shopCoords)
    
    if distance < 3.0 then
        isInFarmerArea = true
    end

    if isInFarmerArea then
        TriggerServerEvent('esx_farmer:showBlip', shopCoords)
        TriggerEvent('esx_farmer:openMenu')
    else
        TriggerEvent('esx:showNotification', 'Anda harus berada di area toko petani untuk menggunakan command ini.')
    end
end, false)


function UpdatePlayerData()
    ESX.TriggerServerCallback('esx_farmer:getPlayerData', function(data)
        ESX.PlayerData = data
    end)
end
-- Fungsi untuk menampilkan menu bibit yang dimiliki pemain
function OpenBibitMenu()
    local elements = {}

    -- UpdatePlayerData()

    -- Loop melalui semua bibit yang ada di konfigurasi
    for bibit, info in pairs(Config.Bibit) do
        -- Ambil jumlah bibit yang dimiliki oleh pemain
        local playerItemCount = ESX.PlayerData.inventory[bibit] or 0
        table.insert(elements, {label = info.label .. '', value = bibit})
    end

    -- Tampilkan menu
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bibit_menu',
        {
            title    = 'Pilih Bibit untuk Ditanam',
            align    = 'right',
            elements = elements
        },
        function(data, menu)
            -- Ketika pemain memilih bibit, panggil event untuk menanam bibit tersebut
            local selectedBibit = data.current.value
            PlantBibit(selectedBibit)
            menu.close()
        end
    )
end

function PlantBibit(bibitType)
    TriggerServerEvent('esx_farmer:tanamBibit', bibitType)
    print('anda memilih bibit', bibitType)
end

-- Command untuk membuka menu bibit
RegisterCommand('plant', function()
    OpenBibitMenu()
end, false)

-- Fungsi untuk memainkan animasi menanam
RegisterNetEvent('esx_farmer:playPlantAnimation')
AddEventHandler('esx_farmer:playPlantAnimation', function()
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    TaskStartScenarioAtPosition(playerPed, 'WORLD_HUMAN_GARDENER_PLANT', x, y, z, GetEntityHeading(playerPed), 0, false, false)
end)
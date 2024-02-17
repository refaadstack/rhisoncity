Config   =    {}

Config.Bibit = {
   ['bibit_timun'] = {
       label = 'Bibit Timun',
       price = 15,
       waktuTumbuh = 120 -- Waktu tumbuh dalam menit (2 jam)
   },
   ['bibit_jagung'] = {
       label = 'Bibit Jagung',
       price = 15,
       waktuTumbuh = 120 -- Waktu tumbuh dalam menit (2 jam)
   },
   ['bibit_tomat'] = {
       label = 'Bibit Tomat',
       price = 15,
       waktuTumbuh = 120 -- Waktu tumbuh dalam menit (2 jam)
   },
   -- tambahkan jenis bibit lainnya di sini
}

-- Koordinat toko bibit
Config.Farmer = {
   Toko = {
      Pos = vector3(162.15, 6636.48, 31.55),
      Size  = { x = 12.0, y = 12.0, z = 12.0 },
      Color = { r = 50, g = 200, b = 50 },
      Type  = 25,
   }
}

-- Konfigurasi area ladang
Config.FarmAreas = {
   {
       coords = vector3(293.15, 6627.16, 29.3), -- Koordinat pusat area ladang pertama
       radius = 100
   },
   {
       coords = vector3(293.301, 6624.500, 29.43), -- Koordinat pusat area ladang kedua
       radius = 100
   },
   -- Tambahkan area ladang lainnya jika diperlukan
}

Config.PlantAnimation = {
   name = "WORLD_HUMAN_GARDENER_PLANT", -- Nama animasi
   duration = 5000 -- Durasi animasi dalam milidetik (5000 milidetik = 5 detik)
}
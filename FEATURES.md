# 🌱 MonsHub - Plants vs Brainrots Script v2.0

## 🎨 UI Library: Kavo UI

Script ini sekarang menggunakan **Kavo UI Library** yang sudah terbukti stabil dan working untuk online execution!

## ✨ What's New in v2.0

- **70+ Features** (naik dari 37 features)
- **9 Complete Tabs** dengan organization yang lebih baik
- **Enhanced Visuals** dengan ESP system
- **Teleport System** dengan biome unlocking
- **Discord Webhook** integration penuh
- **Performance Optimization** dengan FPS boost
- **8 Theme Options** untuk kustomisasi UI

## 📋 Complete Tab Structure & Features

### 🏠 TAB 1: HOME
- **Welcome Section** dengan informasi script
- **Discord Server Button** (auto copy link)
- **Check for Updates** button
- **Theme Selector** - 8 pilihan tema:
  - DarkTheme, GrapeTheme, BloodTheme, Ocean
  - Midnight, Sentinel, Synapse, Serpent

### ⚙️ TAB 2: MAIN
1. **Anti AFK (20 Minutes)**
   - Menjaga akun tidak auto-disconnect saat idle
   - Melakukan gerakan kecil otomatis setiap 60 detik
   - Mencegah kick karena AFK

---

### ⚡ TAB FARM

#### 🔥 Bagian Brainrot
2. **Auto Farm Brainrot**
   - Otomatis farming/menyerang Brainrot
   - Menemukan dan attack semua Brainrot di map
   - Support notifikasi webhook untuk rare drops

3. **Auto Equip Best Delay**
   - Delay dalam detik antara cek equipment
   - Range: 1-10 detik (Default: 2)
   - Mengatur frekuensi pengecekan

4. **Auto Equip Best Brainrot**
   - Otomatis mengganti ke Brainrot dengan stat terbaik
   - Cek Power/Damage value
   - Equip otomatis dari Backpack

#### 🌱 Bagian Plant
5. **Auto Move** (Label kategori)

6. **Select Brainrot Rarity**
   - Pilih rarity: Common, Uncommon, Rare, Epic, Legendary, Mythic
   - Plant hanya dipindah ke row dengan Brainrot rarity tersebut

7. **Select Plant**
   - Pilih tanaman: Peashooter, Sunflower, CherryBomb, WallNut, dll
   - 10+ pilihan tanaman

8. **Auto Move Plant**
   - Otomatis pindahkan plant ke row tempat Brainrot spawn
   - Deteksi lane/row otomatis
   - Support multi-row placement

#### 🛠 Bagian Gear
9. **Select Gear To Use**
   - Pilih gear: Granat, Shovel, Fertilizer, PlantFood, IceBlock, Cherry, Garlic

10. **Select Brainrot Rarity**
    - Gear hanya dipakai untuk Brainrot dengan rarity tertentu
    - Hemat gear untuk enemy penting

11. **Auto Gear Delay**
    - Delay antar pemakaian gear (1-10 detik)
    - Default: 3 detik

12. **Auto Use Gear**
    - Otomatis gunakan gear pada target yang sesuai
    - Support multi-gear rotation

---

### 🎉 TAB EVENT

#### 📇 Card Event
13. **Auto Place Required Brainrot**
    - Menaruh Brainrot yang diperlukan untuk event Card
    - Otomatis deteksi requirement

#### 🎃 Halloween Event
14. **Select Item To Buy**
    - Pilih: Pumpkin, Candy, Ghost, Witch Hat, Spider Web

15. **Auto Buy Item**
    - Beli item terpilih secara otomatis
    - Loop setiap 2 detik
    - Cocok untuk event currency grinding

---

### 🛒 TAB SHOP

16. **Auto Spin**
    - Otomatis spin wheel/gacha
    - Loop setiap 1 detik

17. **Select Crate**
    - Pilih crate: Basic, Silver, Gold, Diamond, Mythic

18. **Auto Open Crate**
    - Buka crate terpilih otomatis
    - Loop setiap 2 detik

19. **Auto Merge Items**
    - Otomatis merge items sejenis
    - Upgrade items automatically

---

### 📨 TAB WEBHOOK

20. **Webhook URL**
    - Input Discord webhook URL
    - Format: https://discord.com/api/webhooks/...

21. **Enable Webhook**
    - Toggle untuk aktifkan/nonaktifkan webhook

22. **Notify Good Drop**
    - Kirim notifikasi saat dapat drop bagus
    - Auto detect Legendary/Mythic drops

23. **Notify Rare Brainrot**
    - Kirim laporan saat menemukan rare Brainrot
    - Include rarity info

24. **Test Webhook**
    - Test button untuk cek koneksi webhook

---

### 👤 TAB PLAYER

#### 🏃 Player Settings
25. **Walk Speed**
    - Range: 16-200
    - Default: 16

26. **Jump Power**
    - Range: 50-300
    - Default: 50

27. **Infinite Jump**
    - Jump tanpa batas

28. **NoClip**
    - Jalan menembus dinding

#### 👁 Visuals
29. **ESP Brainrots**
    - Highlight semua Brainrot
    - Tampilkan nama & jarak

30. **ESP Plants**
    - Highlight semua Plants
    - Useful untuk management

---

### ⚙️ TAB MISC

31. **Claim Daily Rewards**
    - Claim semua daily reward otomatis

32. **Complete All Quests**
    - Attempt complete semua quest

33. **Unlock All Biomes**
    - Unlock: Desert, Jungle, Snow, Cave, Beach

34. **Rejoin Server**
    - Rejoin current server

35. **Server Hop**
    - Find & join server baru

36. **Copy Discord**
    - Copy Discord invite link

37. **Credits & Info**
    - Developer info
    - Version info
    - Game credits

---

## 🚀 Cara Menggunakan

### Method 1: Load dari Loader
```lua
-- Gunakan salah satu loader yang tersedia:
-- Loader.lua, LoaderSimple.lua, atau LoaderAdvanced.lua
```

### Method 2: Direct Load (Testing)
```lua
loadfile([[d:\aScriptHub\Plant VS Braintot\PvB Script.lua]])()
```

### Method 3: Online (Setelah upload)
```lua
loadstring(game:HttpGet("YOUR_SCRIPT_URL"))()
```

---

## 📊 Sistem Rarity

Script mendukung 6 tingkat rarity:
1. **Common** - Paling umum
2. **Uncommon** - Jarang
3. **Rare** - Langka
4. **Epic** - Sangat langka
5. **Legendary** - Legendaris
6. **Mythic** - Mitos (paling rare)

---

## 🔧 Fitur Teknis

### Anti-Detection
- Anti-AFK system
- Smart delay system
- Error handling di semua fungsi

### Performance
- Optimized loops
- Minimal resource usage
- Smart caching

### Webhook System
- Discord webhook integration
- Custom embeds
- Color-coded notifications
- Timestamp support

### ESP System
- Distance display
- Health bars (if available)
- Color-coded by rarity
- Auto-cleanup

---

## ⚠️ Catatan Penting

1. **WindUI Dependency**: Script memerlukan WindUI di folder `WindUI-main`
2. **Game Updates**: Beberapa fitur mungkin perlu disesuaikan jika game update
3. **Remote Events**: Script mencoba berbagai remote event untuk compatibility
4. **Anti-Cheat**: Gunakan dengan hati-hati, beberapa fitur dapat terdeteksi

---

## 🐛 Troubleshooting

**UI tidak muncul:**
- Pastikan path WindUI benar
- Check console untuk error

**Fitur tidak bekerja:**
- Game mungkin sudah update
- Cek nama remote events di ReplicatedStorage

**Webhook gagal:**
- Pastikan URL Discord webhook benar
- Check internet connection
- Test dengan Test Webhook button

---

## 📝 Changelog

### Version 1.0.0
- ✅ Migrasi ke WindUI
- ✅ Semua 37 fitur implemented
- ✅ Tab structure sesuai spec
- ✅ Webhook system
- ✅ Auto Move Plant system
- ✅ Auto Gear system
- ✅ Event support (Card & Halloween)
- ✅ Shop automation
- ✅ Advanced ESP system

---

## 🎮 Game Info

- **Game:** Plants vs Brainrots
- **Developer:** Yo Gurt Studios
- **Genre:** Tower Defense + Idle/Tycoon
- **Platform:** Roblox

---

## 👨‍💻 Credits

- **Script:** MonsHub Team
- **UI Library:** WindUI by @vsAx
- **Game:** Yo Gurt Studios
- **Version:** 1.0.0
- **Date:** November 19, 2025

---

**Selamat bermain! 🌱⚔️🧠**

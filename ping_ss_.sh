#!/bin/bash
token=$(cat ttk) #токен харинтся в файле ttk
# Список IP адресов
addresses=(
"192.168.0.22"
"8.8.8.8"
"192.168.0.1"
)
# Файл для логирования
log_file="ping_log2.txt" #логи упал поднялся
# Функция отпавки сообщения
function sendtlg {
 id=(4532534534534) #telegramm id for recive notifly через пробел
 url="https://api.telegram.org/bot$token/sendMessage"
 for i in ${!id[@]};do
  curl -s -X POST $url -d chat_id=${id[$i]} -d text="$1"
 done
}
# Функция для проверки пинга
ping_ip() {
    ip=$1
    if ping -c 1 -W 1 $ip &> /dev/null; then
#        echo "Ping to $ip is successful."
        return 0
    else
#        echo "Ping failed for $ip"
        return 1
    fi
}

# Массив для отслеживания состояния пинга
declare -A last_status
# замкнутый цикл проверки
while true; do
    for ip in "${addresses[@]}"; do
        if ping_ip $ip; then
            if [[ ${last_status[$ip]} == "down" ]]; then
                text0=$(date)": Ping to "$ip" is back up."
                echo $text0 >> $log_file
                sendtlg ${text0// /%20}

            fi
            last_status[$ip]="up"
        else
            if [[ ${last_status[$ip]} != "down" ]]; then
                text1=$(date)": Ping to "$ip" is down."
                echo $text1 >> $log_file
                sendtlg ${text1// /%20}
            fi
            last_status[$ip]="down"
        fi
    done
    sleep 5
done

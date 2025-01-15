# Colors
green="\033[0;32m"
blue="\033[0;34m"
red="\033[0;31m"
yellow="\033[0;33m"
white="\033[1;37m"
no_color="\033[0m"

# General System Information
echo "----------------------------------------------------------------------"
# Show Hostname, Ip-Adress, OS, Kernel
echo -e "${blue}General System Information${no_color}"
echo "----------------------------------------------------------------------"
echo -e "${no_color}Hostname: ${green}$(hostname)"
echo -e "${no_color}IP-Adress:${green}$(hostname -I | awk '{print $1}')"
echo -e "${no_color}Operating System: ${green}$(hostnamectl | grep 'Operating System' | awk -F': ' '{print $2}')"
echo -e "${no_color}Kernel: ${green}$(uname -r)${no_color}"


# FileSystem Usage, modify tresholds urself 
echo "----------------------------------------------------------------------"
echo -e "${blue}Filesystems${no_color}"
# (df -Th)
echo "----------------------------------------------------------------------"
# awk logic
df -Th | awk 'NR==1 {print $0}  # print the first line 
NR>1 {
    use=$6;  # take the Use%-column (6)
    gsub(/%/, "", use);  # strip the % sign

    # if logic 
    if (use+0 < 2) {
        color="\033[1;37m";  # white less than 1%
    } else if (use+0 >= 2 && use+0 < 4) {
        color="\033[0;33m";  # yellow for 1%-3%
    } else {
        color="\033[0;31m";  # red for 3% and more
    }
    # print the whole lines coloured
    print color $0 "\033[0m";  # color the whole line
}'

# Network
echo "----------------------------------------------------------------------"
# Active Network-Interfaces and IP-Adresses
echo -e "${blue}Network${no_color}"
echo "----------------------------------------------------------------------"
for iface in $(ip -o link show | awk -F': ' '{print $2}'); do
  ip_addr=$(ip addr show $iface | grep -w inet | awk '{print $2}')
  if [[ -n $ip_addr ]]; then
    echo -e "${no_color}$iface: ${green}$ip_addr"
  fi
done
# show standard Gateway
echo -e "${no_color}Gateway: ${green}$(ip route | grep default | awk '{print $3}')${no_color}"

# active sessions
echo "----------------------------------------------------------------------"
# show active sessions
echo -e "${blue}Sessions${no_color}"
echo "----------------------------------------------------------------------"
who

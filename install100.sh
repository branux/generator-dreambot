#!/bin/bash

# Set variables
# -----------------------------------
DREAMBOT_GITHUB_FOLDER_NAME="dreambot1.0.0"
DREAMBOT_GITHUB_FILE_NAME="dreambot-1.0.0"


# Set functions
# -----------------------------------
logMessage () {
  echo " $1"
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}


echo ""
echo " ============================================================"
echo "           Instalador DreamBot - DreamersTraders.com"
echo ""
echo "                Esto tomará algunos minutos"
echo ""
echo " ============================================================"
echo ""

logMessage "(1/6) Actualizando la Base del sistema"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
apt-get -qq update > /dev/null 2>&1


logMessage "(2/6) Instalando nodejs 6.x"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
curl -qsL https://deb.nodesource.com/setup_6.x | bash - > /dev/null 2>&1
apt-get -y -qq install nodejs > /dev/null 2>&1


logMessage "(3/6) Instalando Herramientas"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
apt-get -y -qq install unzip > /dev/null 2>&1
npm install -g pm2 yo@1.8.5 generator-dreambot dreambot-monitor > /dev/null 2>&1


logMessage "(4/6) Instalando TraderBot"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

wget -q https://github.com/DreamersTraders/dreambot/releases/download/DB1.0.0/dreambot-1.0.0.zip -P /opt/
unzip -o -qq /opt/dreambot-1.0.0 -d /opt/unzip-tmp

# create folder for the current version.
sudo mkdir /opt/dreambot-1.0.0 -p

# Copy only the executables.
cp /opt/unzip-tmp/dreambot-* /opt/dreambot-1.0.0

# creates a symbolic link to the DREAMBOT folder.
rm /opt/dreambot > /dev/null 2>&1
ln -s /opt/dreambot-1.0.0 /opt/dreambot

# Cleanup
sudo rm /opt/dreambot-1.0.0.zip
sudo rm -R /opt/unzip-tmp

# Set rights
sudo chmod +x /opt/dreambot/dreambot-*



logMessage "(5/6) Agregando los comandos"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "" >> ~/.bashrc
echo "# dreambot ALIASES" >> ~/.bashrc
echo "alias dentrar='cd /opt/dreambot'" >> ~/.bashrc
echo "alias diniciar='dentrar && yo dreambot init'" >> ~/.bashrc
echo "alias dagregar='dentrar && yo dreambot add'" >> ~/.bashrc
echo "alias dlistar='pm2 l'" >> ~/.bashrc
echo "alias dlog='pm2 logs'" >> ~/.bashrc
echo "alias dstart='pm2 start'" >> ~/.bashrc
echo "alias dstop='pm2 stop'" >> ~/.bashrc



logMessage "(6/6) Generador de archivos"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create folder for yeoman.
sudo chmod g+rwx /root
sudo chmod g+rwx /opt/dreambot

# Yeoman write rights.
sudo mkdir /root/.config/configstore -p
cat > /root/.config/configstore/insight-yo.json << EOM
{
        "clientId": 1337,
        "optOut": true
}
EOM
sudo chmod g+rwx /root/.config
sudo chmod g+rwx /root/.config/configstore
sudo chmod g+rw /root/.config/configstore/*

# pm2 write rights.
sudo mkdir /root/.pm2 -p
echo "1337" > /root/.pm2/touch
sudo chmod g+rwx /root/.pm2
sudo chmod g+rw /root/.pm2/*


echo ""
echo " ============================================================"
echo "                   Configuración completa!"
echo ""
echo "         Por favor corra los siguientes comandos "
echo "                 para iniciar el DreamBot:"
echo "                           dentrar"
echo "                           diniciar"
echo ""
echo " ============================================================"
echo ""

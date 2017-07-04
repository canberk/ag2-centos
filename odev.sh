# Degiskenler
ipAdres1='10.20.30.10'
ipAdres1AgMaskesi='255.255.0.0'
ipAdres1Aggeciti='10.20.0.0'
ipAdres2='10.21.30.10'
ipAdres2AgMaskesi='255.255.0.0'
ipAdres2Aggeciti='10.21.0.0'
birincilAg='ens34'
ikincilAg='ens35'
grup1='canberk'
grup2='ozdemir'
kullanici1='kullanici1'
kullanici2='kullanici2'
kullanici3='kullanici3'
kullanici4='kullanici4'
kullaniciOrtakSifreleri='canberk'
dnsAlanAdi='canberkozdemir' # .com .obs vb uzantıları kendi ekler
dnsReverseZoneAdresi='30.20.10'
dnsYonlendirme='10.20.30'
dhcpAg1BaslangicIp='10.20.30.200'
dhcpAg1BitisIp='10.20.30.220'
dhcpAg2BaslangicIp='10.21.30.200'
dhcpAg2BitisIp='10.21.30.220'


#Renkler
mavi="\033[1;34m"
yesil='\033[1;32m'
siyah='\033[0m'

clear;
echo -e "${mavi}"
echo "#######################"
echo -en "\n"
echo "┏━┓╺┓ ┏━┓┏━┓┏━┓┏━┓╺┓ ╺┓"
echo "┃┃┃ ┃ ┃┃┃┃┃┃┃┃┃┃┃┃ ┃  ┃"
echo "┗━┛╺┻╸┗━┛┗━┛┗━┛┗━┛╺┻╸╺┻"
echo -en "\n"
echo  c.ozdemir96@gmail.com
echo -en "\n"
echo "#######################"
sleep 3;
# 1. Adım
# AG AYARLARI
# Baslangıçta bağlantıları açma
echo -en '\n'
echo -e "${siyah}"
echo -n " Başlangıçta networkler açık olsun.. "
sed -ie s/ONBOOT=no/ONBOOT=yes/g  /etc/sysconfig/network-scripts/ifcfg-$birincilAg
sed -ie s/ONBOOT=no/ONBOOT=yes/g  /etc/sysconfig/network-scripts/ifcfg-$ikincilAg
sed -ie s/BOOTPROTO=dhcp/BOOTPROTO=none/g  /etc/sysconfig/network-scripts/ifcfg-$birincilAg
sed -ie s/BOOTPROTO=dhcp/BOOTPROTO=none/g  /etc/sysconfig/network-scripts/ifcfg-$ikincilAg
echo -e "${yesil}TAMAM${siyah}"

# İp adresleri atama
echo -en '\n'
echo -n " İp adresleri Atanıyor.. "
# Önceden kalanları iptal et
sed -ie /^IPADDR/d /etc/sysconfig/network-scripts/ifcfg-$birincilAg
sed -ie /^DNS1/d /etc/sysconfig/network-scripts/ifcfg-$birincilAg
sed -ie /^PREFIX/d /etc/sysconfig/network-scripts/ifcfg-$birincilAg
sed -ie /^GATEWAY/d /etc/sysconfig/network-scripts/ifcfg-$birincilAg
sed -ie /^IPADDR/d /etc/sysconfig/network-scripts/ifcfg-$ikincilAg
sed -ie /^DNS1/d /etc/sysconfig/network-scripts/ifcfg-$ikincilAg
sed -ie /^PREFIX/d /etc/sysconfig/network-scripts/ifcfg-$ikincilAg
sed -ie /^GATEWAY/d /etc/sysconfig/network-scripts/ifcfg-$ikincilAg
echo -e "IPADDR=$ipAdres1\nPREFIX=16\nGATEWAY=$ipAdres1Aggeciti\nDNS1=$ipAdres1" >> /etc/sysconfig/network-scripts/ifcfg-$birincilAg
echo -e "IPADDR=$ipAdres2\nPREFIX=16\nGATEWAY=$ipAdres2Aggeciti\nDNS1=$ipAdres2" >> /etc/sysconfig/network-scripts/ifcfg-$ikincilAg
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Ağ ayarları yeniden başlatılıyor..  "
systemctl restart network
echo -e "${yesil}TAMAM${siyah}"

# 2. Adım
# Grup ve Kullanıcı İşlemleri
# Grup Ekleme
echo -en '\n'
echo -n " $grup1 Grubu oluşturuluyor.. "
groupadd -g 2000 $grup1
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " $grup2 Grubu oluşturuluyor.. "
groupadd -g 3000 $grup2
echo -e "${yesil}TAMAM${siyah}"
# Kullanıcı Ekleme
echo -en '\n'
echo -n " Kullanıcılar oluşturuluyor.. "
useradd $kullanici1 -u 2001 -g $grup1
useradd $kullanici2 -u 2002 -g $grup1
useradd $kullanici3 -u 3001 -g $grup2
useradd $kullanici4 -u 3002 -g $grup2
echo -e "${yesil}TAMAM${siyah}"
# Kullanııcı Paraloları
echo -en '\n'
echo -n " Kullanıcılar Şifreleri $kullaniciOrtakSifreleri olarak ayarlanıyor.. "
echo "$kullanici1:$kullaniciOrtakSifreleri" | chpasswd
echo "$kullanici2:$kullaniciOrtakSifreleri" | chpasswd
echo "$kullanici3:$kullaniciOrtakSifreleri" | chpasswd
echo "$kullanici4:$kullaniciOrtakSifreleri" | chpasswd
echo -e "${yesil}TAMAM${siyah}"
#Kullanıcılar gruplara atanıyor
echo -en '\n'
echo -n " Kullanıcılar gruplara atanıyor.. "
echo -en '\n'
gpasswd -a $kullanici1 $grup1
gpasswd -a $kullanici2 $grup1
gpasswd -a $kullanici3 $grup2
gpasswd -a $kullanici4 $grup2
echo -e "${yesil}TAMAM${siyah}"




#3. Adım
# Dns için bind dns kurulumu
echo -en '\n'
echo -n " Bind Dns servisi kuruluyor.. "
yum  install bind bind-utils -y &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Dns Dosyaları konfigürasyonu yapılıyor.. "
mkdir pass
cp named.conf pass/namedpass.conf
sed -ie s/10.20.30.10/$ipAdres1/g pass/namedpass.conf
sed -ie s/canberkozdemir/$dnsAlanAdi/g pass/namedpass.conf
sed -ie s/30.20.10/$dnsReverseZoneAdresi/g pass/namedpass.conf
sed -ie s/10.20.30/$dnsYonlendirme/g pass/namedpass.conf
mv pass/namedpass.conf /etc/named.conf
# forward zone işlemleri
cp canberkozdemir.forward pass/$dnsAlanAdi.forward
sed -ie s/canberkozdemir/$dnsAlanAdi/g pass/$dnsAlanAdi.forward
sed -ie s/10.20.30/$dnsYonlendirme/g pass/$dnsAlanAdi.forward
sed -ie s/10.20.30.10/$ipAdres1/g pass/$dnsAlanAdi.forward
mv pass/$dnsAlanAdi.forward /var/named/$dnsAlanAdi.forward
# reverse zone işlemleri
cp canberkozdemir.reverse pass/$dnsAlanAdi.reverse
sed -ie s/canberkozdemir/$dnsAlanAdi/g pass/$dnsAlanAdi.reverse
sed -ie s/30.20.10/$dnsReverseZoneAdresi/g pass/$dnsAlanAdi.reverse
mv pass/$dnsAlanAdi.reverse /var/named/$dnsAlanAdi.reverse
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Dns servisi  başlatılıyor.. "
systemctl enable named &> /dev/null
systemctl start named &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Dns için 53 numaralı port açılıyor.. "
firewall-cmd --permanent --add-port=53/tcp &> /dev/null
firewall-cmd --permanent --add-port=53/udp &> /dev/null
firewall-cmd --reload &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Gerekli izin dosyalarını açıyor.. "
chgrp named -R /var/named &> /dev/null
chown -v root:named /etc/named.conf &> /dev/null
restorecon -rv /var/named &> /dev/null
restorecon /etc/named.conf &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Ağ ve Dns servisleri yeniden başlatılıyor.. "
systemctl restart network
systemctl restart named
echo -e "search $dnsAlanAdi\nnameserver $ipAdres1" > /etc/resolv.conf
echo -e "${yesil}TAMAM${siyah}"

# 4. Adım
echo -en '\n'
echo -n " Dhcp Sunucusu kuruluyor.. "
yum install dhcp -y &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Dhcp konfigürasyon dosyaları hazırlanıyor.. "
cp dhcpd.conf pass/dhcpdpass.conf
sed -ie s/10.20.0.0/$ipAdres1Aggeciti/g pass/dhcpdpass.conf
sed -ie s/255.255.0.0/$ipAdres1AgMaskesi/g pass/dhcpdpass.conf
sed -ie s/canberkozdemir/$dnsAlanAdi/g pass/dhcpdpass.conf
sed -ie s/10.20.30.10/$ipAdres1/g pass/dhcpdpass.conf
sed -ie s/10.20.30.200/$dhcpAg1BaslangicIp/g pass/dhcpdpass.conf
sed -ie s/10.20.30.220/$dhcpAg1BitisIp/g pass/dhcpdpass.conf
sed -ie s/10.21.0.0/$ipAdres2Aggeciti/g pass/dhcpdpass.conf
sed -ie s/255.255.0.0/$ipAdres2AgMaskesi/g pass/dhcpdpass.conf
sed -ie s/10.21.30.200/$dhcpAg2BaslangicIp/g pass/dhcpdpass.conf
sed -ie s/10.21.30.220/$dhcpAg2BitisIp/g pass/dhcpdpass.conf
mv pass/dhcpdpass.conf /etc/dhcp/dhcpd.conf
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Dhcp güvenlik duvarı ayarları yapılıyor.. "
/sbin/restorecon -v /etc/dhcp/dhcpd.conf &> /dev/null
systemctl enable dhcpd &> /dev/null
systemctl start dhcpd &> /dev/null
 firewall-cmd --add-service=dhcp --permanent &> /dev/null
firewall-cmd --reload &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Servisler yeniden başlatılıyor.. "
systemctl restart network 
systemctl restart named	
systemctl restart dhcpd
echo -e "${yesil}TAMAM${siyah}"




# 5. Adim 
echo -en '\n'
echo -n " Ftp servisi kuruluyor.. "
yum -y install vsftpd &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " Ftp güvenlik duvarı ayarları yapılıyor.. "
sed -ie s/anonymous_enable=YES/anonymous_enable=NO/g /etc/vsftpd/vsftpd.conf
systemctl start vsftpd 
firewall-cmd --permanent --add-port=21/tcp &> /dev/null
firewall-cmd --permanent --add-service=ftp &> /dev/null
firewall-cmd --reload &> /dev/null
setsebool -P ftpd_full_access on &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
rm -rf pass


# 6. Adım
echo -en '\n'
echo -n " Apache web sunucusu kuruluyor.. "
yum -y install httpd &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -n " Apache sunucusu başlatılıyor.. "
systemctl start httpd &> /dev/null
systemctl enable httpd &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -n " Apache için firewall kuralı oluşturuluyor.. "
firewall-cmd --permanent --add-service=http &> /dev/null
systemctl restart firewalld &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -en '\n'
echo -n " MariaDB kuruluyor.. "
yum -y install mariadb mariadb-server &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -n " MariaDB başlatılıyor.. "
systemctl start mariadb
systemctl enable mariadb &> /dev/null
echo -e "${yesil}TAMAM${siyah}"
echo -n " MariaDB için (veritabanı) root parolası giriniz: "
read -s mypass
echo -en '\n'
echo -en '\n'
#mysqladmin -u root -p password $mypass
echo -n " PHP kuruluyor.. "
yum install -y mod_php56u php56u-cli php56u-mysqlnd &> /dev/null
yum install -y php56u-bcmath php56u-mbstring &> /dev/null
cat << EOT >> /var/www/html/index.php
<?php
echo '<h1>$dnsAlanAdi.com</h1>';
?>
EOT
systemctl restart httpd
echo -e "${yesil}TAMAM${siyah}"
echo -e "search $dnsAlanAdi\nnameserver $ipAdres1" > /etc/resolv.conf
echo -en '\n'


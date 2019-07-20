# Bilgisayar Ağları 2 - Centos Ödevi
Sanal işletim sistemi (centos 7) üzerine çeşitli servisleri kurar ve başlangıç ağ ayarlarını yapar.

![talimatlar](/docs/ag2odev.png)

# Kullanım
1. Sanal ortamınıza sanal ağı istenilen şekilde ekleyin.Eklenilecek olan ağların dhcp servisi kapalı olsun.
![Virtual Network](/docs/network.png)
2. İşletim sistemini kurmadan önce sanal ağlarınızı ve internete erişebileceğiniz gerçek ağınızı donanım olarak ekleyin.
3. İşletim sistemi kurulduktan sonra ağ ayarlarınız resimdeki gibi olması gerekiyor. Sistemi yeniden başlatın.
![Ağ ayarları](/docs/agayarlari.png)
4. root girişi yapın ardından bu komutu kullanarak kaynak dosyaları indirin
```shell
git clone https://github.com/canberk/ag2-centos.git 
```
5. shell dosyası üzerinde gerekli değişken değişikliklerini kendinize göre yaptıktan sonra scripti çalıştırın.
```shell
sh odev.sh 
```
# Ekran Görüntüsü
![Ekran Görüntüsü](/docs/screenshot.png)
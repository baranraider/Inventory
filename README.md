Çok çok çok büyük not;
Eğer ki metalı mermi sistemini kullanmak istiyorsanız envanter ve weapons sistemini kullanmak zorundasınız. Silah çektiğinizde ki evenet tetiklerini envanter üzerinden yapıyor.

Not : qb-weapons içerisinde ki tgian-hud:load-data adlı eventi qbcore içerisinde onPlayerLoaded içerisine yazmanız gerekiyor. Sunucuya ilk girdiğinizde mermilerinizi yüklemesi açısından.

Script içerisinde notify sistemi torpak-notify olarak kullanılıyor. Siz kullanmıyorsanız değiştirmelisiniz
.
Envanter içerisinde ki "VER" sistemi şimdilik deaktif. Bir kaç problemi olduğu için ileri de güncelleyeceğim.

qb-inventoryv2/server.lua içerisinde giveitem komutunun içerisinde silahlar için seri numarası verme kodu bulunmakta. Orada ki info.serie içerisinde ki değeri qb-core/server/players.lua içerisinde ki silah seri numarası koduyla aynı yapın.

- Craft sisteminin kullanımı;
-- ÜRET butonunda bir tablo hariç diğer hangi craft tablolarını da görebilmesini istiyorsanız aşağıda ki adımı uygulayın.
-- Örnek olarak polis tablosuna sivil ve hacker eklemek istiyorsunuz. O zaman ise; Polis tablonun hemen altına  ek = {"sivil"}, ekleyerek sivil tablosunu veya  ek{"sivil","hacker"}, olarak iki tablo ekleyebilirsiniz.

İstediğiniz kadar job ve craft tablosu ekleyebilirsiniz.

Envanter hakkında fotoğraflar;

![1](https://user-images.githubusercontent.com/73917011/206932038-6d144bcc-dcfd-452d-9fa2-e2a0bb8fc6d2.png)
![2](https://user-images.githubusercontent.com/73917011/206932046-748925e3-2d1e-4b81-a6e1-2b3e9ead3fb1.png)
![3](https://user-images.githubusercontent.com/73917011/206932075-21d745d0-6ca9-4685-9c41-dc0c7769a75f.png)
![4](https://user-images.githubusercontent.com/73917011/206932108-23f4eb07-c97a-41bb-b431-d2c5e5815c64.png)

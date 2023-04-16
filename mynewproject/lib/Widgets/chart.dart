import "package:flutter/material.dart";
import '../models/transactions.dart';
import 'package:intl/intl.dart';
import '../Widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  List<Transactions>
      recentTransactions; //şimdi belirlenen gün için yapılan transactionı hesaplamamız lazım. Bunun için transaction list gerekiyor.

  Chart(
      this.recentTransactions); //List<Transactions>'ta depolamak için argument oluşturduk.
  List<Map<String, Object>> get groupedTransactionValues {
    //map string ve objectten oluşan listemiz için get oluşturuyoruz.

    return List.generate(7, (index) {
      // List.generate yeniden bir liste oluşturur "7" uzunluğunda 0,1,2,3,4,5,6 sırasıyla index fonksiyonunu
//tetikler.
      final weekDay = DateTime.now().subtract(Duration(
          days:
              index)); // Bugünün  tarihi 7 gün geriye ayarlarnacak şekilde seçildi.
//Çünkü index = 7. DateTime.now olduğu için her zaman bir hafta öncesini hesaplayacak. 0,1,2,4,5,6 ve 7. sayı o günün mutlak tarihini verir.

      var totalSum =
          0.0; //ondalık olmasının sebebi 9,99 19,34 gibi sayılar olabilir test etmek lazım.

      for (var i = 0; i < recentTransactions.length; i = i + 1) {
        //for loop bir kodu birden fazla kez tekrar etmeye yarar. For loop üç adet
//argüman alır. Bu senaryo için, bugünde oluşturulan değeri bulmak için, "i" değişkenini oluşturduk. "i" değişkeni Transactions.length
//ten küçük olduğu müddetçe Loop döngüsü devam edecek. i = i + 1 yada i++ ise döngü her kullanıldığında i'ye yeni +1 değer atayacak
//eğer atamazsa kod sonsuz döngüde kalır çünkü i her zaman transactions.lenghtten küçük kalır.
//burada amaç 0,1,2,3,4,5,6 indexinde 6ya gelene kadar loopta kalmak. index 6 olunca kod looptan çıkar, bu sayede bugünün tarihine
//ulaşmış oluruz.

        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
          //recentTransaction "i" elementine  ulaşır. i elementi bize recentTransactions icinde 1 eklenerek artar.
          //loop döngüsüyle recentTransactions listin icinde i varyasonunu 1 er ekleyerek artirdik.
          //If döngüsüyle de recenTransactions icinde 1er 1 er artirdigimiz i variyantına gün, ay ve yıl ekleyerek
          //Bugünün tarihini gün, ay ve yıl ile teyit ederek darta ilettik. weekDay son 7 günü kapsayacak sekilde
          //ayarlandı. recentTransaction ve weekDayi if döngüsüyle bugünün tarihini vermesi için gün, ay, yıl cinsinden
          //eşitlik koşulu koyuyoruz.

          //Bu koşullar sağlandığı takdirde recentTransactions[i].amount totalSum'a eşit olur.
          //totalSum'ı recentTransactionsta yapılan ogünkü işlemin tutarıyla eşit hale getiriyoruz.
        }
      }

      print(DateFormat.E().format(weekDay));
      print(totalSum);
      return {
        //List.generate ile 7 indexin her biri için oluşturduğumuz değeri Map'e geri döndürüyoruz
//{} bu işaret tek başına map oluyor unutrma. Amount verilen gün için yapılan total harcama
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        //Günlerin baş harfi için DateFormat.E baş harfi verir. Hangi gün olduğunu da weekDay ile hesaplayacağız.
        //.format string halini verir
        //substring baş harflerine kısaltmak için kullanılır. İlk karakter için 0 ve ikinci karakterin başlagıcı 1 seçilir.
        "amount": totalSum
      };
    }).reversed.toList(); //reversed list, listeyi tersine çevirir. Bu sayede kartta ilk göreceğimiz gün cuma olmuş olacak
  }

  double get kaanTransactions {
    return groupedTransactionValues.fold(
      0.0,
      (sum, element) {
        return sum + element["amount"];
      },
    );

//double bir öğeyi List Mape döndüremeyiz. Ne yapacağız? .fold metodunu kullancağız. Fold metodu bir listeyi farklı
//bir tipe dönüştürmemize olanak sağlar. Kesin bir mantıkla hangi fonksiyonları folda geçireceğimizi belirteceğiz.
//başlangıç değeri olarak 0.0 belirledik. İkinci geçireceğimiz değer ise başlangıç değerimize eklenecek olan değerdir.
//Gruptaki her öğe üzerinde her çalıştırmada çalışacak bir değer returnlememiz gerekiyor.
//parantez içi iki argümana ihtiyacımız var. İlk argüman şuanda hesaplanan toplamları biriktiren bir biriktirici, kısaca sum diyeceğiz.
//ikicisi ise element, listedeki mevcut seçili elemeneti ifade eder
//yukarıdaki get sayesinde, normalde double a döndüremeyeceğimiz listeden almak istediğimiz değeri fold metodu kullanarak
//kaanTransactionsa aktarıyoruz.
//sum başlangıç değerimize eklenmek üzere her çalışmada listedeki her öğe üzerinde çalışacak bir argümandır.
//Bu argümanı element ve Liste üzinden "Amount" değerine erişip toplanmak üzere fold'a geri döndürüyoruz.
//BÖYLECE kaanTransactions, groupedTransactions'tan amount değerini fold metoduyla get etmiş oldu.

//groupedTransactionValues'e geri döndürmemizin sebebi her gün için yapılan tüm harcamaları toplamak istememis. Her gün için
// yapılan tüm harcamaların toplamı bize o hafta yapılan harcamayı verir.
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Padding(padding: EdgeInsets.all(7),
      child: Card(
        
    
        elevation: 6,
        child: Container( //barlar ile kutunun etrafında boşluk açmak için kullandık. Sadece padding yapacaksan Padding() widgetını
                          //kullanma şansın da var.
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //yanyana dizilecek sütunlar oluşturacağımız için Row widgetini kullandık.
            children: groupedTransactionValues.map((data) {
              //7 adet sütuna gün ve amount bilgisine ihtiyacımız olduğu için groupedTransactionValuesi çağırdık.
    
              return Flexible(
                //Flexible yeni widget. Row içerisindeki tüm öğeleri alabilecekleri maksimum
                //alana sıkıştırır. Böylece birbirlerinin alanlarını işgal etmezler.
                fit: FlexFit
                    .tight, //bu komutla her öğeyi alanına sıkıştırdık. Ancak yazı uzun olunca o da sıkıştı
                //bu kotü bir görüntü oluşturdu. chart_barda bunu düzelttik. Oraya bak!
                //FlexFit.loose, kendisine verilen alana içeriği sıkıştırmaya yarar.
                //FlexFit.tight ise kendisine verilen alanı olabildiğince genişletir. Ancak piksel aşımı yapmaz. Ekrandaki boş alanların
                //tamamını kullanır.
                //flex: bu komut ise sayı alır. Ekrandaki öğelerin boş alanı ne derecede kullanabileceğini belirler. 1 yada 2 ile
                //ifade edilir. Örneğin 3 sütun varsa ve sütunlardan birine 1 verirsek, geri kalan sütunlara 3/4 alan kalır.
                //flex: bunun teorisini mutlaka dene. Kısaca ekrandaki öğelerin boş alanı ne miktarda kullanabileceğini
                //belirler.
                //Expanded ise Flexibleın fit argümanına sahip olmayan halidir
                child: ChartBar(
                  data["day"],
                  data["amount"],
                  kaanTransactions == 0.0
                      ? 0.0
                      : ((data["amount"] as double) / kaanTransactions),
                ),
              );
              // if döngüsü kullanmazsak uygulama açılınca çöker. Çünkü sıfırı sıfıra bölemezsiniz bölersen hata olur. Basic math stuffs!
              //Bu yüzden darta diyoruz ki, eğer kaanTransactions 0 ise 0.0 ı göster. if else, yani işlem varsa tutarı kaanTransactiona böl.
              //Dipnot, pozisyonel argümanda sorun yaşamazsın, koymamız gereken değer double olduğu müddetçe
    
              //data ile mapi indeksleyerek map içerisinden day ve amount aldık. Harcamalar ve günlerin baş harfini görüntüleyebilmek için.
    
              // return Text("${data["day"]}: ${data["amount"]}");
              ////data elementi map ile listeden day i alıyor ":" işaretyile aynı formül yoluyla amount
              //ile toplanıyor. Sonuç olarak geri döndürülen ifade gün + yapılan harcama
            }).toList(), //bunu eklemeyı unutma, liste olduğunu darta söylemezsek kodumuz çalışmaz.
          ),
        ),
      ),
    );
  }
}

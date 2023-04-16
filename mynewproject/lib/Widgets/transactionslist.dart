import 'package:flutter/material.dart';
import '../models/transactions.dart'; //listeleri models klasörüne aldık
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> transactions;
  final Function iddelete;

  TransactionList(this.transactions,
      this.iddelete); //usertransactionsı buraya bağlamak ve mapleyerek aşağıda oluşturduğumuz için yaptık
  //cardlara ekleyebilmek için yaptık.


  Widget build(BuildContext context) {
    // return Container(
    //   height: 611, //listemizin ekranda kaplayacağı yükselik değeri, bunu yapmazsan ListView sınırsız alan almaya çalışır

    //   child: transactions
    return transactions
            .isEmpty //if döngüsü, eğer transactions list boş ise aşağıdaki column görüntülenir. Transaction eklenirse ListView
        ? LayoutBuilder(builder: (ctx, constraints) {
            //bu işlem sadece aşağıdaki png dosyası için chart barda yaptığımın aynısı
            return Column(
              // hem text, hem de image widgetlarını kullanarak ekrana text ve resim koymak için Column kullandık.
              children: <Widget>[
                Text(
                  "No Transactions here!",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge, //themesdeki ayarlarımızı text için ayarladık
                ),
                SizedBox(
                  // iki widget arasında boşluk bırakmak için ideal, child alabilir ama zorunlu değil. Ekranda görünmez
                  height: 50,
                ),
                Container(
                    //Image'i container ile wraplamamın sebebi, Image'in tüm Column'ın yükseliğini alıp ekrana sığmaması.
                    height: constraints.maxHeight *
                        0.5, //Ancak Container ile height ayarlayarak Imagein boyutunu belirleye biliriz.
                    child: Image.asset("assets/images/waiting.png",
                        fit: BoxFit.cover))
              ],
            );
          })
        : ListView.builder(
            //itemBuilder, kaydırılabilir liste oluşturmak için gerekli. İlk argüman buildcontexti ikinci argüman ise
            //dizin sayısı belli eden int değeridir.
            //itemCounteri unutma, listenin sonunda onu da ekledik.
            itemBuilder: (context, index) {
              //içerisinde fiyat, title ve tarih barındıran bir transaction kutucuğu oluşturmak istiyoruz. Peki nasıl yaparız?
              //Card() widgetini kullanırız. Fiyat, title ve tarih 3 adet öğe Cardın içerisinde bulunacak. Onları nasıl yerleştireceğiz?
              //başta fiyat, sağında da titla ve fiyat üst üste konumlandıracağız. Bu durumda yatay konumlanacak 2 öğe için Row() kullanılır.
              //Sol tarafta en başta fiyatın görünmesi için Container() kullanmamız gerekli. Tek başına fiyatı kullanacağımız ve görsel düzenleme
              //imkanı verdiği için Container seçtik.
              //Sağ tarafta title ve tarihi alt alta sıralamamıza imkan veren tek widget Column(). Bu yüzden de Column kullandık.
              return Dismissible( key: ValueKey(transactions),  onDismissed: (direction) => iddelete(transactions[index].id), 
              //dismissible kaydırarak kaldırılabilen widgetlardır. key gereklidir, buradaki anahtarımız ise transactionstır. index ile 
              //idye yol gostererek silme işlemini aşağıda olduğu gibi gerçekleştirmiş oluyoruz.

              //Key konusu detaylı anlatım(Konudan bağımsız). Çoğu zaman bir state oluşturduğumuzda, bunu etkileşime geçebildiğin bir
              //liste olarak düşünebilirsin, flutter widgetı tamamen render etmez. State değiştiğinde herşeyi değiştirmek yerine 
              //listede değişen ney ise sadece içeriğe odaklanır. Fakat örneğin, başına tik atabildiğimiz bir Widget'ı kullandığımızda
              //Listenin sırasını değiştirsekte tik hala aynı yerde kalır. Bunun sebebi Widget ismi ile Element'in isminin aynı olması
              //Bu sebepler, Widgetta da bir değişiklik olduğunu fluttera iletmemiz için Key kullanıyoruz. Örneğin yukarıda yana kaydır
              //dığımızda silinecek olan objelerin transactions olduğunu belirtiyoruz. ValueKey() yada ObjectKey(), key seçimi yapmamıza
              //yardım eder. Buradaki en önemli husus, seçilecek keyin unique olmasıdır, taklit edilememelidir.
              
                child: Card(
                  elevation: 3,
                  child: ListTile(
                      leading: CircleAvatar(
                        //leading: ilk gösterilecek olan nesneyi ifade eder.
                        radius: 30, //dairenin etki alanı
                        backgroundColor: Theme.of(context).primaryColor,
                        //ThemeDatadan veri çekiyoruz
                        foregroundColor: Colors.white,
              
                        child: Padding(
                          //daire ile içindeki nesne arasındaki boşluğu ayarlıyoruz
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            //dairenin içindeki nesneyi daireye sığdırmaya yarıyor
                            child: Text("\$${transactions[index].amount}"),
                          ),
                        ),
                      ),
                      title: Text(
                        //Title Leadingten sonra gelen başlığı ifade eder.
                        transactions[index].title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                          //titledan sonra gelen altbaşlıkta subtitle'dır.
                          DateFormat.yMMMd().format(transactions[index].date)),
                      trailing: MediaQuery.of(context).size.width > 450
                      //genişliğe göre if döngüsü, yeterli alan varsa aşağıdaki yazılı texbutton ekranda gösterilecek. 
                      //eğer yeterli alan yoksa standart silme ikonumuz görüntülenecek.
                          ? TextButton.icon(
                            style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.purple)),
                              onPressed: () => iddelete(transactions[index].id),
                              icon: Icon(Icons.delete),
                              label: Text("Delete Transcation"))
                          : IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => iddelete(transactions[index].id),
                              color: Colors.purple)
                      //trailing listtileda en sona gelen komut, icon button koyduk. Anonim fonsiyonu çağırdık. transactions[index].id ile
                      //_userTransactions[element].id yi eşleştirdik
              
                      ),
                ),
              );

              // return Card(
              //   //return yapmamızın sebebi buradaki kaydırılabilir listeyi sadece transactionsların olduğu listeye döndürmek
              //   elevation: 3,
              //   child: Row(
              //     children: [
              //       (Container(
              //         margin: EdgeInsets.symmetric(
              //             vertical: 10,
              //             horizontal:
              //                 15) // Margin, container kutusnun etrafındaki boşluğun genişliğini ayarlamaya yarar.
              //         ,
              //         decoration: BoxDecoration(
              //             //Containerı dekore etmeye yarar
              //             border: Border.all(
              //                 color: Theme.of(context).primaryColor,
              //                 width:
              //                     2)), //Containerın etrafındaki kutuyu çizdik
              //         padding: EdgeInsets.all(
              //             10), //Padding kutu ve child arasındaki boşluğu oluşturmakta kullanılır.
              //         child: Text(
              //           "\$${transactions[index].amount.toStringAsFixed(2)}", //tx.amount.toString() bu stringi çağırmak için kısaltma kullandık.
              //           //As fixed, kesirli sayı değil de 2 basamaklı sayı çağırmak için kullandık. Başına koyduğumuz ters slaş ise
              //           //ilk dolar işaretinin simge olan $ şeklinde çağırıldığını ifade etmek için. TL için gerek yoktur. Çünkü $ işareti kısaltmada
              //           //fonksiyonel olarak kullanılıyor dart dilinde. Uzun yolu  "\$" + tx.amount.toString() kısaltması  "\$${tx.amount}"
              //           //toStringasFixed stringe cevrilip ekranda görüntülenecek rakamın kaç adet basamaktan oluşacağını gösterir
              //           //böylece ekranda görüntü kirliliği yaşamamış oluruz

              //           style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 16,
              //               color: Theme.of(context).primaryColor),
              //         ),
              //       )),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(transactions[index].title,
              //               style: Theme.of(context).textTheme.titleLarge),
              //           Text(
              //               DateFormat.yMMMd().format(transactions[index]
              //                   .date), // tx.date.toString insanların okuması için zor bir komut. Bunun yerine intl
              //               //isimli paket ile tarih saat tarzı verileri lokalleştirme imkanı tanıyan paket kullandık.
              //               //DateFormat bu paketle geliyor. Detaylar için pub.dev'den bu paketin kullanımı ve lokalleştirmeyi incele.
              //               //Lokalleştirme için Flutter Internationalizing kısmından yerelleştirmeye bak. Denedim adımlar çalışıyor.
              //               style:
              //                   TextStyle(color: Colors.grey, fontSize: 12))
              //         ],
              //       )
              //     ],
              //   ),
              // );
            },
            itemCount: transactions
                .length, //Kaç tane argümanın oluşturulacağını söyler, bizim için bu değer transactions liste
            //'sinin uzunluğudur.
          );
    //);
  }

  
}

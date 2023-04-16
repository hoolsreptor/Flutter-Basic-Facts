import "package:flutter/material.dart";

class ChartBar extends StatelessWidget {
  final String Label;
  final double spending;
  final double spendingPctofTotal;

  ChartBar(this.Label, this.spending, this.spendingPctofTotal);

  @override
  Widget build(BuildContext context) {
    //Column döndürdük, çünkü barımızın üstünde 3 adet üst üste duracak öğe olacak.
    return LayoutBuilder(builder: (ctx, constraint) {

//LayBuilder sayesinde her cihaz için barımızın ekranda ne kadar alan kaplayacağını ayarlıyoruz. Bu sayede farklı ebat ve boyutlardaki
//cihazlarda da uygulamamız istediğimiz gibi görünür. Buradaki amaç iki argüman ve bu argümanlar CTX ve constraint. Constraint builder
// metodu ile maksimum yükseklik ve genişlik ayarlarını yapabiliriz. Bir sayısı kullanılabilir alanın tamamını temsil eder.
// Yükseklik ya da genişlik değeri paylaştırırken bu bir sayısını aklımızda tutarak bölme işlemlerini yapmalıyız.
//LayoutBuilder Metodunu kullandıktan sonra inşa ettiğimiz tüm her şeyde yükseklik değerleri için constrain.t kullanacağız

      return Column(
        children: <Widget>[
          Container(
            height:
                constraint.maxHeight * 0.15, //height vermemizin sebebi, aşağıdaki barların fittedbox alanını işgal etmesi
            child: FittedBox(
              //FittedBox ile birlikte String ne kadar uzun olursa olsun, String için ayrılan alandan dışarı taşmasını engeller.
              //Bu sayede uygulama daha estetik görünür.
              child: Text(
                "\$${spending.toStringAsFixed(0)}",
              ),
            ),
          ), //barın üzerinde bir adet dolar işareti istiyoruz. Bunun için spending fonksiyonunu kullandık.
//toStringAsFixed ise ondalık sayı halinden kaçınmak ve tek basamak olarak fluttera iletmek için kondu.
          SizedBox(
              height:
                  constraint.maxHeight * 0.05), //SizedBox'u daha önce de kullandık. sadece iki öğe arasına boşluk koymak için kullanıyoruz.
          Container(
            //Container asıl dinamik barımızı tutacak olan widgetımız.
            height: constraint.maxHeight * 0.6,
            width: 13,
            child: Stack(
              //İçinin kısmi olarak dolu olmasını istediğimiz barı oluşturan şey işte bu Stack() widgetı. Stack widgetı
              //birbirinin üstüne elementler koymamıza izin verir örneğin 3 boyulu bir alan gibi. Column gibi birbirinin üzerine çıkmak değil de
              //üst üste binmesine, örtüşmesine izin verir
              children: <Widget>[
                //CHILDREN OLARAK EKLEDİĞİMİZ İLK WIDGET ÜSTÜSTE BİNENLER ARASINDA EN AŞAĞIDAKİ OLACAKTIR UNUTMA
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Color.fromRGBO(211, 211, 211,
                          1), //kutucukların içindelight gray elde etmek için böyle yaptık. Sondaki bir o
                      borderRadius: BorderRadius.circular(
                          20) //bunun amacı containerın kenarlarını oval yapabilmek için.
                      ),
                ),
                FractionallySizedBox(
                  //verilen kesire göre yeniden şekillenen bir widgettır.
                  heightFactor: //yüksekliğin neye göre belli olacağı.
                      spendingPctofTotal, //burada vereceğimiz değere göre FractionallySized box, containerı çevreler.
                  //1 %100 çevreler, 0 verirsek hiç çevrelemez. Biz ise harcamaların toplam yüzdesine göre bu kutunun şekillenip
                  //grafik oluşturmasını istiyoruz. Bu yüzden spendingPctofTotal kullandık.
                  child: Container(
                    //yukarıdaki container ile aynı kenarlıkları ve değerleri uyguladık ki iç içe geçtiğinde uyumsuz olmasın
                    //Renk olarak theme colorı seçtik, bu şekilde kesirli olarak oluşacak bu kutunun aldığı renke
                    //Genel temamızın rengi uyumlu olacak.
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          Container(height: constraint.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                  Label),
            ),
          ) // Barımızın altındaki bu String Label sadece weekDayi tutacak.
        ],
      );
    });
  }
}

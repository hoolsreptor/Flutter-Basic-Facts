import 'dart:io'; //platform araçlarını import eder.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import './Widgets/transactionslist.dart';
import './Widgets/userinput.dart';
import './models/transactions.dart';
import './Widgets/chart.dart';

void main() {
  //aşağıdaki komutlar landscape modunu kapatmaya yarar.
  // WidgetsFlutterBinding();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses", //uygulamanın arkaplan ismi
      theme: ThemeData(
          //ThemeDataya eklediğin her rengi her şeyde, buton, text, arkaplan. Kullanabilirsin, sadece default değer
          //buradan manuel olarak değiştirmelisin text için textTheme'de olduğu gibi.
          //Ardında kullanmak istediğin terde Theme.of(context)....  duruma göre doldurarak devam edebilirsin.

          //fontlar, renkler gibi görsel ayarların tüm widgetlara uygulanmasından sorumludur.
          primaryColor: Colors.purple,
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary:
                  Colors.purple), //ikincil renktir, örneğin default rengi olan
          //floating button böylece değişmiş olur.
          //primaryColor: tek bir renk belirler
          fontFamily: "Quicksand",
          textTheme: ThemeData.light().textTheme.copyWith(
              bodyMedium: TextStyle(
                  color: Colors.purple,
                  fontSize: 15,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold),
              titleSmall: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: "Quicksand"),
              titleLarge: TextStyle(
                  //Uygulamada kullanılacak global yazı tipi ayarlarını belirtir. Kullanacağın yerde
                  //Theme.of(context).textTheme.titleLarge) komutunu kullanman yeterli. Ayarları buradan değiştirebilirsin.
                  fontFamily: "OpenSans",
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              color: Colors.purple,
              //AppBarlar için kullanılan yazı tipi ayarlarını tek bir yerden yönetmeye yarar
              titleTextStyle: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transactions> _userTransactions = [
    // //bu listenin burada olmasının sebebi void fonsiyonu ile yeni bir state oluşturmamızı
    // //sağlayacak olmasıdır.
    // Transactions(
    //   id: "t1",
    //   title: "New Shoes",
    //   amount: 95.99,
    //   //DateTime.now() kullanılması, bu özel flutter özelliğinde bugün için tarih belirlttiğimizi darta iletir
    //   date: DateTime.now(),
    // ),
    // Transactions(
    //   id: "t2",
    //   title: "Pants",
    //   amount: 54.99,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transactions> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList(); //where bir fonksiyonu listenin tamamında uygulamamızı sağlar. Bu fonsiyon true olursa
//öğe yeni oluşturulan listeye return edilir. False ise bu yeni listeye dahil edilmez. Tx elementini eğer işlem bir hafta
//önce gerçekleşti ise true yapmak istiyoruz. Eğer bir haftadan eskiyse false yapmak istiyoruz.
//tx.date, DateTime.now dan sonra geliyorsa true olur. 7 günlük bir ölçü istediğimz için duration 7
  }

  void _addNewTransactions(
      String txTitle, double txAmount, DateTime chosenDate) {
    //burada amaç onpressed yaptığımız zaman  çağıracağımız void fonksiyonu
    //oluşturmak. newTx ile yeni oluşturacağımız liste için transactions classıyla eşleştirme yapıyoruz.
    final newTx = Transactions(
        title: txTitle,
        amount: txAmount,
        date:
            chosenDate, // DateTimei buraya bağlayarak seçtiğimiz tarihe göre listenin yeniden oluşturulmasını sağlıyoruz
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(
          newTx); // private ve final value değiştirmeden listenin içeriğini manipüle ederiz. Değer final, ancak içeriği
      //liste bir variable değil.
      //burada Transactions() listesinin içindeki değerler manipüle edilerek state oluşturuluyor. Bu sayede yeni girdi
      //ekleme butonuna basınca manipüle edilmiş listedeki değerleri görütüleyebileceğiz
    });
  }

  void _deletetransacions(String id) {
//String türü argüman kullandığımız için string. Liste manipüle etmek için .removeWhere kullandık.
// element.id transactions listteki id buu idye eşitleyerek başlangıç noktasına geri döndürmüş oluyoruz
// bu sayede bu void call bak bize listedeki bir öğeyi silmemize olanak sağlıyor.
    setState(() {
      _userTransactions.removeWhere((element) {
        return element.id == id;
      });
    });
  }

//Showbottomsheet aşağıdan yeni bir sayfa açabiliyor. void fonskiyona tüm içerikte olduğundan buildcontext atadık.
//Çünkü showmodalbottom sheet context istiyor. ardından showmodalbottomsheetse ilettiğimiz içeriği UserInput'a döndürüyoruz,
//tabii setState fonksiyonumuz ile. Bu sayede alttan açılan  menüde yeni transactions eklediğimiz ekranı elde edebiliyoruz.
//Gesture dedektör ile arka planda kalan floating buttona bastığımızda ekranın kapanmamasını sağlıyoruz. Opalık verdik
// onpressed null bıraktık
  void addNewUserInput(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: UserInput(_addNewTransactions));
        });
  }

  bool _showchart = true; //chartı göstermek için boolean oluşturduk

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    //bunu yapmamızın sebebi, her satırda MediaQuery.of(context) kullanarak render cycleını artırmak yerine bir final
    //fonksiyona atadık. Bu şekilde tek bir kez MediaQuery'yi çağırmış olduk.
    final isLandscaped = mediaQuery.orientation == Orientation.landscape;
    //isLandscaped booleanı responsiveness ayarlamak için yatay moda eşdeğer olduğunu belirtir

    //aşağıdaki final properyde appBar'ı storelamamızın amacı şudur, bu appBar ı hem iOS hem de Android için kullanmak istiyoruz
    //ancak, her iki Widgetın Material ve Cupertionun aldığı Widgetlar farklıdır.
    //appBar propertynin başına PrefferedSizeWidget koymamızın sebebi, her iki Material ve Cupertinoda bu Widget olmasına 
    //rağmen dart bunu ayırt edemez. Oluşturduğumuz appBar propertynin PrefferedSizeWidgetına sahip olduğunu belirtiyoruz
    //Platformu ve if döngüsünü kullandık. Bu sayede, appbar eğer iOs'te çalışıyorsa CupertinoNavigationBar widgetını tetikler
    //eğer androidde çalışıyorsa standart AppBarı
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text("Personal Expenses"),
//middle, Scaffolddaki title yani başlığa eşdeğerdir
            trailing:
//trailing ise actionsa eşdeğerdir, buton etc. widget ekleyebiliriz.
                Row(
//row kullanmamızın sebebi listile ile aynı, cupertinonavigationbarın çalışma prensibi biraz farklı                  
              mainAxisSize: MainAxisSize.min,
//mainAxisSize, bir Row yada Columnın içindeki öğelerin kapsayacağı maksimum alanı ifade eder
//burada appBar ile sınırlı kalması için minimumu tercih ettik. Bu sayede Rowdaki her öğe, alabilecekleri minimum genişliği alır.              
              children: <Widget>[
                GestureDetector(
//IconButton bir Material widgetı olduğu için burada kullanamadık. Onun yerine kendimiz için GestureDetector ile 
//bir buton oluşturduk. Icon logosu için de Cupertino tarzı icon kullandık                  
                  onTap: () => addNewUserInput(context),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text("Personal Expenses"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => addNewUserInput(context),
              )
            ], //actions: appBar için widget ekleyebileceğimiz komut
            //IconButton ise widgetımız
          );
    //App barı değişken olarak kaydetmemizin sebebip, her cihaz için uyumlu bir görüntüleme, responsiveness yapacağımız için appBarın
    //yükseklik değerine ihtiyacımız var. bir değişken olarak final appBar'ı kaydettiğimizde otomatik olarak yükseklik değeri de orada
    //saklanmış olur.

    final txListview = Container(
      //Burada listeyi final argümanına almamızın tek sebebi aşağıda kod kalabalığı yapmak istemememiz başka sebebi yok
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.77,
      child: TransactionList(_userTransactions, _deletetransacions),
    );

//aşağıda Scaffold bodyi pagebodye atamamızın sebebebi, Hem Material hem de Cupertino için kullanmak için.
    final pageBody = SafeArea(
      //özellikle iOSte çentik ve alt taraftaki çek bırak kısmı otomatik olarak rezerve alanlardır ve kullanılamazlar.
      //safearea bu alanları da hesaplamamıza dahil etmemizi sağlar, bu sayede uygulamamızın her cihaz için değişken
      //ebatlarını doğru bir şekilde ekrana yansıtmış oluruz.
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .start, //yukarıdan aşağıya pozisyon hizlamada kullanılır. Row için tam tersi
          crossAxisAlignment: CrossAxisAlignment
              .stretch, //soldan sağa pozisyonlama için kullanılır. Row için tam tersi
          children: <Widget>[
            //Card ekledikten sonra, yükselik ve genişlik ayarı Column üzerinden yapılamaz. Çünkü column içindeki objelerin örneğin
            //Bu durumda Text widgetinin uzunluğunu alır.
            //yükseklik ve genişlik gibi ayarlar için Container kullanılmalıdır. Containerı bir Columun childrenı olarak atayabiliriz
            //Veya Card'ın childreni olarak. Sonuç değişmez.
            //Detaylar için row column sheet dosyasına göz at.
    
            // Card(
            //   child: Container(
            //     width: double.infinity,
            //     color: Colors.blue,
            //     child: Text("CHART HERE!"),
            //   ),
    
            //   elevation:
            //       5, //elevation Card widgetında gölgelendirme için kullanılır.
            // ),
    
            //aşağıdaki if statementın farkı, eğer if döngüsü karşılanmazsa, otomatik olarak değer nulla döner
            if (isLandscaped)
              Row(
                //eğer yatay moddaysaki aşağıdaki switchimiz ve show chart yazımız çalışır
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //aşağıda texti özellikle düzenlememizin sebebi, Cupertino ile Material ın farklı themeingler kullanması
                  //cupertino da belirli themeing öğeleri kullanıyor ancak kısıtlı. Daha sonra buna tekrar döneceğim.
                  Text("Show Chart", style: Theme.of(context).textTheme.titleLarge,),
                  Switch.adaptive(activeColor: Theme.of(context).primaryColor,
                    //.adaptive, eğer uygulama iOS'te ise iOS tarzı switch oluşturur, androidde ise android tarzı switch oluşturur.
                    value: _showchart,
                    onChanged: (value) {
                      setState(() {
                        _showchart = value;
    
                        //Switch bir değer alır. Bu değeri yukarıda oluşturduğumuz boolean yaptık. onChange, değiştiğinde value anahtarını alan bi değişken.
                        //set state ile value ve showchartı eşitliyoruz.
                        //aşağıda ise showchar eğer true ise chartı göster diyoruz. Eğer false ise transaction list.
                      });
                    },
                  ),
                ],
              ),
    
            if (!isLandscaped)
              //eğer yatay modda değilsek büyük chartımızı görüntüleriz.
              Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.23,
                  child: Chart(_recentTransactions)),
            if (!isLandscaped)
              txListview, //eğer yatay modda değilsek transaction listemizi görntüleriz.
    
            if (isLandscaped)
              //eğer yatay moddaysak, switch açık ise chartımızı, değil ise transaction listemizi görürüz. Bu kadar basit...
              _showchart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : txListview
    
    //Yukarıda uygulamamızın her cihazda çalışabilmesi adına MediaQuery'i kullandık. Bu widget, uygulamanın her cihazda farklı yükselik ve
    //genişlik gibi değerlere adapte olabilmesi için vardır. Yukarıda Chart bara %40 ve listeye de %60 alan verdik. Bu alanın içerisinden
    //appBarı ve bildirim çubuğu boşluğunu düşmesini yukarıdaki komutlarla belirterek yaptık. Bu sayede uygulamamız tüm cihazlarda görünen
    //ekran alanının belirli yüzdesi boyunca çalışabilecek.
            //usertransactionsı tekrar _usertransactionsa bağladık
          ],
        ),
      ),
    );


//aşağıda yaptımız if döngüsünün amacı şudur. Eğer uygulamamız iOs ise iOS tarzı widgetlarla uygulamamızı yeniden oluşturmak,
//değilse standart Material Scaffold ile. 
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => addNewUserInput(context),
                    child: Icon(Icons.add),
//Platform. fonksiyonu Dart ile gelen bir komut. Yukarıda Dart:io ile import ettik.
//Eğer uygulamanın çalıştığı platform iOS ise, floating buttonu gösterme, if değilse, göster.
                  ),
          );
  }
}

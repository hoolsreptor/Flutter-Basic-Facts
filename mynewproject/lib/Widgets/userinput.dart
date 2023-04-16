import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "adaptive_textbutton.dart";

class UserInput extends StatefulWidget {
  final Function
      addTx; //manipüle edilmiş değerleri içeren statei tetikleyebilmek amacıyla oluşturduğumuz butona
  //eklemek için oluşturduğumuz bir fonksiyondur.

  UserInput(this.addTx);
  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  //String titleInput; Alternatif kullanıcı girdisi kaydetme yolu
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
  DateTime
      _thedateselected; //seçilen datei ekrana verebilmek için bu argümanı oluşturduk

  //pozisyonel argüman yaparak void _addnewtransaction ile eşleştiriyoruz.
  void addDirectly(String val) {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        enteredAmount == null ||
        _thedateselected == null) {
      //eğer girilen değerde title boş ise ya da değer 0 yada negatifse sonuç
      //boşluğa döner. yani gösterilemez
      return null;
    }

    widget.addTx(enteredTitle, enteredAmount,
        _thedateselected); //addDireclty'i addTx ile bağlayarak hem onSubmitted hem de onPressed ile kullanabiliyoruz.
    //widget. addTx sınıfına yukarıdaki UserInput classında da kullanmamızı sağlıyor.
    //Bu sayede yazı yazdığımızda ekrandaki yazıların silinmemesini sağlıyor.
    //Önemli bir class, burayı statelesstan stateful
    //widgeta çevirdiğimizde otomatik geldi.

    Navigator.of(context)
        .pop(); //en üstte görünen ekranın işlem bittiğinde otomatikmen kapanmasını sağlar. Burada addDirectly fonksiyonu
    //ile kullanmamızın sebebi de ekleme yaptıktan sonra kapanmasını sağlamak
  }

  void _calldatepicker() {
    showDatePicker(
            //tarih seçmemize yarayan bir widget
            context: context, //hangi contexti kullancağını seçersin
            initialDate: DateTime
                .now(), //tarih seçme ekranı açıldığında gösterilecek tarih
            firstDate: DateTime(2023), //Listenin başlangıç tarihini belirtir
            lastDate: DateTime.now()) //en son gösterilecek tarihi gösterir
        .then((value) {
      // .then() fonsiyonu, kullanıcı bir tarih seçtiğinde bu değer (value)ye kaydedilir.
      if (value == null) {
//Eğer bir tarih seçilmemişse tekrar nulla döndürüyoruz.
        return null;
      }

      setState(() {
//bir tarih seçilmişse, daha önceden oluşturduğumuz DateTime _thedateselected üzerine bu datayı kaydetmek için valueye
//eşit hale getiriyoruz. Bu sayede valuenin aldığı değer _thedateselectede geçiyor.
        _thedateselected = value;

//dateselected, value ile eşitlendiği an setStatei tetikler ve ekranda yeni tarih belirir.
      });
    });
  }

  Widget build(BuildContext context) {
    return //Card sadece bir tek child alabilir. Ancak kullanıcı birden fazla transaction uygulamaya girebilir. Bu durumu nasıl çözeriz?
        //Cevap basit, Column sınırsız child, yani children alabilir. Column'a children olarak yukarıda oluşturduğumuz transactions'ı
        //map sistemiyle ekleyerek, Card'a return komutuyla geriye döndürürsek problem çözülmüş olur.
        //map her zaman listenin tüm öğeleri üzerinde çalışan bir fonsiyon alır. İşlemleri kullanacağımız için transactions kısaltması tx
        //tx kullandık. Transaction listesi içindeki title'i almak istediğimiz için Card'a return ederken tx.title ile listeden
        //hangi değeri almak istediğimizi darta belirttik.
        SingleChildScrollView(
      //Kaydırılabilir yapmamızın sebebi, klavyeyi açtığımız zaman ekrandaki öğelerin arka planda erişilebilir olmasını sağlamak.
      child: Card(
        //kullanıcının veri gireceği bir kart oluşturduk.
        elevation: 5,
        child: Container(
            //Oluşturduğumuz sütunları görsel olarak özelleştirmek için container kullandık.
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 10,
                right: 10,
                top: 10),
            //padding ile alt kısımdan çıkan klavyenin ekranı kapatmamasını ve arka plan öğelerinin kaydırılabilir fonksiyonunu
            //daha kullanışlı hale getiriyoruz.
            child: Column(
              // title ve Amountu alt alta sıralamak için column kullandık.
              crossAxisAlignment: CrossAxisAlignment
                  .end, // ekrandaki sütunları sağ tarafa almak için kullandık.
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText:
                          "Title"), //TextField'a başlık atamak için kullanılır.
                  controller:
                      _titleController, //girdileri nerede saklayacağımızı gösteren controller widgetini kullanarak yukarıda
                  //oluşturduğumuz titleController classına geri döndürdük.
                  onSubmitted: addDirectly,
                ), //TextField kullanıcıların girdilerini girebileceği
                //bir widget.
                TextField(
                  decoration: InputDecoration(labelText: "Amount"),
                  controller: _amountController,
                  keyboardType: TextInputType
                      .number, //bunun amacı Amount kısmına rakam girdiğimizde ekrandaki klavyede sadece rakam çıkması,
                  onSubmitted: addDirectly,
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        flex:
                            2, //ekranda yerleştirme yapmak için kutucuğa 2 birimlik yer veriyoruz
                        child: Text(
                          _thedateselected == null
                              ? "No date chosen!"
                              : "Date Selected: ${DateFormat.yMd().format(_thedateselected)}",
                          //Date Selected: seçilen tarihi gösterebilmek için string içinde string kullandık,

                          style: TextStyle(
                              fontFamily: "OpenSans",
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex:
                            1, //yukarıdaki Texte kıyasla 1 birimlik yer alıyor. Bu sayede Text, buradaki butonu sıkıştırarak bize alan veriyor
                        child: AdaptiveTextButton("Choose Date", _calldatepicker),
                        //kod kalabalığı yapmamak için birbirini tekrar eden kodlar için örneğin adaptive öğeleri içeren ayrı bir widget
                        //kullanarak o widgetı burada kullandık
                      )
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () => addDirectly(
                      "val"), //addDirectly'nin string function olduğunu belirtiyoruz
                  //addTx(titleController.text, //Textfieldda kullandığımız controller sayesinde girilen verilerle oluşturulacak yeni statei tetikliyoruz
                  //double.parse(amountController.text)); //double.parse, stringi double a çeviren bir argüman. Karşılığı double olmalı

                  // style: TextButton.styleFrom(
                  //     foregroundColor: Theme.of(context).primaryColorLight)
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text("Add Transactions",
                      style: Theme.of(context).textTheme.titleSmall),
                )
              ],
            )),
      ),
    );
  }
}

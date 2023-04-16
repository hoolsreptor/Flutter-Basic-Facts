//material.dart ile de import edilebilir ancak @required komutu foundatiom.dartın  material içerisinde sonda olması sebebiyle
//foundation daha hızlı render edilir
import 'package:flutter/foundation.dart';

class Transactions {
  final String id;
  final String title;
  final double amount;
  DateTime date;
  //DateTime, tarih belirtilmek için flutterın bize sunduğu özel bir komuttur.
  

  Transactions(
    // Burada named yada positional argument ikisi de kullanılabilir. Ancak named argument kullanmak işlemler için daha kolay
    //olacağı için named kullanacağız. Bunun için argümanları {} işaretinin içinde yazarak named olduğunu darta belirtiriz.
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});
}

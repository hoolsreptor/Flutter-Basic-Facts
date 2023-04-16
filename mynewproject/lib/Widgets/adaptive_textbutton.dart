import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//kod kalabalığı yapmamak için birbirini tekrar eden kodlar için örneğin adaptive öğeleri içeren ayrı bir widget
//kullanarak performansı iyileştirmeyi ve kodu okumayı kolaylaştırdık
//bu metod çoğu cupertino widgetta çalışır

class AdaptiveTextButton extends StatelessWidget {
  final String text;
  final Function datepicker;

  AdaptiveTextButton(this.text, this.datepicker);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: datepicker, //datepicker widgetini harekete geçirmek için
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ))
        : TextButton(
            onPressed: datepicker, //datepicker widgetini harekete geçirmek için
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ));
  }
}

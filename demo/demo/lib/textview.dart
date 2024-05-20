import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonTextView extends StatelessWidget {

  final text;

  CommonTextView(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,style: TextStyle(

      fontWeight: FontWeight.w500
    ),

    ).marginOnly(bottom: 5);
  }
}

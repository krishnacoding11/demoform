import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithBox extends StatelessWidget {
  final controller;
  final hint;
  final onChanged;
  final textInPut;
  final isPhoneNumber;

  TextFieldWithBox(this.controller, this.hint,this.onChanged,this.textInPut,{this.isPhoneNumber = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: textInPut,
      inputFormatters: isPhoneNumber?[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        // PhoneNumberFormatter(),

      ]:[

        LengthLimitingTextInputFormatter(250),

      ],
      decoration: InputDecoration(
        hintText: hint,
        fillColor: Colors.grey[100],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regExp = RegExp(r'^(\d{0,3})(\d{0,3})(\d{0,4})$');
    final StringBuffer newText = StringBuffer();

    if (newValue.text.isNotEmpty) {

    }
    return newValue.copyWith(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'form_controller.dart';

class DescriptionTextFieldWithBox extends StatelessWidget {
  final controller;
  final hint;
  final FormController formController;

  DescriptionTextFieldWithBox(this.controller, this.hint, this.formController,{super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.0),

      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,

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
          ),

          GetBuilder(builder: (controller) => Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${controller.textLength}/300",style: TextStyle(

                fontWeight: FontWeight.w400, color: Colors.grey
            ),

            ),
          ).paddingAll(15),init: FormController(),)
        ],
      ),
    );
  }
}

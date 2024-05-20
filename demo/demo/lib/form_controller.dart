import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FormController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final issueController = TextEditingController();
  final issueDescController = TextEditingController();
  int textLength = 0;

  void submitForm(BuildContext context) {
    if (checkEmptyValue(nameController.text) &&
        checkEmptyValue(emailController.text) &&
        checkEmptyValue(contactController.text) &&
        checkEmptyValue(issueController.text) &&
        checkEmptyValue(issueDescController.text)) {

      if (isEmailValid(emailController.text)) {


        if(files.isEmpty){
          _showErrorDialog(context, "Attach Files", "Please select at least 1 file");

        }else{


          _showErrorDialog(context, "Success", "Form submit successfully",function: (){
            nameController.clear();
            contactController.clear();
            emailController.clear();
            issueDescController.clear();
            issueController.clear();
            textLength = 0;
            files = [];
            update();
          });
        }

      } else {
        _showErrorDialog(context, "Email", "Please enter valid email");
      }
    } else {
      String message="Please enter name";
      if(!checkEmptyValue(nameController.text)){
        message="Please enter name";
      }else if(!checkEmptyValue(contactController.text)){
        message="Please enter contact";
      }else if(!checkEmptyValue(emailController.text)){
        message="Please enter email";
      }else if(!checkEmptyValue(issueController.text)){
        message="Please enter issue title";
      }else if(!checkEmptyValue(issueDescController.text)){
        message="Please enter issue description";
      }
      _showErrorDialog(context, "Value", message);
    }
  }

  bool checkEmptyValue(String text) {
    return text.isNotEmpty;
  }

  bool isEmailValid(String email) {
    // Regular expression pattern for email validation
    // This pattern is a simplified version and may not cover all edge cases
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void _showErrorDialog(BuildContext context, String title, String message,{Function? function}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {

                if(function!=null){
                  function();
                }
                FocusScope.of(context).unfocus();

                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    issueDescController.addListener(_updateTextLength);
  }

  String getFileName(String filePath) {
    List<String> parts = filePath.split('/');
    return parts.last;
  }

  List<File> files = [];

  void _updateTextLength() {
    textLength = issueDescController.text.length;
    update();
  }

  Future<void> pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      if (result.files.length > 4) {
        // Show a message if more than 4 files are selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You can only select up to 4 files.')),
        );
        return;
      }

      if (files.isNotEmpty) {
        files.addAll(result.paths.map((path) => File(path!)).toList());
      } else {
        files = result.paths.map((path) => File(path!)).toList();
      }

      update();
    }

    update();
  }

  @override
  void onClose() {
    issueDescController.removeListener(_updateTextLength);

    nameController.dispose();
    emailController.dispose();
    issueDescController.dispose();
    issueController.dispose();
    contactController.dispose();

    super.onClose();
  }
}

import 'dart:io';

import 'package:demo/demo.dart';
import 'package:demo/textfiled.dart';
import 'package:demo/textview.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart' as drag;
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'descriptiontextfiled.dart';
import 'form_controller.dart';

class FormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FormController formController = Get.put(FormController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Form'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formController.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextView("Name"),
                TextFieldWithBox(formController.nameController, "Enter here..",
                        (value) {}, TextInputType.name)
                    .marginOnly(bottom: 15),
                CommonTextView("Contact Number"),
                TextFieldWithBox(
                  formController.contactController,
                  "Enter here..",
                  (value) {},
                  TextInputType.phone,
                  isPhoneNumber: true,
                ).marginOnly(bottom: 15),
                CommonTextView("Email ID"),
                TextFieldWithBox(formController.emailController, "Enter here..",
                        (value) {}, TextInputType.emailAddress)
                    .marginOnly(bottom: 15),
                CommonTextView("Issue Title"),
                TextFieldWithBox(formController.issueController, "Enter here..",
                        (value) {}, TextInputType.name)
                    .marginOnly(bottom: 15),
                CommonTextView("Issue Description"),
                DescriptionTextFieldWithBox(formController.issueDescController,
                        "Enter here..", formController)
                    .marginOnly(bottom: 15),
                CommonTextView("Attach File"),
                GetBuilder(
                  builder: (controller) {
                    return kIsWeb
                        ?
                    DropTarget(
                            onDragDone: (detail) async {

                              // formController.files.addAll(detail.files.map((path) => File(path.path)).toList());
                              // formController.update();
                              // if (detail.files.length > 4) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(content: Text('Only up to 4 files were added.')),
                              //   );
                              // }
                              if (formController.files.length < 4) {
                                // Iterate over each file in the dropped files
                                for (final path in detail.files.map((path) => path.path)) {
                                  // Check if the file already exists in the list
                                  bool fileExists = formController.files.any((file) => file.path == path);
                                  // If the file doesn't exist and the file count is less than 4, add it to the list
                                  if (!fileExists && formController.files.length < 4) {
                                    formController.files.add(File(path));
                                  }
                                }
                                // Update the UI
                                formController.update();
                              } else {
                                // Optionally, you can display a message to the user indicating that only 4 files can be uploaded
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('You can only upload up to 4 files.')),
                                );
                              }
                              debugPrint('onDragDone:');
                              for (final file in detail.files) {
                                debugPrint('  ${file.path} ${file.name}'
                                    '  ${await file.lastModified()}'
                                    '  ${await file.length()}'
                                    '  ${file.mimeType}');
                              }
                            },
                            onDragUpdated: (details) {},
                            onDragEntered: (detail) {},

                            onDragExited: (detail) {},
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10.0),

                              ),
                              child: Stack(
                                children: [
                                  if (formController.files.isEmpty)
                                    // const Center(child: Text("Drop here"))
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.upload,
                                            color: Colors.grey,
                                          ),
                                          const Text(
                                            "Drag Files to upload",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ).marginOnly(bottom: 5),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Or, ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'Click here',
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {},
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.brown,
                                                      fontSize: 12),
                                                ),
                                                const TextSpan(
                                                  text: ' to browse',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Wrap(
                                        runSpacing: 8,
                                        spacing: 8.0,
                                        children:
                                        formController.files.map((item)
                                        // formController.files.take(4).map((item)
                                             {
                                          return Chip(
                                            label: Text(
                                                formController
                                                    .getFileName(item.path),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                    fontSize: 12),),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              color: Colors.grey,
                                              size: 12,
                                            ),
                                            onDeleted: () {
                                              formController.files.remove(item);
                                              formController.update();
                                              print("dfdf");
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
//todo code : commit
                        // Container(
                        //             height: 150,
                        //             width: double.infinity,
                        //             decoration: BoxDecoration(
                        //               color: Colors.grey[100],
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Stack(
                        //               children: [
                        //                 drag.DropzoneView(
                        //                   operation: drag.DragOperation.copy,
                        //                   cursor: drag.CursorType.grab,
                        //                   onHover: () {
                        //                     // Handle hover events
                        //                     print('Dropzone hovered');
                        //                   },
                        //                   onDropMultiple: (value) {},
                        //                   onLoaded: () => print('Zone loaded'),
                        //                 ),
                        //                 Center(
                        //                   child: Column(
                        //                     mainAxisSize: MainAxisSize.max,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.center,
                        //                     children: [
                        //                       Icon(
                        //                         Icons.upload,
                        //                         color: Colors.grey,
                        //                       ),
                        //                       Text(
                        //                         "Drag Files to upload",
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.w500,
                        //                             color: Colors.grey,
                        //                             fontSize: 12),
                        //                       ).marginOnly(bottom: 5),
                        //                       RichText(
                        //                         text: TextSpan(
                        //                           text: 'Or, ',
                        //                           style: TextStyle(
                        //                               fontWeight: FontWeight.w500,
                        //                               color: Colors.grey,
                        //                               fontSize: 12),
                        //                           children: <TextSpan>[
                        //                             TextSpan(
                        //                               text: 'Click here',
                        //                               recognizer:
                        //                                   TapGestureRecognizer()
                        //                                     ..onTap = () {
                        //                                       FocusScope.of(context)
                        //                                           .unfocus();
                        //
                        //                                       formController
                        //                                           .pickFile(
                        //                                               context);
                        //                                     },
                        //                               style: TextStyle(
                        //                                   fontWeight:
                        //                                       FontWeight.w600,
                        //                                   color: Colors.brown,
                        //                                   fontSize: 12),
                        //                             ),
                        //                             TextSpan(
                        //                               text: ' to browse',
                        //                               style: TextStyle(
                        //                                   fontWeight:
                        //                                       FontWeight.w500,
                        //                                   color: Colors.grey,
                        //                                   fontSize: 12),
                        //                             )
                        //                           ],
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 )
                        //               ],
                        //             ),
                        //           ).marginOnly(bottom: 15)
                        : formController.files.isEmpty
                            ? Container(
                                height: 150,
                                alignment: Alignment.center,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.upload,
                                      color: Colors.grey,
                                    ),
                                    const Text(
                                      "Drag Files to upload",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 12),
                                    ).marginOnly(bottom: 5),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Or, ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                            fontSize: 12),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Click here',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                FocusScope.of(context)
                                                    .unfocus();

                                                formController
                                                    .pickFile(context);
                                              },
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.brown,
                                                fontSize: 12),
                                          ),
                                          const TextSpan(
                                            text: ' to browse',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )).marginOnly(bottom: 15)
                            : Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Wrap(
                                      spacing: 8.0,
                                      children:
                                          formController.files.map((item) {
                                        return Chip(
                                          label: Text(
                                              formController
                                                  .getFileName(item.path),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                            size: 12,
                                          ),
                                          onDeleted: () {
                                            formController.files.remove(item);
                                            formController.update();
                                            print("dfdf");
                                          },
                                        );
                                      }).toList(),
                                    ),
                                    formController.files.length < 4
                                        ? Align(
                                            alignment: Alignment.bottomRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();

                                                formController
                                                    .pickFile(context);
                                              },
                                              child: const Text(
                                                'Add More',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.brown,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                )).marginOnly(bottom: 15);
                  },
                  init: FormController(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    formController.submitForm(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.brown),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

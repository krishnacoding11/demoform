// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cross_file/cross_file.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:flutter/foundation.dart' show kIsWeb;
// //
// // import 'package:desktop_drop/desktop_drop.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cross_file/cross_file.dart';
// //
// // class DragAndDropExample extends StatelessWidget {
// //   const DragAndDropExample({super.key});
// //
// //   void loadFile(BuildContext context, bool bookmarkEnable) async {
// //     final SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? jsonStr = prefs.getString("apple-bookmark");
// //     if (jsonStr == null) return;
// //     print(jsonStr);
// //     Map<String, dynamic> data = json.decode(jsonStr);
// //     String path = data["path"]! as String;
// //     String appleBookmarkStr = data["apple-bookmark"]! as String;
// //     Uint8List appleBookmark = base64.decode(appleBookmarkStr);
// //
// //     try {
// //       if (bookmarkEnable) {
// //         bool grantedPermission = await DesktopDrop.instance
// //             .startAccessingSecurityScopedResource(bookmark: appleBookmark);
// //
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //             content: Text(
// //               "file permission :" + grantedPermission.toString(),
// //             )));
// //       }
// //
// //       var file = File('$path');
// //
// //       var contents = await file.readAsBytes();
// //       var fileSize = contents.length;
// //
// //       if (bookmarkEnable) {
// //         await DesktopDrop.instance
// //             .stopAccessingSecurityScopedResource(bookmark: appleBookmark);
// //       }
// //
// //       final snackBar =
// //       SnackBar(content: Text('file size:' + fileSize.toString()));
// //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
// //     } catch (e) {
// //       final snackBar = SnackBar(content: Text('error:' + e.toString()));
// //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Plugin example app'),
// //         ),
// //         body: Wrap(
// //           direction: Axis.horizontal,
// //           runSpacing: 8,
// //           spacing: 8,
// //           children: [
// //             ExampleDragTarget(),
// //             ExampleDragTarget(),
// //             ExampleDragTarget(),
// //             ExampleDragTarget(),
// //             ExampleDragTarget(),
// //             ExampleDragTarget(),
// //             if (!kIsWeb && Platform.isMacOS)
// //               StatefulBuilder(builder: (context, setState) {
// //                 return Column(
// //                   children: [
// //                     Text(
// //                       "Test Apple Bookmark\n1 drag file \n2 save the bookmark,\n3 restart app\n4 choice test button",
// //                     ),
// //                     TextButton(
// //                       onPressed: () async {
// //                         loadFile(context, true);
// //                         return;
// //                       },
// //                       child: Text(
// //                         "with applemark, suc",
// //                       ),
// //                     ),
// //                     TextButton(
// //                       onPressed: () async {
// //                         loadFile(context, false);
// //                         return;
// //                       },
// //                       child: Text(
// //                         "without applemark, err",
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               }),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class ExampleDragTarget extends StatefulWidget {
// //   const ExampleDragTarget({Key? key}) : super(key: key);
// //
// //   @override
// //   _ExampleDragTargetState createState() => _ExampleDragTargetState();
// // }
// //
// // class _ExampleDragTargetState extends State<ExampleDragTarget> {
// //   final List<XFile> _list = [];
// //   final List<DropItem> drop_files = [];
// //
// //   bool _dragging = false;
// //
// //   Offset? offset;
// //
// //   Future<void> printFiles(List<DropItem> files, [int depth = 0]) async {
// //     debugPrint('  |' * depth);
// //     for (final file in files) {
// //       debugPrint('  |' * depth +
// //           '> ${file.path} ${file.name}'
// //               '  ${await file.lastModified()}'
// //               '  ${await file.length()}'
// //               '  ${file.mimeType}');
// //       if (file is DropItemDirectory) {
// //         printFiles(file.children, depth + 1);
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DropTarget(
// //       onDragDone: (detail) async {
// //         setState(() {
// //           _list.addAll(detail.files);
// //           drop_files.addAll(detail.files);
// //         });
// //
// //         debugPrint('onDragDone:');
// //         await printFiles(detail.files);
// //       },
// //       onDragUpdated: (details) {
// //         setState(() {
// //           offset = details.localPosition;
// //         });
// //       },
// //       onDragEntered: (detail) {
// //         setState(() {
// //           _dragging = true;
// //           offset = detail.localPosition;
// //         });
// //       },
// //       onDragExited: (detail) {
// //         setState(() {
// //           _dragging = false;
// //           offset = null;
// //         });
// //       },
// //       child: Container(
// //         height: 200,
// //         width: 200,
// //         color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
// //         child: Stack(
// //           children: [
// //             if (_list.isEmpty)
// //               Center(child: Text("Drop here"))
// //             else
// //               Text(_list.map((e) => e.path).join("\n")),
// //             if (offset != null)
// //               Align(
// //                 alignment: Alignment.topRight,
// //                 child: Text(
// //                   '$offset',
// //                   style: Theme.of(context).textTheme.bodySmall,
// //                 ),
// //               ),
// //             if (!_list.isEmpty && !kIsWeb && Platform.isMacOS)
// //               Align(
// //                 alignment: Alignment.bottomRight,
// //                 child: TextButton(
// //                   onPressed: () async {
// //                     Map<String, String> data = Map();
// //                     data["path"] = drop_files[0].path;
// //
// //                     String bookmark =
// //                     base64.encode(drop_files[0].extraAppleBookmark!);
// //                     data["apple-bookmark"] = bookmark;
// //
// //                     String jsonStr = json.encode(data);
// //                     print(jsonStr);
// //                     final SharedPreferences prefs =
// //                     await SharedPreferences.getInstance();
// //                     prefs.setString("apple-bookmark", jsonStr);
// //
// //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //                         content: Text(
// //                             'Save Suc, restart app, and Test Apple Bookmark')));
// //                   },
// //                   child: Text(
// //                     'save bookmark',
// //                     style: TextStyle(fontSize: 14),
// //                   ),
// //                 ),
// //               )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// //todo code--------------/////
// import 'package:desktop_drop/desktop_drop.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:cross_file/cross_file.dart';
// import 'package:get/get.dart';
//
//
//
// class DragAndDropExample extends StatefulWidget {
//   const DragAndDropExample({super.key});
//
//   @override
//   State<DragAndDropExample> createState() => _DragAndDropExampleState();
// }
//
// class _DragAndDropExampleState extends State<DragAndDropExample> {
//   @override
//   Widget build(BuildContext context) {
//     return const Wrap(
//       direction: Axis.horizontal,
//       runSpacing: 8,
//       spacing: 10,
//       children: [
//         ExampleDragTarget(),
//         // ExampleDragTarget(),
//         // ExampleDragTarget(),
//         // ExampleDragTarget(),
//         // ExampleDragTarget(),
//
//       ],
//     );
//   }
// }
//
// class ExampleDragTarget extends StatefulWidget {
//   const ExampleDragTarget({super.key});
//
//   @override
//   _ExampleDragTargetState createState() => _ExampleDragTargetState();
// }
//
// class _ExampleDragTargetState extends State<ExampleDragTarget> {
//
//   bool _dragging = false;
//
//   Offset? offset;
//
//   @override
//   Widget build(BuildContext context) {
//     return DropTarget(
//       onDragDone: (detail) async {
//
//
//         print("detail=-==${detail.files}");
//         setState(() {
//           _list.addAll(detail.files);
//         });
//
//         debugPrint('onDragDone:');
//         for (final file in detail.files) {
//           debugPrint('  ${file.path} ${file.name}'
//               '  ${await file.lastModified()}'
//               '  ${await file.length()}'
//               '  ${file.mimeType}');
//         }
//       },
//       onDragUpdated: (details) {
//         setState(() {
//           offset = details.localPosition;
//         });
//       },
//       onDragEntered: (detail) {
//         setState(() {
//           _dragging = true;
//           offset = detail.localPosition;
//         });
//       },
//       onDragExited: (detail) {
//         setState(() {
//           _dragging = false;
//           offset = null;
//         });
//       },
//       child: Container(
//         height: 200,
//         width: double.infinity,
//         color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
//         child: Stack(
//           children: [
//             if (_list.isEmpty)
//               // const Center(child: Text("Drop here"))
//         Center(
//           child: Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment:
//           CrossAxisAlignment.center,
//           mainAxisAlignment:
//           MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.upload,
//               color: Colors.grey,
//             ),
//             Text(
//               "Drag Files to upload",
//               style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey,
//                   fontSize: 12),
//             ).marginOnly(bottom: 5),
//             RichText(
//               text: TextSpan(
//                 text: 'Or, ',
//                 style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey,
//                     fontSize: 12),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: 'Click here',
//                     recognizer:
//                     TapGestureRecognizer()
//                       ..onTap = () {
//
//                       },
//                     style: TextStyle(
//                         fontWeight:
//                         FontWeight.w600,
//                         color: Colors.brown,
//                         fontSize: 12),
//                   ),
//                   TextSpan(
//                     text: ' to browse',
//                     style: TextStyle(
//                         fontWeight:
//                         FontWeight.w500,
//                         color: Colors.grey,
//                         fontSize: 12),
//                   )
//                 ],
//               ),
//             ),
//           ],
//                 ),
//         )
//             else
//               Center(child: Text(_list.map((e) => e.path).join("\n"))),
//             if (offset != null)
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Text(
//                   '$offset',
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
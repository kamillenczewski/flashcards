// import 'dart:convert';
// import 'dart:io';
// import 'package:csv/csv.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:fproject/controllers/language_controller.dart';
// import 'package:fproject/controllers/settings_controller.dart';
// import 'package:fproject/modals/action_dialog.dart';
// import 'package:fproject/other/action_button.dart';
// import 'package:fproject/services/cards_table_service.dart';
// import 'package:provider/provider.dart';

// class DataImportLoadingWidget extends StatefulWidget {
//   const DataImportLoadingWidget({super.key});

//   @override
//   State<DataImportLoadingWidget> createState() => _DataImportLoadingWidgetState();
// }

// class _DataImportLoadingWidgetState extends State<DataImportLoadingWidget> {
//   final _cardsTableService = getIt<CardsTableService>();
//   final _language = getIt<LanguageController>();

//   void exportCardsToCSV() {

//   }

//   @override
//   Widget build(BuildContext context) {
//     final settings = Provider.of<SettingsController>(context, listen: false);

//     return Dialog(
//       child: SizedBox(
//         width: 300,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16.0),
//             color: settings.outerColor,
//             border: BoxBorder.all(color: settings.innerColor)
//           ),
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: .center,
//             spacing: 5,
//             children: [
//               Text(
//                 'Data import', 
//                 style: TextStyle(
//                   fontFamily: settings.fontFamily, 
//                   fontSize: 20, 
//                   color: settings.innerColor
//                 ),
//               ),

//               _recordIndex == -1
//               ? 
//               SizedBox.shrink()
//               : 
//               (
//                 _isDoneIconVisible
//                 ?
//                 Icon(Icons.done_rounded, color: settings.innerColor)
//                 :
//                 Column(
//                   spacing: 5,
//                   children: [
//                     Text(
//                       '$_recordIndex/$_maxLength',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontFamily: settings.fontFamily,
//                         color: settings.innerColor
//                       ),
//                     ),
//                     LinearProgressIndicator(
//                       value: _progess,
//                       semanticsLabel: 'Linear progress indicator',
//                       borderRadius: BorderRadius.circular(10),
//                       color: settings.innerColor,
//                     ),
//                   ],
//                 )
//               ),

//               Padding(
//                 padding: .only(top: 4),
//                 child: Row(
//                   spacing: 6,
//                   mainAxisAlignment: .center,
//                   children: [
//                     ActionButton(
//                       onTap: () => Navigator.of(context).pop(), 
//                       text: _language['Back'],
//                     ),
//                     ActionButton(
//                       onTap: () => importCardsFromCSV(), 
//                       text: _language['Run'],
//                       reversedColors: true,
//                     )
//                   ],
//                 )
//               )
//             ],
//           ),
//         ),
//       )
//     );
//   }
// }

// void showDataImportLoadingDialog(
//   BuildContext context,
// ) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) => DataImportLoadingWidget()
//   );
// }
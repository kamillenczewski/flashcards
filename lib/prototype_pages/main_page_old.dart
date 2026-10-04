// import 'dart:convert';
// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'package:fproject/models/card_view.dart';
// import 'package:fproject/models/english_card.dart';
// import 'package:fproject/modals/add_group_to_session_modal.dart';
// import 'package:fproject/modals/link_group_to_card_modal.dart';
// import 'package:fproject/services/card_views_table_service.dart';
// import 'package:fproject/services/cards_table_service.dart';
// import 'package:fproject/services/database_service.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:fproject/services/group_links_table_service.dart';
// import 'package:fproject/services/group_table_service.dart';
// import 'package:fproject/services/integers_storage_table_service.dart';
// import 'package:fproject/services/next_card_service.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:fproject/services/notes_table_service.dart';
// import 'package:intl/intl.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   static const routeName = '/MainPage';
  
//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   final _cardsTableService = CardsTableService(dbService: DatabaseService.instance);
//   final _notesTableService = NotesTableService(dbService: DatabaseService.instance);
//   final _cardViewsTableService = CardViewsTableService(dbService: DatabaseService.instance); 
//   final _groupTableService = GroupTableService(dbService: DatabaseService.instance);  
//   final _integersStorageTableService = IntegersStorageTableService(dbService: DatabaseService.instance);  
//   final _groupLinksTableService = GroupLinksTableService(dbService: DatabaseService.instance);  
//   late NextCardService _nextCardService; 

//   // int _noteIndex = -1;

//   bool _isExplanationVisible = false;

//   late Future<(EnglishCard, CardView)?> _currentCardAndView;

//   @override
//   void initState() {
//     super.initState();

//     _nextCardService = NextCardService(
//       dbService: DatabaseService.instance, 
//       integersStorageTableService: _integersStorageTableService,
//       cardViewsTableService: _cardViewsTableService,
//       cardsTableService: _cardsTableService,
//       groupTableService: _groupTableService,
//     );  

//     _currentCardAndView = fetchCurrentCardAndView();
//   }

//   Future<(EnglishCard, CardView)?> fetchCurrentCardAndView() async {
//     return _nextCardService.getCurrent();
//   }

//   void refreshCurrentCardAndView() {
//     print('REFRESHED');
//     setState(() {
//       _currentCardAndView = fetchCurrentCardAndView();
//     });
//   }

//   Widget getAnimatedRectangle(String text, int noteId, int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _noteIndex = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 0),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.blue[100],
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: _noteIndex == index ? Colors.black45 : Colors.transparent,
//             width: 4,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Text(
//               //   text,
//               //   overflow: TextOverflow.clip,
//               //   style: TextStyle(
//               //     fontSize: 18, 
//               //     fontFamily: 'Lexend',
//               //     fontWeight: _noteIndex == index ? FontWeight.bold : FontWeight.normal,
//               //   ),
//               // ),
             
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _notesTableService.deleteNote(noteId);
//                   });
//                 }, 
//                 icon: Icon(Icons.delete)
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }



//   Widget getNotesList(int cardId) {
//     return FutureBuilder(
//       future: _notesTableService.getNotes(cardId), 
//       builder: (context, snapshot) {
//         final notes = snapshot.data ?? [];
//         final noteControllers = notes.map((e) => TextEditingController(text: e.content)).toList();
    
//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: snapshot.data?.length ?? 0,
//           itemBuilder: (context, index) {
//             final note = notes[index];
            
//             return Column(
//               children: [
//                 Container(
//                   padding: .all(8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(17)),
//                     border: BoxBorder.all(width: 3, color: Colors.grey),
//                   ),
//                   child: Row(
//                     children: [
//                       Flexible(
//                         child: TextField(
//                           keyboardType: TextInputType.multiline,
//                           maxLines: null,
//                           controller: noteControllers[index],
//                           onEditingComplete: () {
//                             setState(() {
//                               _notesTableService.updateNote(note.id, cardId, noteControllers[index].text);
//                             });
//                           },
//                           onTapOutside: (e) {
//                             setState(() {
//                               _notesTableService.updateNote(note.id, cardId, noteControllers[index].text);
//                             });
//                           },
//                           decoration: InputDecoration(
//                             labelStyle: TextStyle(
//                               color: Colors.grey, 
//                               fontFamily: 'Lexend', 
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.transparent),
//                             ),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.transparent),
//                             ),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             _notesTableService.deleteNote(note.id);
//                           });
//                         }, 
//                         icon: Icon(Icons.delete)
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 8)
//               ],
//             );
//           }
//         );
//       }
//     );
//   }

//   Future<String> readFile(String path) async {
//     final file = File(path);
//     final contents = await file.readAsString();
//     return contents;
//   }

//   void importCsvToDb() async {
//     FilePickerResult? result = await FilePicker.pickFiles();

//     final path = result!.files.first.path;
//     final file = File(path!);
    
//     await file
//       .openRead()
//       .transform(utf8.decoder)
//       .transform(csv.decoder)
//       .map((e) => e.map((x) => x.toString()))
//       .forEach((row) => _cardsTableService.addCard(row.elementAt(0), row.elementAt(1)));
//   }

//   Widget createCardViewMetadata(CardView view, Color textColor) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Row(
//         mainAxisSize: .max,
//         mainAxisAlignment: .center,
//         children: [
//           Column(   
//             children: [
//               Text(
//                 DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(view.datetime)), 
//                 style: TextStyle(fontFamily: 'Lexend', color: textColor)
//               ),
//               Text(
//                 DateFormat('HH-mm-ss').format(DateTime.fromMillisecondsSinceEpoch(view.datetime)), 
//                 style: TextStyle(fontFamily: 'Lexend', color: textColor)
//               ),
//               Text('${view.id}', style: TextStyle(fontFamily: 'Lexend', color: textColor)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//         // Padding(
//           //   padding: EdgeInsets.only(bottom: 8, top: 8),
//           //   child: Container(
//           //     decoration: BoxDecoration(
//           //       borderRadius: BorderRadius.all(Radius.circular(17)),
//           //       border: BoxBorder.all(width: 3, color: Colors.grey),
//           //     ),
//           //     padding: const EdgeInsets.all(6),
//           //     child: FutureBuilder(
//           //       future: _groupTableService.getSessionGroups(),
//           //       builder: (context, snapshot) {
//           //         var groups = snapshot.data ?? [];

//           //         return Wrap(
//           //           runSpacing: 6,
//           //           spacing: 10,
//           //           children: List<Widget>.generate(groups.length, (int index) { 
//           //             return ChoiceChip(
//           //               key: ValueKey(groups[index].id), /// KEY ADDED !!!
//           //               checkmarkColor: const Color.fromARGB(255, 248, 247, 247),
//           //               selectedColor: const Color.fromARGB(255, 209, 159, 9),
//           //               side: BorderSide(color: Colors.white),
//           //               backgroundColor: const Color.fromARGB(255, 146, 139, 139),
//           //               label: Text(
//           //                 groups[index].name, 
//           //                 style: TextStyle(color: Colors.white),
//           //               ),
//           //               selected: false,
//           //               onSelected: (bool selected) {
                          
//           //               },
//           //             );
//           //           }).toList() + [
//           //             RawChip(
//           //               key: ValueKey('+ Chip'),
//           //               side: BorderSide(color: const Color.fromARGB(255, 146, 139, 139)),
//           //               label: Icon(Icons.add, size: 20),
//           //               labelPadding: EdgeInsetsGeometry.all(0),
//           //               onPressed: () {
//           //                 showAddGroupToSessionModal(context, _groupTableService, setState);
//           //               },
//           //             ),
//           //           ],
//           //         );
//           //       }
//           //     ),
//           //   ),
//           // ),

//   @override
//   Widget build(BuildContext context) {
//     return createMainWidget(context);
//   }

//   Widget createMainWidget(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(30),
//       child: FutureBuilder(
//         future: _currentCardAndView,
//         builder: (context, snapshot) {
//           var (card, view) = 
//             snapshot.data ?? 
//             (EnglishCard.defaultInstance, CardView.defaultInstance);
      
//           return ScrollConfiguration(
//             behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(17)),
//                       border: BoxBorder.all(width: 3, color: Colors.grey),
//                     ),
//                     child: Column(
//                       children: [
//                         Stack(
//                           children: [
//                             createCardViewMetadata(view, Colors.grey),
//                             Positioned(
//                               top: 5,
//                               right: 5,
//                               child: PopupMenuButton(
//                                 icon: Icon(Icons.more_horiz),
//                                 itemBuilder: (context) => [
//                                   PopupMenuItem(
//                                     padding: .all(8),
//                                     child: Row(
//                                       spacing: 5,
//                                       children: [
//                                         Text('Add card to group', style: TextStyle(fontFamily: 'Lexend'))
//                                       ]
//                                     ),
//                                     onTap: () => showLinkGroupToCardModal(context, _groupLinksTableService, setState, card.id)
//                                   ),
//                                   PopupMenuItem(
//                                     padding: .all(8),
//                                     child: Row(
//                                       spacing: 5,
//                                       children: [
//                                         Text('New note', style: TextStyle(fontFamily: 'Lexend'))
//                                       ]
//                                     ),
//                                     onTap: () {
//                                       setState(() {
//                                         _notesTableService.addNote(card.id, '');
//                                       });
//                                     }
//                                   ),
//                                   PopupMenuItem(
//                                     padding: .all(8),
//                                     child: Row( // po co TEN ROW
//                                       spacing: 5,
//                                       children: [
//                                         Text('Session groups', style: TextStyle(fontFamily: 'Lexend')),
//                                       ]
//                                     ),
//                                     onTap: () => showAddGroupToSessionModal(context, _groupTableService, setState)
//                                   ),
//                                 ]
//                               ),
//                             )
//                           ],
//                         ),
//                         Row(
//                           mainAxisSize: .max,
//                           children: [
//                             Column(
//                               mainAxisAlignment: .center,
//                               mainAxisSize: .max,
//                               children: [
//                                 IconButton(
//                                   onPressed: () {
//                                     _nextCardService.goBack();
//                                     refreshCurrentCardAndView();
//                                   }, 
//                                   icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey),
//                                 ),
//                                 IconButton(
//                                   onPressed: () async {
//                                     _nextCardService.goMin();
//                                     refreshCurrentCardAndView();
//                                   }, 
//                                   icon: Icon(Icons.keyboard_double_arrow_left, color: Colors.grey, size: 30,),
//                               )
//                               ],
//                             ),
//                             Expanded(
//                               child: GestureDetector(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 130, top: 130),
//                                   child: Center(
//                                     child: Text(
//                                       _isExplanationVisible ? card.explanation : card.word,
//                                       style: TextStyle(
//                                         fontFamily: 'Lexend',
//                                         fontSize: 23,
//                                         color: const Color.fromARGB(255, 115, 115, 115)
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                                 onTap: () async {
//                                   setState(() {
//                                     _isExplanationVisible = !_isExplanationVisible;
//                                   });
//                                 },
//                               ),
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               mainAxisSize: .max,
//                               children: [
//                                 IconButton(
//                                   onPressed: () async {
//                                     print('NEXT');
//                                     _nextCardService.goNext();
//                                     refreshCurrentCardAndView();   
//                                   }, 
//                                   icon: Icon(Icons.arrow_forward_ios, color: Colors.grey,),
//                                 ),
//                                 IconButton(
//                                   onPressed: () async {
//                                     _nextCardService.goMax();
//                                     refreshCurrentCardAndView();
//                                   }, 
//                                   icon: Icon(Icons.keyboard_double_arrow_right, color: Colors.grey, size: 30,),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                         createCardViewMetadata(view, Colors.transparent)
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   getNotesList(card.id),
//                 ],
//               ),
//             ),
//           );
//         }
//       ),
//     );
//   }
// }


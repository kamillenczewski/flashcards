import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/models/english_card.dart';
import 'package:fproject/other/utils.dart';
import 'package:fproject/services/table/notes_table_service.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class CurrentSessionPage extends StatefulWidget {
  const CurrentSessionPage({super.key});

  @override
  State<CurrentSessionPage> createState() => _CurrentSessionPageState();
}

class _CurrentSessionPageState extends State<CurrentSessionPage> {
  final _notesTableService = getIt<NotesTableService>();

  bool _isExplanationVisible = false;

  Widget getNotesList(int cardId) {
    final settings = context.watch<SettingsController>();

    return FutureBuilder(
      future: _notesTableService.getNotes(cardId),
      builder: (context, snapshot) {
        final notes = snapshot.data ?? [];
        final noteControllers = notes
            .map((e) => TextEditingController(text: e.content))
            .toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final note = notes[index];

            return Column(
              children: [
                Container(
                  padding: .only(bottom: 4, top: 4, left: 8, right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(17)),
                    border: BoxBorder.all(width: 3, color: settings.innerColor),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: noteControllers[index],
                          onEditingComplete: () {
                            setState(() {
                              _notesTableService.updateNote(
                                note.id,
                                cardId,
                                noteControllers[index].text,
                              );
                            });
                          },
                          onTapOutside: (e) {
                            setState(() {
                              _notesTableService.updateNote(
                                note.id,
                                cardId,
                                noteControllers[index].text,
                              );
                            });
                          },
                          style: TextStyle(color: settings.innerColor),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontFamily: settings.fontFamily,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _notesTableService.deleteNote(note.id);
                          });
                        },
                        icon: Icon(Icons.delete, color: settings.innerColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }

  String createCardText(EnglishCard card) {
    return _isExplanationVisible
        ? getTitle(card.explanation)
        : getTitle(card.word);
  }

  // Widget createPopupMenuButton(EnglishCard card) {
  //   return CustomMenuButton(
  //     // iconSize: 33,
  //     itemsData: [
  //       (
  //         label: 'Add card to group',
  //         icon: Icons.add,
  //         callback: () => showLinkGroupToCardModal(context, setState, card.id)
  //       ),
  //       (
  //         label: 'New note',
  //         icon: Icons.sticky_note_2_rounded,
  //         callback: () =>
  //           setState(() {
  //             _notesTableService.addNote(card.id, '');
  //           })
  //       ),
  //     ],
  //   );
  // }

  Widget createOperationButton({
    required String title,
    required void Function() onTap,
  }) {
    final settings = context.watch<SettingsController>();

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(17)),
            border: BoxBorder.all(width: 3, color: settings.innerColor),
            color: settings.middleColor,
          ),
          padding: .all(8),
          child: Text(
            title,
            textAlign: .center,
            style: TextStyle(
              fontFamily: settings.fontFamily,
              color: settings.innerColor,
              fontWeight: .bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Container(
      color: settings.outerColor,
      padding: const .all(30),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                  border: BoxBorder.all(width: 3, color: settings.innerColor),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite, color: settings.innerColor),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 130, top: 130),
                          child: Center(
                            child: Text(
                              'XD',
                              // createCardText(card),
                              style: TextStyle(
                                fontFamily: settings.fontFamily,
                                fontSize: 25,
                                color: settings.innerColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            _isExplanationVisible = !_isExplanationVisible;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: .center,
                spacing: 12,
                children: [
                  createOperationButton(title: 'Previous', onTap: () {}),
                  createOperationButton(title: 'Next', onTap: () {}),
                ],
              ),
              // getNotesList(_currentCardAndView.card.id),
            ],
          ),
        ),
      ),
    );
  }
}

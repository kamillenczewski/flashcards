import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/sessions_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/modals/choose_group_to_session_dialog.dart';
import 'package:fproject/modals/information_dialog.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/other/action_button.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class CreateSessionDialogFrame extends StatefulWidget {
  const CreateSessionDialogFrame({super.key});

  @override
  State<CreateSessionDialogFrame> createState() => _CreateSessionDialogFrameState();
}

class _CreateSessionDialogFrameState extends State<CreateSessionDialogFrame> {
  final _language = getIt<LanguageController>();
  final _sessionsController = getIt<SessionsController>();
  final nameController = TextEditingController();
  List<Group> groups = [];
  
  Widget createGroupChips() {
    final settings = Provider.of<SettingsController>(context, listen: false);

    return Container(
      width: 270,
      padding: .all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: BoxBorder.all(width: 1, color: settings.innerColor),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: .center,
        children: groups.map<Widget>(
          (group) {    
            return Container(
              padding: .all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: BoxBorder.all(width: 1, color: settings.outerColor),
                color: settings.innerColor
              ),
              child: Text(
                group.name, 
                style: TextStyle(
                  color: settings.outerColor,
                  fontFamily: settings.fontFamily,
                  fontSize: 15
                )
              ),
            );
        }).toList() + <Widget>[
          Container(
            padding: .all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: BoxBorder.all(width: 1, color: settings.innerColor),
            ),
            child: GestureDetector(
              child: Icon(
                Icons.add,
                color: settings.innerColor,
                size: 20,
              ),
              onTap: () {
                showChooseGroupToSessionDialog(
                  context, groups,
                  (data) {
                    setState(() {
                      groups = data;
                    });
                  } 
                );
              },
            )
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {  
    final settings = Provider.of<SettingsController>(context, listen: false);

    return SizedBox(
      width: 300,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: settings.outerColor,
          border: BoxBorder.all(color: settings.innerColor)
        ),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Flexible(
              child: Text(
                _language['Create new session'], 
                style: TextStyle(
                  fontFamily: settings.fontFamily, 
                  fontSize: 25, 
                  color: settings.innerColor
                ),
              ),
            ),
            Container(
              padding: .only(right: 8, left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: BoxBorder.all(width: 1, color: settings.innerColor),
              ),
              child: TextField(
                cursorColor: settings.innerColor,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: nameController,
                style: TextStyle(
                  color: settings.innerColor, 
                ),
                decoration: InputDecoration(
                  hintText: _language['Name'],
                  hintStyle: TextStyle(
                    fontFamily: settings.fontFamily, 
                    color: settings.middleColor,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  floatingLabelBehavior: .never,
                  floatingLabelStyle: TextStyle(fontSize: 0)
                ),
              ),
            ),
            createGroupChips(),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                ActionButton(
                  onTap: () => Navigator.of(context).pop(), 
                  text: _language["Cancel"]
                ),
                ActionButton(
                  onTap: () {
                    if (nameController.text.isEmpty) {
                      showInformationDialog(context, _language["Session's name cannot be empty!"]);
                    }
                    else if (groups.isEmpty) {
                      showInformationDialog(context, _language['Session should contain at least one group!']);
                    } else {
                      _sessionsController.add(nameController.text, groups.map((e) => e.id).toList());
                      Navigator.of(context).pop();
                    }
                  },
                  text: _language["Submit"],
                  reversedColors: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void showCreateSessionDialog(BuildContext context) {  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: CreateSessionDialogFrame()
      );
    },
  );
}
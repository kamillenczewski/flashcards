import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/cards_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/modals/action_dialog.dart';
import 'package:fproject/other/action_button.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class DataImportLoadingWidget extends StatefulWidget {
  const DataImportLoadingWidget({super.key});

  @override
  State<DataImportLoadingWidget> createState() => _DataImportLoadingWidgetState();
}

class _DataImportLoadingWidgetState extends State<DataImportLoadingWidget> {
  final _cardsController = getIt<CardsController>();
  final _language = getIt<LanguageController>();

  int _recordIndex = -1;
  int _maxLength = -1;
  double _progess = 0.0;
  bool _isDoneIconVisible = false;

  void importCardsFromCSV() async {
    FilePickerResult? result = await FilePicker.pickFiles();
    
    final path = result!.files.first.path;
    final file = File(path!);
    
    final table = await file
      .openRead()
      .transform(utf8.decoder)
      .transform(csv.decoder)
      .map(
        (e) => e
          .map((x) => x.toString())
          .toList()
      )
      .toList();

    setState(() {
      _maxLength = table.length - 1;
    });

    for (var i = 1; i < table.length; i++) {
      setState(() {
        _recordIndex = i + 1;
        _progess = _recordIndex / _maxLength;
      });

      if (_cardsController.existsWithWord(table[i][0])) {
        final doContinue = await showActionDialog(
          context, 
          "Word: '${table[i][0]}' is duplicated!\nWhat you want to do?", 
          [
            ActionButton(
              onTap: () => Navigator.of(context).pop(false), 
              text: _language['Back']
            ),
            ActionButton(
              onTap: () => Navigator.of(context).pop(true), 
              text: _language['Continue'],
              reversedColors: true,
            )
          ]
        );

        if (!doContinue) break;
      } 
      else {
        await _cardsController.add(table[i][0], table[i][1]);
      }
    }

    setState(() {
      _isDoneIconVisible = !_isDoneIconVisible;
    });

    await Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _recordIndex = -1;
        _progess = 0;
        _isDoneIconVisible = !_isDoneIconVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context, listen: false);

    return Dialog(
      child: SizedBox(
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
            mainAxisAlignment: .center,
            spacing: 5,
            children: [
              Text(
                'Data import', 
                style: TextStyle(
                  fontFamily: settings.fontFamily, 
                  fontSize: 20, 
                  color: settings.innerColor
                ),
              ),

              _recordIndex == -1
              ? 
              SizedBox.shrink()
              : 
              (
                _isDoneIconVisible
                ?
                Icon(Icons.done_rounded, color: settings.innerColor)
                :
                Column(
                  spacing: 5,
                  children: [
                    Text(
                      '$_recordIndex/$_maxLength',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: settings.fontFamily,
                        color: settings.innerColor
                      ),
                    ),
                    LinearProgressIndicator(
                      value: _progess,
                      semanticsLabel: 'Linear progress indicator',
                      borderRadius: BorderRadius.circular(10),
                      color: settings.innerColor,
                    ),
                  ],
                )
              ),

              Padding(
                padding: .only(top: 4),
                child: Row(
                  spacing: 6,
                  mainAxisAlignment: .center,
                  children: [
                    ActionButton(
                      onTap: () => Navigator.of(context).pop(), 
                      text: _language['Back'],
                    ),
                    ActionButton(
                      onTap: () => importCardsFromCSV(), 
                      text: _language['Run'],
                      reversedColors: true,
                    )
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }
}

void showDataImportLoadingDialog(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) => DataImportLoadingWidget()
  );
}
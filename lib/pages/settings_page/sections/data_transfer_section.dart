import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/cards_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/modals/data_import_loading_dialog.dart';
import 'package:fproject/models/english_card.dart';
import 'package:fproject/pages/settings_page/button_container.dart';
import 'package:fproject/pages/settings_page/section.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class DataTransferSection extends StatefulWidget {
  const DataTransferSection({super.key});

  @override
  State<DataTransferSection> createState() => _DataTransferSectionState();
}

class _DataTransferSectionState extends State<DataTransferSection> {
  final language = getIt<LanguageController>();
  final _cardsController = getIt<CardsController>();

  void exportCardsToCSV() async {
    String? path = await FilePicker.saveFile();
    
    if (path == null) return;

    final dotIndex = path.indexOf('.');

    if (dotIndex == -1) {
      path += '.csv';
    }
    else {
      path = '${path.substring(0, dotIndex)}.csv';
    }
    
    final cards = _cardsController.getAll();
    final header = '${EnglishCard.kWord},${EnglishCard.kExplanation}';
    final records = cards.map((e) => '"${e.word}","${e.explanation}"').join('\n');
    final content = '$header\n$records';

    final file = File(path);

    await file.writeAsString(content);
  }

  @override
  Widget build(BuildContext context) {
    final language = getIt<LanguageController>();

    return createSection(
      context, 
      language['Data Transfer'], 
      [
        (
          language['Import Data'], 
          [GestureDetector(
            child: createButtonContainer(context, language['Run']),
            onTap: () {
              showDataImportLoadingDialog(context);
            },
          )]
        ),
        (
          language['Export Data'], 
          [GestureDetector(
            child: createButtonContainer(context, language['Run']),
            onTap: () {
              exportCardsToCSV();
            },
          )]
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fproject/controllers/search/abstract_search_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class CustomSearchBar extends StatefulWidget {
  final AbstractSearchController _searchController;

  const CustomSearchBar({
    super.key, 
    required this._searchController
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final _textController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Padding(
      padding: const .only(bottom: 4, top: 4, right: 8, left: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: settings.innerColor), 
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const .symmetric(horizontal: 8, vertical: 4),
        child: Row(
          spacing: 8,
          children: [
            Icon(Icons.search, color: settings.innerColor),
            Flexible(

              child: TextField(
                controller: _textController,
                onChanged: (value) => widget._searchController.updateQuery(value),
                cursorColor: settings.innerColor,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  color: settings.innerColor
                ),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    fontFamily: settings.fontFamily,
                    color: settings.middleColor
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: settings.innerColor)
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
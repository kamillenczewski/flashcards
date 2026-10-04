import 'dart:math';

import 'package:flutter/material.dart';

class WrapPageTileSurroundingTest extends StatefulWidget {
  const WrapPageTileSurroundingTest({super.key});

  @override
  State<WrapPageTileSurroundingTest> createState() => _WrapPageTileSurroundingTestState();
}

class _WrapPageTileSurroundingTestState extends State<WrapPageTileSurroundingTest> {
  final int _quantity = 30;
  List<Map<String, dynamic>>? _data;
  
  int _tileIndex = -1;


  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    setState(() {
      _data = generateData(_quantity);
    });
  }

  List<Map<String, dynamic>> generateData(int quantity) {
    return List.generate(
      quantity, 
      (index) {
        return {
          'day': (Random().nextInt(29) + 1).toString().padLeft(2, '0'),
          'month': (Random().nextInt(11) + 1).toString().padLeft(2, '0'),
          'year': DateTime.now().year,
          'max': 100,
          'done': Random().nextInt(99) + 1,
          'isCompleted': Random().nextBool(),
        };
      }
    );
  }

  Widget getAnimatedRectangle(int index, Widget child) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_tileIndex == index) {
            _tileIndex = -1;
          } else {
            _tileIndex = index;
          }
        });
      },
      onDoubleTap: () {
        setState(() {
          _tileIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _tileIndex == index ? Colors.amber : Colors.transparent,
            width: 4,
          ),
        ),
        child: child,
      ),
    );
  }

  Widget createTile(Map<String, dynamic> row) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadiusGeometry.all(Radius.circular(8))
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  Text(
                    '${row['day']}-${row['month']}-${row['year']}',
                    //'20-07-26', 
                    style: TextStyle(
                      fontSize: 26, 
                    ),
                  ),
                  Text(
                    '${row['done']}/${row['max']}',
                    // '44/50',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              row['isCompleted'] ? Icons.done : Icons.close,
              color: row['isCompleted'] ? Colors.green : Colors.red,
              size: 27,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            children: List.generate(
              _quantity, 
              (index) {
                return getAnimatedRectangle(index, createTile(_data![index]));
              }
            ),
          ),
        ),
      )
    );
  }
}
          
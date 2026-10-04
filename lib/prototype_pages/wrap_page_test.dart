import 'dart:math';

import 'package:flutter/material.dart';

class WrapPageTest extends StatefulWidget {
  const WrapPageTest({super.key});

  @override
  State<WrapPageTest> createState() => _WrapPageTestState();
}

class _WrapPageTestState extends State<WrapPageTest> {
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

  Widget createTile(Map<String, dynamic> row) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.amber,
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
    final quantity = 30;
    final data = generateData(quantity);

    return Center(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            children: List.generate(
              quantity, 
              (index) {
                return createTile(data[index]);
              }
            ),
          ),
        ),
      )
    );
  }
}
          
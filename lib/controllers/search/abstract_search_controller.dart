import 'package:flutter/material.dart';

abstract class AbstractSearchController<T> extends ChangeNotifier {
  void updateQuery(String query);

  int get length;

  T get(int index);
}
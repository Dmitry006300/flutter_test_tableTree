import 'package:flutter/material.dart';

class TableElement {
  String text;
  bool isExpanded = false;
  bool isChecked = false;
  List<TableElement> children;
  final TextEditingController textEditingController;

  TableElement({
    required this.text,
    List<TableElement> children = const [],
  })  : children = List.from(children),
        textEditingController = TextEditingController(text: text);
}

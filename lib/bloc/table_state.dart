import 'package:flutter_test_table/models/table_cell.dart';

class TableState {
  final List<TableElement> rootElements;
  TableState({required this.rootElements});

  TableState copyWith({List<TableElement>? rootElements}) {
    return TableState(
      rootElements: rootElements ?? this.rootElements,
    );
  }
}

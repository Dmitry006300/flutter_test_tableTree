import 'package:flutter_test_table/models/table_cell.dart';

abstract class TableEvent {}

class AddRootElement extends TableEvent {}

class UpdateElement extends TableEvent {
  final TableElement node;
  UpdateElement(this.node);
}

class ElementExpansion extends TableEvent {
  final TableElement node;
  ElementExpansion(this.node);
}

class DeleteElement extends TableEvent {
  final TableElement node;
  DeleteElement(this.node);
}

class AddChildElement extends TableEvent {
  final TableElement parentNode;
  AddChildElement(this.parentNode);
}

class UpdateParentCheckboxes extends TableEvent {
  final TableElement node;
  UpdateParentCheckboxes(this.node);
}

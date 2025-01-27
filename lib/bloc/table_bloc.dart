import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_table/bloc/table_event.dart';
import 'package:flutter_test_table/bloc/table_state.dart';
import 'package:flutter_test_table/models/table_cell.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableState(rootElements: [])) {
    on<AddRootElement>((event, emit) {
      final newRootElements = List<TableElement>.from(state.rootElements)
        ..add(TableElement(text: "Новый корневой элемент"));
      emit(state.copyWith(rootElements: newRootElements));
    });

    on<UpdateElement>((event, emit) {
      event.node.textEditingController.text = event.node.text;
      emit(state.copyWith(rootElements: List.from(state.rootElements)));
    });

    on<ElementExpansion>((event, emit) {
      event.node.isExpanded = !event.node.isExpanded;
      emit(state.copyWith());
    });

    on<DeleteElement>((event, emit) {
      void deleteNode(List<TableElement> nodes, TableElement target) {
        nodes.removeWhere((node) => node == target);
        for (var node in nodes) {
          deleteNode(node.children, target);
        }
      }

      final updatedRootElements = List<TableElement>.from(state.rootElements);
      deleteNode(updatedRootElements, event.node);
      emit(state.copyWith(rootElements: updatedRootElements));
    });

    on<AddChildElement>((event, emit) {
      event.parentNode.children
          .add(TableElement(text: "Новый вложенный элемент"));
      emit(state.copyWith());
    });

    void updateParentCheckboxes(TableElement currentNode) {
      void updateParent(TableElement node, List<TableElement> elements) {
        for (TableElement parent in elements) {
          if (parent.children.contains(node)) {
            parent.isChecked = parent.children.any((child) => child.isChecked);
            updateParent(parent, state.rootElements);
            break;
          }
          updateParent(node, parent.children);
        }
      }

      updateParent(currentNode, state.rootElements);
    }

    on<UpdateParentCheckboxes>((event, emit) {
      updateParentCheckboxes(event.node);
      emit(state.copyWith(rootElements: List.from(state.rootElements)));
    });
  }
}

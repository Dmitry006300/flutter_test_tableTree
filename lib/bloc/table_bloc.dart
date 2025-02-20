import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_table/bloc/table_event.dart';
import 'package:flutter_test_table/bloc/table_state.dart';
import 'package:flutter_test_table/models/table_cell.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableState(rootElements: [])) {
    on<TableEvent>((event, emit) async {
      if (event is AddRootElement) {
        on<AddRootElement>((event, emit) {
          final newRootElements = List<TableElement>.from(state.rootElements)
            ..add(TableElement(text: "Новый корневой элемент"));
          emit(state.copyWith(rootElements: newRootElements));
        });
      } else if (event is UpdateElement) {
        event.node.textEditingController.text = event.node.text;
        emit(state.copyWith());
      } else if (event is ElementExpansion) {
        event.node.isExpanded = !event.node.isExpanded;
        emit(state.copyWith());
      } else if (event is DeleteElement) {
        void deleteNode(List<TableElement> nodes, TableElement target) {
          nodes.removeWhere((node) => node == target);
          for (var node in nodes) {
            deleteNode(node.children, target);
          }
        }

        final updatedRootElements = List<TableElement>.from(state.rootElements);
        deleteNode(updatedRootElements, event.node);
        emit(state.copyWith(rootElements: updatedRootElements));
      } else if (event is AddChildElement) {
        event.parentNode.children
            .add(TableElement(text: "Новый вложенный элемент"));
        emit(state.copyWith());
      } else if (event is UpdateParentCheckboxes) {
        void updateParentCheckboxes(TableElement currentNode) {
          void updateParent(TableElement node, List<TableElement> elements) {
            for (TableElement parent in elements) {
              if (parent.children.contains(node)) {
                parent.isChecked =
                    parent.children.any((child) => child.isChecked);
                updateParent(parent, state.rootElements);
                break;
              }
              updateParent(node, parent.children);
            }
          }

          updateParent(currentNode, state.rootElements);
        }

        updateParentCheckboxes(event.node);
        emit(state.copyWith(rootElements: List.from(state.rootElements)));
      }
    }, transformer: sequential());
  }
}

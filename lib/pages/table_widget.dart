import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_table/bloc/table_bloc.dart';
import 'package:flutter_test_table/bloc/table_event.dart';
import 'package:flutter_test_table/bloc/table_state.dart';
import 'package:flutter_test_table/models/table_cell.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Дерево элементов"),
        backgroundColor: Colors.blue[200],
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.blue,
        backgroundColor: Colors.blue[200],
        onPressed: () {
          context.read<TableBloc>().add(AddRootElement());
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TableBloc, TableState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: state.rootElements
                  .asMap()
                  .entries
                  .map((entry) => TreeNodeWidget(
                        node: entry.value,
                        index: (entry.key + 1).toString(),
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

class TreeNodeWidget extends StatelessWidget {
  final TableElement node;
  final String index;

  const TreeNodeWidget({
    super.key,
    required this.node,
    required this.index,
  });

  String _generateIndex(String parentIndex, int childIndex) {
    return "$parentIndex.$childIndex";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 16),
          child: Table(
            border: TableBorder.symmetric(
              outside: BorderSide(color: Colors.grey.shade300),
              inside: BorderSide(color: Colors.grey.shade300),
            ),
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: FlexColumnWidth(3.0),
              3: IntrinsicColumnWidth(),
              4: IntrinsicColumnWidth(),
              5: IntrinsicColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  PlusIconButton(node: node),
                  IndexWidget(index: index),
                  TextWidget(node: node),
                  CheckBoxWidget(node: node),
                  AddButtonWidget(node: node),
                  DeleteButtonWidget(node: node),
                ],
              ),
            ],
          ),
        ),
        if (node.isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: node.children.asMap().entries.map((entry) {
              final childIndex = entry.key + 1;
              final childNode = entry.value;
              return TreeNodeWidget(
                node: childNode,
                index: _generateIndex(index, childIndex),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class DeleteButtonWidget extends StatelessWidget {
  const DeleteButtonWidget({
    super.key,
    required this.node,
  });

  final TableElement node;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: IconButton(
        icon: const Icon(Icons.minimize_rounded),
        onPressed: () {
          context.read<TableBloc>().add(DeleteElement(node));
        },
      ),
    );
  }
}

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({
    super.key,
    required this.node,
  });

  final TableElement node;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          context.read<TableBloc>().add(AddChildElement(node));
        },
      ),
    );
  }
}

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    super.key,
    required this.node,
  });

  final TableElement node;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Checkbox(
        value: node.isChecked,
        onChanged: (value) {
          node.isChecked = value ?? false;
          context.read<TableBloc>().add(UpdateElement(node));

          context.read<TableBloc>().add(UpdateParentCheckboxes(node));
        },
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.node,
  });

  final TableElement node;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        controller: node.textEditingController,
        onChanged: (value) {
          node.text = value;
          context.read<TableBloc>().add(UpdateElement(node));
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        maxLines: null,
      ),
    );
  }
}

class IndexWidget extends StatelessWidget {
  const IndexWidget({
    super.key,
    required this.index,
  });

  final String index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, left: 8, right: 8),
      child: Text(index),
    );
  }
}

class PlusIconButton extends StatelessWidget {
  const PlusIconButton({
    super.key,
    required this.node,
  });

  final TableElement node;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(
          node.children.isNotEmpty
              ? (node.isExpanded ? Icons.remove : Icons.add)
              : Icons.remove,
          color: node.children.isNotEmpty ? Colors.black : Colors.grey,
        ),
        onPressed: node.children.isNotEmpty
            ? () {
                context.read<TableBloc>().add(ElementExpansion(node));
              }
            : null,
      ),
    );
  }
}

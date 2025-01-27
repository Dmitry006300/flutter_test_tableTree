
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_table/bloc/table_bloc.dart';
import 'package:flutter_test_table/pages/table_widget.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TableBloc>(
          create: (_) => TableBloc()
          ),
      ],
      child: const MaterialApp(
        home: TablePage(),
      ),
    ),
  );
}
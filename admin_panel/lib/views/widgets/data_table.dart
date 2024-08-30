import 'package:flutter/material.dart';

class CustomDataTable<T> extends StatelessWidget {
  final Stream<List<T>> dataStream;
  final List<String> columns;
  final List<DataRow> Function(List<T>) buildRows;

  const CustomDataTable({
    super.key,
    required this.dataStream,
    required this.columns,
    required this.buildRows,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: dataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        final data = snapshot.data!;
        return DataTable(
          columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
          rows: buildRows(data),
        );
      },
    );
  }
}

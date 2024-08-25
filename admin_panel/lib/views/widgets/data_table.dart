import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataTable(
          headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.grey.shade200),
          columns: const [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Article Title")),
            DataColumn(label: Text("Creation Date")),
            DataColumn(label: Text("Views")),
            DataColumn(label: Text("Comments")),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text("0")),
              const DataCell(Text("How to build a Flutter Web App")),
              DataCell(Text("${DateTime.now()}")),
              const DataCell(Text("2.3K Views")),
              const DataCell(Text("102 Comments")),
            ]),
            DataRow(cells: [
              const DataCell(Text("1")),
              const DataCell(Text("How to build a Flutter Mobile App")),
              DataCell(Text("${DateTime.now()}")),
              const DataCell(Text("21.3K Views")),
              const DataCell(Text("1020 Comments")),
            ]),
            DataRow(cells: [
              const DataCell(Text("2")),
              const DataCell(Text("Flutter for your first project")),
              DataCell(Text("${DateTime.now()}")),
              const DataCell(Text("2.3M Views")),
              const DataCell(Text("10K Comments")),
            ]),
          ],
        ),
        const SizedBox(height: 40.0),
        Row(
          children: [
            TextButton(
              onPressed: () {},
              child: const Text(
                "1",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "2",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "3",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "See All",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

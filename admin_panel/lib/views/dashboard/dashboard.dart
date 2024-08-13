import 'package:admin_panel/views/widgets/header.dart';
import 'package:admin_panel/views/widgets/side_menu.dart';
import 'package:flutter/material.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(
            isExpanded: isExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                isExpanded = expanded;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      onMenuPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCard(
                          icon: Icons.article,
                          color: Colors.blue,
                          title: "Articles",
                          value: "6 Articles",
                        ),
                        _buildCard(
                          icon: Icons.comment,
                          color: Colors.red,
                          title: "Comments",
                          value: "+32 Comments",
                        ),
                        _buildCard(
                          icon: Icons.people,
                          color: Colors.amber,
                          title: "Subscribers",
                          value: "3.2M Subscribers",
                        ),
                        _buildCard(
                          icon: Icons.monetization_on_outlined,
                          color: Colors.green,
                          title: "Revenue",
                          value: "2,300 \$",
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    _buildArticleSection(),
                    const SizedBox(height: 40.0),
                    _buildFilterSection(),
                    const SizedBox(height: 40.0),
                    _buildDataTable(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new article or item
        },
        backgroundColor: Colors.deepPurple.shade400,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Flexible(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 26.0, color: color),
                  const SizedBox(width: 15.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleSection() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "6 Articles",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "3 new Articles",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 300.0,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Type Article Title",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black26,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple.shade400),
          label: Text(
            "2022, July 14, July 15, July 16",
            style: TextStyle(color: Colors.deepPurple.shade400),
          ),
        ),
        Row(
          children: [
            DropdownButton<String>(
              hint: const Text("Filter by"),
              items: const [
                DropdownMenuItem(value: "Date", child: Text("Date")),
                DropdownMenuItem(value: "Comments", child: Text("Comments")),
                DropdownMenuItem(value: "Views", child: Text("Views")),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(width: 20.0),
            DropdownButton<String>(
              hint: const Text("Order by"),
              items: const [
                DropdownMenuItem(value: "Date", child: Text("Date")),
                DropdownMenuItem(value: "Comments", child: Text("Comments")),
                DropdownMenuItem(value: "Views", child: Text("Views")),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataTable() {
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

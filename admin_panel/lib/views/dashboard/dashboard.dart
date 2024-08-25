import 'package:admin_panel/views/widgets/dashboard_card.dart';
import 'package:admin_panel/views/widgets/header.dart';
import 'package:admin_panel/views/widgets/side_menu.dart';

import 'package:admin_panel/views/widgets/title_section.dart';
import 'package:admin_panel/views/widgets/filter_section.dart';
import 'package:admin_panel/views/widgets/data_table.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      body: Row(
        children: [
          if (!isSmallScreen)
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
              padding: const EdgeInsets.all(20.0),
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
                      isSmallScreen: isSmallScreen,
                      onSignOut: () {
                        // Handle sign out
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DashboardCard(
                            icon: Icons.article,
                            color: Colors.blue,
                            title: "Articles",
                            value: "6 Articles",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DashboardCard(
                            icon: Icons.comment,
                            color: Colors.red,
                            title: "Comments",
                            value: "+32 Comments",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DashboardCard(
                            icon: Icons.people,
                            color: Colors.amber,
                            title: "Subscribers",
                            value: "3.2M Subscribers",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DashboardCard(
                            icon: Icons.monetization_on_outlined,
                            color: Colors.green,
                            title: "Revenue",
                            value: "2,300 \$",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    const TitleSection(),
                    const SizedBox(height: 40.0),
                    const FilterSection(),
                    const SizedBox(height: 40.0),
                    const CustomDataTable(),
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
}

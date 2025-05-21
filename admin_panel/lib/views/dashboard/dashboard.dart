import 'package:admin_panel/views/widgets/header.dart';
import 'package:admin_panel/views/widgets/query_card.dart';
import 'package:admin_panel/views/widgets/side_menu.dart';
import 'package:admin_panel/views/widgets/summary_card.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F6F8),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SideMenu(),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Header(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SummaryCards(),
                        SizedBox(height: 40),
                        PendingQueries(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

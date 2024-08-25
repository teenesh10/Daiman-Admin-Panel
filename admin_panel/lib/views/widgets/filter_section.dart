import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSmallScreen)
              Column(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back, color: Colors.deepPurple.shade400),
                    label: Text(
                      "2022, July 14, July 15, July 16",
                      style: TextStyle(color: Colors.deepPurple.shade400),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  _buildDropdowns(isSmallScreen),
                ],
              )
            else
              Row(
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
                  _buildDropdowns(isSmallScreen),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildDropdowns(bool isSmallScreen) {
    return Row(
      children: [
        if (isSmallScreen) const SizedBox(height: 10.0),
        DropdownButton<String>(
          hint: const Text("Filter by"),
          items: const [
            DropdownMenuItem(value: "Date", child: Text("Date")),
            DropdownMenuItem(value: "Comments", child: Text("Comments")),
            DropdownMenuItem(value: "Views", child: Text("Views")),
          ],
          onChanged: (value) {},
        ),
        if (!isSmallScreen) const SizedBox(width: 20.0),
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
    );
  }
}

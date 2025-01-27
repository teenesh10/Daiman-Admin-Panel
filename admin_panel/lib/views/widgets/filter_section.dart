import 'package:flutter/material.dart';
import 'package:admin_panel/controllers/manage_facility_controller.dart';
import 'package:admin_panel/models/facility.dart';

class FacilityFilter extends StatelessWidget {
  final ManageFacilityController controller;
  final Function(String?) onFilterChanged;

  const FacilityFilter({
    super.key,
    required this.controller,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Facility>>(
      stream: controller.getFacilities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text("Error loading facilities");
        }

        final facilities = snapshot.data ?? [];

        return DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Select a Facility"),
          items: facilities.map((facility) {
            return DropdownMenuItem<String>(
              value: facility.facilityID,
              child: Text(facility.facilityName), // Assuming `name` is a field in `Facility`
            );
          }).toList(),
          onChanged: onFilterChanged,
        );
      },
    );
  }
}

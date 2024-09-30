import 'package:flutter/material.dart';
import 'package:admin_panel/controllers/manage_facility_controller.dart';
import 'package:admin_panel/models/facility.dart';

class FacilitySelectionWidget extends StatefulWidget {
  final Function(String) onFacilitySelected;

  const FacilitySelectionWidget({super.key, required this.onFacilitySelected});

  @override
  State<FacilitySelectionWidget> createState() => _FacilitySelectionWidgetState();
}

class _FacilitySelectionWidgetState extends State<FacilitySelectionWidget> {
  final ManageFacilityController _manageFacilityController = ManageFacilityController();
  String? selectedFacilityID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Facility>>(
      stream: _manageFacilityController.getFacilities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Error fetching facilities.');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No facilities available.');
        }

        final facilities = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Facility",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              hint: const Text("Choose a Facility"),
              value: selectedFacilityID,
              isExpanded: true,
              items: facilities.map((facility) {
                return DropdownMenuItem<String>(
                  value: facility.facilityID,
                  child: Text(facility.facilityName),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedFacilityID = newValue;
                });

                // Call the callback with the selected facilityID
                if (newValue != null) {
                  widget.onFacilitySelected(newValue);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

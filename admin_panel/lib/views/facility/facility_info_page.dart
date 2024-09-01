// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'package:admin_panel/controllers/manage_facility_controller.dart';
import 'package:admin_panel/models/court.dart';
import 'package:admin_panel/models/facility.dart';
import 'package:flutter/material.dart';

class FacilityInfoPage extends StatelessWidget {
  final String facilityId;
  final VoidCallback onClose;

  const FacilityInfoPage({
    super.key,
    required this.facilityId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final ManageFacilityController controller = ManageFacilityController();
    final Size size = MediaQuery.of(context).size;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(20.0),
      content: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.8,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Facility Information",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: FutureBuilder<Facility>(
                future: controller.getFacilityDetails(facilityId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error loading facility info'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Facility not found'));
                  }

                  final facility = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Facility Name: ${facility.facilityName}",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Capacity: ${facility.capacity}",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Description: ${facility.description}",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: StreamBuilder<List<Court>>(
                          stream: controller.getCourtsForFacility(facilityId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error loading courts'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No courts found'));
                            }

                            final courts = snapshot.data!;

                            return ListView.builder(
                              itemCount: courts.length,
                              itemBuilder: (context, index) {
                                final court = courts[index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(court.courtName),
                                    subtitle: Text(court.description),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            // Handle edit court
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            _showDeleteConfirmationDialog(
                                                context,
                                                court,
                                                controller,
                                                facilityId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Court court,
      ManageFacilityController controller, String facilityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Court"),
          content: Text(
            "Are you sure you want to delete ${court.courtName}? ${controller.getCourtsForFacility(facilityId).length == 1 ? "This will remove the facility as well." : ""}",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await controller.deleteCourt(facilityId, court.courtID);
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pop(); // Close the FacilityInfoPage dialog
              },
            ),
          ],
        );
      },
    );
  }
}

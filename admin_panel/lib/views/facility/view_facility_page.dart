import 'package:admin_panel/controllers/manage_facility_controller.dart';
import 'package:admin_panel/views/widgets/header.dart';
import 'package:admin_panel/views/widgets/side_menu.dart';
import 'package:flutter/material.dart';

class FacilityView extends StatefulWidget {
  const FacilityView({super.key});

  @override
  State<FacilityView> createState() => _FacilityViewState();
}

class _FacilityViewState extends State<FacilityView> {
  final ManageFacilityController _controller = ManageFacilityController();
  bool isExpanded = true;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Row(
        children: [
        const SideMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const Header(),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Facilities",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  // Search bar and Add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle add new facility
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add New Facility"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: StreamBuilder<List<Facility>>(
                      stream: _controller.getFacilities(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(child: Text('Error loading facilities'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No facilities found'));
                        }

                        final facilities = snapshot.data!
                            .where((facility) =>
                                facility.facilityName.toLowerCase().contains(searchQuery.toLowerCase()))
                            .toList();

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey.shade200),
                            columns: const [
                              DataColumn(label: Text("#")),
                              DataColumn(label: Text("Facility Name")),
                              DataColumn(label: Text("Capacity")),
                              DataColumn(label: Text("Actions")),
                            ],
                            rows: List.generate(facilities.length, (index) {
                              final facility = facilities[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text((index + 1).toString())),
                                  DataCell(Text(facility.facilityName)),
                                  DataCell(Text(facility.capacity.toString())),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.visibility),
                                          onPressed: () {
                                            // Handle view facility
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            // Handle edit facility
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () async {
                                            // Handle delete facility
                                            // await _controller.deleteFacility(facility.facilityId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                            border: TableBorder( // Add border
                              horizontalInside: BorderSide(
                                width: 1,
                                color: Colors.grey.shade300,
                                style: BorderStyle.solid,
                              ),
                              bottom: BorderSide(
                                width: 1,
                                color: Colors.grey.shade300,
                                style: BorderStyle.solid,
                              ),
                              verticalInside: BorderSide( // Add vertical borders for responsiveness
                                width: 1,
                                color: Colors.grey.shade300,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

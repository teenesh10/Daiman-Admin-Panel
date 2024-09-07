// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel/controllers/manage_facility_controller.dart';
import 'package:admin_panel/models/facility.dart';
import 'package:admin_panel/views/facility/edit_facility_page.dart';
import 'package:admin_panel/views/facility/facility_info_page.dart';
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
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  void _loadFacilities() async {
    final facilitiesStream = _controller.getFacilities();
    facilitiesStream.listen((facilities) {
      setState(() {
        // Facilities state updated here.
      });
    });
  }

  void _editFacility(Facility facility) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFacilityPage(facility: facility),
      ),
    );
  }

  // Function to show the confirmation dialog for deleting a facility
  void _showDeleteConfirmationDialog(BuildContext context, Facility facility) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Facility"),
          content: Text(
            "Are you sure you want to delete the facility: ${facility.facilityName}? This action cannot be undone.",
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
                await _controller.deleteFacility(facility.facilityID);
                Navigator.of(context).pop(); // Close the dialog
                // Optionally, you can add a notification/snackbar here to indicate successful deletion.
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          // Side Menu similar to DashboardView
          const Expanded(
            flex: 1,
            child: SideMenu(),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                // Header similar to DashboardView
                const Header(),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Manage Facilities",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/add_facility');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add New Facility"),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: size.width < 600 ? 10.0 : 15.0,
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 55, 255, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: StreamBuilder<List<Facility>>(
                      stream: _controller.getFacilities(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading facilities'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No facilities found'));
                        }

                        final facilities = snapshot.data!
                            .where((facility) => facility.facilityName
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                            .toList();

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 50.0, // Adjust column spacing
                            headingRowHeight:
                                80.0, // Increase heading row height
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey.shade200),
                            columns: const [
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "#",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Facility Name",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Capacity (No. of courts)",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Actions",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: List.generate(facilities.length, (index) {
                              final facility = facilities[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(fontSize: 16.0),
                                  )),
                                  DataCell(Text(
                                    facility.facilityName,
                                    style: const TextStyle(fontSize: 16.0),
                                  )),
                                  DataCell(Text(
                                    facility.capacity.toString(),
                                    style: const TextStyle(fontSize: 16.0),
                                  )),
                                  DataCell(Text(
                                    facility.description,
                                    style: const TextStyle(fontSize: 16.0),
                                  )),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.visibility),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return FacilityInfoPage(
                                                  facilityId:
                                                      facility.facilityID,
                                                  onClose: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the FacilityInfoPage dialog
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              _editFacility(facility),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _showDeleteConfirmationDialog(
                                                context, facility);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                            border: TableBorder(
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
                              verticalInside: BorderSide(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

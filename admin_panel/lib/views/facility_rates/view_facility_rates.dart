import 'package:admin_panel/controllers/manage_fee_controller.dart';
import 'package:admin_panel/models/fee.dart';
import 'package:admin_panel/views/facility_rates/add_facility_rates.dart';
import 'package:admin_panel/views/widgets/facility_selection.dart';
import 'package:admin_panel/views/widgets/header.dart';
import 'package:admin_panel/views/widgets/side_menu.dart';
import 'package:flutter/material.dart';

class ViewFacilityRates extends StatefulWidget {
  const ViewFacilityRates({super.key});

  @override
  State<ViewFacilityRates> createState() => _ViewFacilityRatesState();
}

class _ViewFacilityRatesState extends State<ViewFacilityRates> {
  final ManageFeeController _controller = ManageFeeController();
  String searchQuery = '';
  String? selectedFacilityID;

  @override
  void initState() {
    super.initState();
  }

  void _onFacilitySelected(String facilityID) {
    setState(() {
      selectedFacilityID = facilityID;
    });
  }

  void _showAddFacilityRateDialog(
      BuildContext context, String selectedFacilityID) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AddFacilityRatePage(selectedFacilityID: selectedFacilityID);
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Fee fee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this fee?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _controller.deleteFee(fee.facilityID,
                    fee.feeID); // Pass both facilityID and feeID
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text('Delete'),
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
          const Expanded(
            flex: 1,
            child: SideMenu(),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                const Header(),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Manage Facility Rates",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      selectedFacilityID != null
                          ? StreamBuilder<List<Fee>>(
                              stream: _controller.getFee(selectedFacilityID!),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  // Show Add button only when no rates exist
                                  return ElevatedButton.icon(
                                    onPressed: () {
                                      _showAddFacilityRateDialog(
                                          context, selectedFacilityID!);
                                      _controller
                                          .addFee(selectedFacilityID! as Fee);
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Fee'),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical:
                                            size.width < 600 ? 10.0 : 15.0,
                                      ),
                                      backgroundColor:
                                          const Color.fromARGB(255, 55, 255, 0),
                                    ),
                                  );
                                }
                                return const SizedBox
                                    .shrink(); // Hide button when data exists
                              },
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FacilitySelectionWidget(
                    onFacilitySelected: _onFacilitySelected,
                  ),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: selectedFacilityID == null
                      ? const Center(child: Text('Please select a facility.'))
                      : StreamBuilder<List<Fee>>(
                          stream: _controller.getFee(selectedFacilityID!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error loading rates'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No facility rates found'));
                            }

                            final rates = snapshot.data!
                                .where((rate) => rate.feeID
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()))
                                .toList();

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 50.0,
                                headingRowHeight: 80.0,
                                headingRowColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.grey.shade200),
                                columns: const [
                                  DataColumn(
                                    label: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "#",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Weekday Rate (MYR/1hr)",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Weekend Rate (MYR/1hr)",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
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
                                            fontWeight: FontWeight.bold),
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List.generate(rates.length, (index) {
                                  final fee = rates[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(fontSize: 16.0),
                                      )),
                                      DataCell(Text(
                                        fee.weekdayRate.toString(),
                                        style: const TextStyle(fontSize: 16.0),
                                      )),
                                      DataCell(Text(
                                        fee.weekendRate.toString(),
                                        style: const TextStyle(fontSize: 16.0),
                                      )),
                                      DataCell(Text(
                                        fee.description,
                                        style: const TextStyle(fontSize: 16.0),
                                      )),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                // Logic for editing fee
                                                _controller.updateFee(fee);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                _showDeleteConfirmation(
                                                    context, fee);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

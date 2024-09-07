// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:admin_panel/controllers/manage_facility_controller.dart';
import 'package:admin_panel/models/facility.dart';
import 'package:admin_panel/models/court.dart';
import 'package:admin_panel/views/facility/court/add_court_page.dart';
import 'package:admin_panel/views/facility/court/edit_court_page.dart';
import 'package:admin_panel/views/widgets/header.dart';
import 'package:admin_panel/views/widgets/side_menu.dart';

class EditFacilityPage extends StatefulWidget {
  final Facility facility;

  const EditFacilityPage({super.key, required this.facility});

  @override
  _EditFacilityPageState createState() => _EditFacilityPageState();
}

class _EditFacilityPageState extends State<EditFacilityPage> {
  final _formKey = GlobalKey<FormState>();
  final ManageFacilityController _controller = ManageFacilityController();

  String _facilityName = '';
  int _capacity = 0;
  String _description = '';
  List<Court> _courts = [];
  String _remainingCourtsMessage = '';
  bool _isCapacityValid = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFacilityDetails();
  }

  void _loadFacilityDetails() async {
    final courts = await _controller
        .getCourtsForFacility(widget.facility.facilityID)
        .first;

    setState(() {
      _facilityName = widget.facility.facilityName;
      _capacity = widget.facility.capacity;
      _description = widget.facility.description;
      _courts = courts;
      _updateRemainingCourtsMessage();
      _checkCapacityValidity();
      _isLoading = false;
    });
  }

  void _addCourt() async {
    final newCourt = await showDialog<Court>(
      context: context,
      builder: (BuildContext context) {
        return const AddCourtPage();
      },
    );

    if (newCourt != null) {
      setState(() {
        _courts.add(newCourt);
        _updateRemainingCourtsMessage();
        _checkCapacityValidity();
      });
    }
  }

  void _editCourt(Court court, int index) async {
    final updatedCourt = await showDialog<Court>(
      context: context,
      builder: (BuildContext context) {
        return EditCourtPage(court: court);
      },
    );

    if (updatedCourt != null) {
      setState(() {
        _courts[index] = updatedCourt; // Update the court in the local list
        _updateRemainingCourtsMessage(); // Update the UI with the new court data
        _checkCapacityValidity();
      });

      // Save the updated court in Firestore
      try {
        await _controller.updateCourt(widget.facility.facilityID, updatedCourt);
      } catch (e) {
        _showAlertDialog('Error', 'Failed to update court: $e', false);
      }
    }
  }

  void _deleteCourt(int index) {
    setState(() {
      _courts.removeAt(index);
      _updateRemainingCourtsMessage();
    });
  }

  void _updateRemainingCourtsMessage() {
    final remainingCourts = _capacity - _courts.length;
    setState(() {
      if (remainingCourts > 0) {
        _remainingCourtsMessage =
            'You need to add $remainingCourts more court(s).';
      } else {
        _remainingCourtsMessage = '';
      }
    });
  }

  void _checkCapacityValidity() {
    setState(() {
      _isCapacityValid = _capacity > 0 && _courts.length <= _capacity;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_courts.length < _capacity) {
        _showAlertDialog('Validation Error',
            'You cannot have fewer courts than the capacity.', false);
        return;
      }

      _formKey.currentState!.save();
      final updatedFacility = Facility(
        facilityID: widget.facility.facilityID,
        facilityName: _facilityName,
        capacity: _capacity,
        description: _description,
      );

      try {
        // Update facility in Firestore
        await _controller.updateFacility(updatedFacility);

        // Handle courts (add, edit, delete logic)
        for (var court in _courts) {
          if (court.courtID.isEmpty) {
            // New court
            await _controller.addCourt(widget.facility.facilityID, court);
          } else {
            // Existing court
            await _controller.updateCourt(widget.facility.facilityID, court);
          }
        }

        _showAlertDialog(
            'Success', 'Facility and courts updated successfully.', true);
      } catch (e) {
        _showAlertDialog('Error', 'Failed to update facility: $e', false);
      }
    }
  }

  void _showAlertDialog(String title, String message, bool navigateOnOk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (navigateOnOk) {
                  Navigator.pushReplacementNamed(context, '/facilities');
                }
              },
              child: const Text('OK'),
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
                const SizedBox(height: 60.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child:
                        _isLoading // Display loader while data is being fetched
                            ? const CircularProgressIndicator()
                            : Container(
                                constraints: BoxConstraints(
                                  maxWidth: 800.0, // Maximum width for the form
                                  minHeight: size.height *
                                      0.4, // Minimum height for the form
                                ),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10.0,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            "Edit Facility",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Facility Name',
                                          ),
                                          initialValue: _facilityName,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a facility name';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _facilityName = value!;
                                          },
                                        ),
                                        const SizedBox(height: 20.0),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Capacity (No. of courts)',
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                initialValue:
                                                    _capacity.toString(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter a capacity';
                                                  }
                                                  if (int.tryParse(value) ==
                                                          null ||
                                                      int.parse(value) <= 0) {
                                                    return 'Please enter a valid capacity';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  _capacity =
                                                      int.tryParse(value) ?? 0;
                                                  _checkCapacityValidity();
                                                  _updateRemainingCourtsMessage();
                                                },
                                                onSaved: (value) {
                                                  _capacity = int.parse(value!);
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 20.0),
                                            ElevatedButton.icon(
                                              onPressed: _isCapacityValid
                                                  ? _addCourt
                                                  : null,
                                              icon: const Icon(Icons.add),
                                              label: const Text('Add Court'),
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: size.width < 600
                                                      ? 10.0
                                                      : 15.0,
                                                ),
                                                backgroundColor:
                                                    _isCapacityValid
                                                        ? Colors.green
                                                        : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (_remainingCourtsMessage
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 10.0),
                                          Text(
                                            _remainingCourtsMessage,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        ],
                                        const SizedBox(height: 20.0),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Description',
                                          ),
                                          initialValue: _description,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a description';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _description = value!;
                                          },
                                        ),
                                        const SizedBox(height: 20.0),
                                        const Divider(),
                                        const SizedBox(height: 20.0),
                                        Text(
                                          'Courts:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(height: 10.0),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _courts.length,
                                          itemBuilder: (context, index) {
                                            final court = _courts[index];
                                            return ListTile(
                                              title: Text(court.courtName),
                                              subtitle: Text(court.description),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    onPressed: () => _editCourt(
                                                        court, index),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: () =>
                                                        _deleteCourt(index),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 20.0),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: _submitForm,
                                            child: const Text('Save Changes'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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

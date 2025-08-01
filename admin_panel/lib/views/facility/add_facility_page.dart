// ignore_for_file: library_private_types_in_public_api

import 'package:admin_panel/views/facility/court/add_court_page.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/controllers/manage_facility_controller.dart';
import 'package:admin_panel/models/court.dart';
import 'package:admin_panel/models/facility.dart';
import 'package:admin_panel/views/widgets/header.dart';
import 'package:admin_panel/views/widgets/side_menu.dart';

class AddFacilityPage extends StatefulWidget {
  const AddFacilityPage({super.key});

  @override
  _AddFacilityPageState createState() => _AddFacilityPageState();
}

class _AddFacilityPageState extends State<AddFacilityPage> {
  final _formKey = GlobalKey<FormState>();
  final ManageFacilityController _controller = ManageFacilityController();

  String _facilityName = '';
  int _capacity = 0;
  String _description = '';
  final List<Court> _courts = [];
  String _remainingCourtsMessage = '';
  bool _isCapacityValid = false;

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
      });
    }
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
      _isCapacityValid = _capacity > 0;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_courts.length != _capacity) {
        _showAlertDialog('Validation Error',
            'Please add the correct number of courts.', false);
        return;
      }
      _formKey.currentState!.save();
      final newFacility = Facility(
        facilityID: '',
        facilityName: _facilityName,
        capacity: _capacity,
        description: _description,
      );

      try {
        // Store facility and courts in Firestore
        final facilityDocRef = await _controller.addFacility(newFacility);
        for (var court in _courts) {
          await _controller.addCourt(facilityDocRef.id, court);
        }
        _showAlertDialog(
            'Success', 'Facility and courts added successfully.', true);
      } catch (e) {
        _showAlertDialog('Error', 'Failed to add facility: $e', false);
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
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 800.0,
                        minHeight: size.height * 0.4,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Add New Facility",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Facility Name',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
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
                                      decoration: const InputDecoration(
                                        labelText: 'Capacity (No. of courts)',
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a capacity';
                                        }
                                        if (int.tryParse(value) == null ||
                                            int.parse(value) <= 0) {
                                          return 'Please enter a valid capacity';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        _capacity = int.tryParse(value) ?? 0;
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
                                    onPressed:
                                        _isCapacityValid ? _addCourt : null,
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Court'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical:
                                            size.width < 600 ? 10.0 : 15.0,
                                      ),
                                      backgroundColor: _isCapacityValid
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              if (_remainingCourtsMessage.isNotEmpty) ...[
                                const SizedBox(height: 10.0),
                                Text(
                                  _remainingCourtsMessage,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                              const SizedBox(height: 20.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _description = value!;
                                },
                              ),
                              const SizedBox(height: 20.0),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical:
                                              size.width < 600 ? 10.0 : 15.0,
                                        ),
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(width: 10.0),
                                    ElevatedButton(
                                      onPressed: _capacity > 0 &&
                                              _courts.length == _capacity
                                          ? _submitForm
                                          : null,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical:
                                              size.width < 600 ? 10.0 : 15.0,
                                        ),
                                        backgroundColor: (_capacity > 0 &&
                                                _courts.length == _capacity)
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Submit'),
                                    ),
                                  ],
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

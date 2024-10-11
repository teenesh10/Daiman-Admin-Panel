// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:admin_panel/models/fee.dart';
import 'package:admin_panel/controllers/manage_fee_controller.dart';

class EditFacilityRatePage extends StatefulWidget {
  final Fee fee;

  const EditFacilityRatePage({super.key, required this.fee});

  @override
  _EditFacilityRatePageState createState() => _EditFacilityRatePageState();
}

class _EditFacilityRatePageState extends State<EditFacilityRatePage> {
  final _formKey = GlobalKey<FormState>();
  final ManageFeeController _controller = ManageFeeController();

  late double _weekdayRate;
  late double _weekendRate;
  late String _description;
  late String _facilityID;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with the existing fee data
    _weekdayRate = widget.fee.weekdayRate;
    _weekendRate = widget.fee.weekendRate;
    _description = widget.fee.description;
    _facilityID = widget.fee.facilityID;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedFee = Fee(
        feeID: widget.fee.feeID, // Use the existing feeID
        facilityID: _facilityID, // Use the initialized facilityID
        weekdayRate: _weekdayRate,
        weekendRate: _weekendRate,
        description: _description,
      );

      // Submit updated fee to Firestore
      _controller.updateFee(updatedFee);

      Navigator.pop(
          context, updatedFee); // Return updated fee object after submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: size.width < 600 ? size.width * 0.8 : size.width * 0.5,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Edit Facility Rate',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: _weekdayRate
                      .toString(), // Prepopulate with current weekday rate
                  decoration: const InputDecoration(
                    labelText: 'Weekday Rate (MYR/1hr)',
                    prefixText: 'RM ', // 'RM' before input
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a weekday rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekdayRate = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: _weekendRate
                      .toString(), // Prepopulate with current weekend rate
                  decoration: const InputDecoration(
                    labelText: 'Weekend Rate (MYR/1hr)',
                    prefixText: 'RM ', // 'RM' before input
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a weekend rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekendRate = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                // Edit the description field
                TextFormField(
                  initialValue:
                      _description, // Prepopulate with current description
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value ?? '';
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: size.width < 600 ? 10.0 : 15.0,
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: size.width < 600 ? 10.0 : 15.0,
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

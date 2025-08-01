// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:admin_panel/models/fee.dart';
import 'package:admin_panel/controllers/manage_fee_controller.dart';

class AddFacilityRatePage extends StatefulWidget {
  final String selectedFacilityID;

  const AddFacilityRatePage({super.key, required this.selectedFacilityID});

  @override
  _AddFacilityRatePageState createState() => _AddFacilityRatePageState();
}

class _AddFacilityRatePageState extends State<AddFacilityRatePage> {
  final _formKey = GlobalKey<FormState>();
  final ManageFeeController _controller = ManageFeeController();

  double _weekdayRateBefore6 = 0.0;
  double _weekdayRateAfter6 = 0.0;
  double _weekendRateBefore6 = 0.0;
  double _weekendRateAfter6 = 0.0;
  String _description = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newFee = Fee(
        feeID: '',
        facilityID: widget.selectedFacilityID,
        weekdayRateBefore6: _weekdayRateBefore6,
        weekdayRateAfter6: _weekdayRateAfter6,
        weekendRateBefore6: _weekendRateBefore6,
        weekendRateAfter6: _weekendRateAfter6,
        description: _description,
      );

      _controller.addFee(newFee).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Facility rate added successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, newFee);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding facility rate: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields.'),
          backgroundColor: Colors.orange,
        ),
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
                    'Add Facility Rate',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Weekday Rate Before 6 PM (MYR/1hr)',
                    prefixText: 'RM ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekdayRateBefore6 = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Weekday Rate After 6 PM (MYR/1hr)',
                    prefixText: 'RM ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekdayRateAfter6 = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Weekend Rate Before 6 PM (MYR/1hr)',
                    prefixText: 'RM ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekendRateBefore6 = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Weekend Rate After 6 PM (MYR/1hr)',
                    prefixText: 'RM ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekendRateAfter6 = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
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
                          foregroundColor: Colors.white),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: size.width < 600 ? 10.0 : 15.0,
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white),
                      child: const Text('Submit'),
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

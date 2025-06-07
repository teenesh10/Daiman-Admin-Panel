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

  late double _weekdayRateBefore6;
  late double _weekdayRateAfter6;
  late double _weekendRateBefore6;
  late double _weekendRateAfter6;
  late String _description;

  @override
  void initState() {
    super.initState();
    _weekdayRateBefore6 = widget.fee.weekdayRateBefore6;
    _weekdayRateAfter6 = widget.fee.weekdayRateAfter6;
    _weekendRateBefore6 = widget.fee.weekendRateBefore6;
    _weekendRateAfter6 = widget.fee.weekendRateAfter6;
    _description = widget.fee.description;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedFee = Fee(
        feeID: widget.fee.feeID,
        facilityID: widget.fee.facilityID,
        weekdayRateBefore6: _weekdayRateBefore6,
        weekdayRateAfter6: _weekdayRateAfter6,
        weekendRateBefore6: _weekendRateBefore6,
        weekendRateAfter6: _weekendRateAfter6,
        description: _description,
      );

      _controller.updateFee(updatedFee).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Facility rate updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, updatedFee);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating facility rate: $error'),
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
                    'Edit Facility Rate',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: _weekdayRateBefore6.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Weekday Rate (Before 6PM)',
                    prefixText: 'RM ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekdayRateBefore6 = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: _weekdayRateAfter6.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Weekday Rate (After 6PM)',
                    prefixText: 'RM ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekdayRateAfter6 = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: _weekendRateBefore6.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Weekend Rate (Before 6PM)',
                    prefixText: 'RM ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekendRateBefore6 = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: _weekendRateAfter6.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Weekend Rate (After 6PM)',
                    prefixText: 'RM ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid rate';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weekendRateAfter6 = double.tryParse(value!) ?? 0.0;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid description';
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
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: size.width < 600 ? 10.0 : 15.0,
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: size.width < 600 ? 10.0 : 15.0,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
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

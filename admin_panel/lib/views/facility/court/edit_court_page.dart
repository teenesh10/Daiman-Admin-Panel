import 'package:flutter/material.dart';
import 'package:admin_panel/models/court.dart';

class EditCourtPage extends StatefulWidget {
  final Court court;

  const EditCourtPage({super.key, required this.court});

  @override
  _EditCourtPageState createState() => _EditCourtPageState();
}

class _EditCourtPageState extends State<EditCourtPage> {
  final _formKey = GlobalKey<FormState>();
  late String _courtName;
  late String _description;

  @override
  void initState() {
    super.initState();
    _courtName = widget.court.courtName;
    _description = widget.court.description;
  }

void _submitForm() {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    final updatedCourt = Court(
      courtID: widget.court.courtID,
      courtName: _courtName,
      description: _description,
      availability: widget.court.availability, // Ensure this matches the expected type
    );
    Navigator.of(context).pop(updatedCourt);
  }
}



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Court'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Court Name'),
              initialValue: _courtName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a court name';
                }
                return null;
              },
              onSaved: (value) {
                _courtName = value!;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              initialValue: _description,
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

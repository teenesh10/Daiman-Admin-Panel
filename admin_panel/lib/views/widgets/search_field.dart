import 'package:flutter/material.dart';
import '../../../constants.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: bgColor,
        filled: true,
        // Define the border properties here
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5), // Border color and width
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.black.withOpacity(0.5), width: 1.5), // Border color and width when the field is enabled
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.black, width: 1.5), // Border color and width when the field is focused
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        prefixIcon: const Icon(
          Icons.search,
          color:  Colors.black, // Adjust color if needed
        ),
      ),
    );
  }
}

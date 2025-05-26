// import 'package:admin_panel/controllers/manage_facility_controller.dart';
// import 'package:admin_panel/views/widgets/filter_section.dart';
// import 'package:flutter/material.dart';
// import 'package:admin_panel/controllers/manage_booking_controller.dart';
// import 'package:admin_panel/models/booking.dart';
// import 'package:admin_panel/views/widgets/header.dart';
// import 'package:admin_panel/views/widgets/side_menu.dart';

// class ManageBookingView extends StatefulWidget {
//   const ManageBookingView({super.key});

//   @override
//   State<ManageBookingView> createState() => _ManageBookingViewState();
// }

// class _ManageBookingViewState extends State<ManageBookingView> {
//   final ManageBookingController _controller = ManageBookingController();
//   final ManageFacilityController _facilityController = ManageFacilityController();
//   String? selectedFacilityId;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           const Expanded(
//             flex: 1,
//             child: SideMenu(),
//           ),
//           Expanded(
//             flex: 5,
//             child: Column(
//               children: [
//                 const Header(),
//                 const SizedBox(height: 20.0),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Manage Bookings",
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       SizedBox(
//                         width: 300.0,
//                         child: FacilityFilter(
//                           controller: _facilityController,
//                           onFilterChanged: (facilityId) {
//                             setState(() {
//                               selectedFacilityId = facilityId;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: StreamBuilder<List<Booking>>(
//                       stream: _controller.getBookings(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }
//                         if (snapshot.hasError) {
//                           return const Center(
//                               child: Text('Error loading bookings'));
//                         }
//                         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                           return const Center(
//                               child: Text('No bookings found'));
//                         }

//                         final bookings = snapshot.data!.where((booking) {
//                           return selectedFacilityId == null ||
//                               booking.facilityID == selectedFacilityId;
//                         }).toList();

//                         return SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: DataTable(
//                             columnSpacing: 50.0,
//                             headingRowHeight: 60.0,
//                             headingRowColor: MaterialStateProperty.resolveWith(
//                                 (states) => Colors.grey.shade200),
//                             columns: const [
//                               DataColumn(label: Text("ID")),
//                               DataColumn(label: Text("Facility")),
//                               DataColumn(label: Text("User")),
//                               DataColumn(label: Text("Date")),
//                               DataColumn(label: Text("Timeslot")),
//                               DataColumn(label: Text("Court")),
//                               DataColumn(label: Text("Amount (RM)")),
//                             ],
//                             rows: bookings.map((booking) {
//                               return DataRow(
//                                 cells: [
//                                   DataCell(Text(booking.bookingID)),
                                  
//                                   DataCell(Text(
//                                       '${booking.bookingDate.day}-${booking.bookingDate.month}-${booking.bookingDate.year}')),
//                                   DataCell(Text(booking.timeslot)),
                          
//                                   DataCell(Text(booking.amount.toStringAsFixed(
//                                       2))),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

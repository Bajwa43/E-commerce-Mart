// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class CurrentLocationMap extends StatefulWidget {
//   const CurrentLocationMap({Key? key}) : super(key: key);

//   @override
//   State<CurrentLocationMap> createState() => _CurrentLocationMapState();
// }

// class _CurrentLocationMapState extends State<CurrentLocationMap> {
//   GoogleMapController? mapController;
//   LatLng? currentLocation;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     // Request permission if needed
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     // Get the current position
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       currentLocation = LatLng(position.latitude, position.longitude);
//     });

//     mapController?.animateCamera(
//       CameraUpdate.newLatLngZoom(currentLocation!, 15),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Current Location")),
//       body: currentLocation == null
//           ? const Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: currentLocation!,
//                 zoom: 15,
//               ),
//               myLocationEnabled: true,
//               onMapCreated: (controller) {
//                 mapController = controller;
//               },
//             ),
//     );
//   }
// }

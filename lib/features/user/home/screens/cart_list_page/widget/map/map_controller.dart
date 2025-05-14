// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';

// class MapController extends GetxController {
//   /// 🌐 Observables to hold latitude and longitude
//   RxDouble latitude = 0.0.obs;
//   RxDouble longitude = 0.0.obs;

//   /// Full Position object if needed
//   Rxn<Position> currentPosition = Rxn<Position>();

//   /// ✅ Method to get current location
//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // 1. Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     // 2. Check & request permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }

//     // 3. Get current position
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

//   void fetchLocation() async {
//     try {
//       Position position = await getCurrentLocation();
//       currentPosition.value = position;
//       latitude.value = position.latitude;
//       longitude.value = position.longitude;

//       print('Latitude: ${latitude.value}');
//       print('Longitude: ${longitude.value}');
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }

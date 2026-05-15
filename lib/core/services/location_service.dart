// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class LocationService {
  
//   Future<Position> getCurrentPosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }

  
//   Future<Map<String, String>> getCityAndCountryFromCoordinates(Position position) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);

//     if (placemarks.isEmpty) {
//       throw Exception('No placemarks found.');
//     }

//     Placemark place = placemarks.first;
//     String city = place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
//     String country = place.country ?? 'Unknown Country';

//     return {'city': city, 'country': country};
//   }

//   /// دالة جاهزة للاستخدام: تعيد المدينة الحالية
//   Future<String> getCityFromCurrentLocation() async {
//     Position position = await getCurrentPosition();
//     Map<String, String> data = await getCityAndCountryFromCoordinates(position);
//     return data['city']!;
//   }
// }

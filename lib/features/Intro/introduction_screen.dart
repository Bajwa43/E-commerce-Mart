// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:vendoora_mart/features/auth/auth_wraper.dart';
// import 'package:vendoora_mart/utiles/constants/image_string.dart';

// class OnBoardingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IntroductionScreen(
//       pages: [
//         PageViewModel(
//           title: "Welcome",
//           body: "This is a sample onboarding screen.",
//           image: Center(child: Image.asset(TImageString.banner, height: 175.0)),
//         ),
//         PageViewModel(
//           title: "Shop Easily",
//           body: "Get your favorite products delivered.",
//           image:
//               Center(child: Image.asset(TImageString.myImage, height: 175.0)),
//         ),
//       ],
//       onDone: () {
//         // Go to login/home
//         Navigator.of(context)
//             .pushReplacement(MaterialPageRoute(builder: (_) => AuthWrapper()));
//       },
//       showSkipButton: true,
//       skip: const Text("Skip"),
//       next: const Icon(Icons.arrow_forward),
//       done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
//     );
//   }
// }

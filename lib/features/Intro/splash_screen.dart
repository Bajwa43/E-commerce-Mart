// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vendoora_mart/features/Intro/onboading_module/onboarding_screen.dart';
// import 'package:vendoora_mart/helper/helper_functions.dart';

// import 'package:vendoora_mart/utiles/constants/image_string.dart';
// import 'package:vendoora_mart/utiles/constants/text_strings.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Timer(Duration(seconds: 3), () {
//       HelperFunctions.navigateToScreen(
//           context: context, screen: const OnBoardingScreen());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(width: 150.h, child: Image.asset(TImageString.person)),
//             Text(KText.introTitle,
//                 // style: KAppTheme.textTheme.displayLarge,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 40.sp,
//                     fontWeight: FontWeight.bold))
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendoora_mart/features/Intro/onboading_module/onboarding_screen.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Initialize the fade animation
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Start the animation
    _controller.forward();

    // Navigate to SignUpScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when done
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColors.accent,
      // backgroundColor: Colors.white,

      body: Stack(
        children: [
          // Background CustomPainter
          CustomPaint(
            size: screenSize,
            painter: SplashPainter(),
          ),
          // Fade-in logo
          Positioned(
            top: 300,
            left: 60,
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(children: [
                  Image.asset(
                    TImageString
                        .mart, // Ensure this file exists in the correct path
                    height: 200, // Adjust the size of the logo as needed
                  ),
                  Text(
                    'Vendora Mart',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Times New Roman', // Elegant system font
                      shadows: [
                        Shadow(
                          offset: Offset(3, 3),
                          blurRadius: 6,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double height = size.height;
    final double width = size.width;

    // Define paint objects
    final Paint topPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final Paint bottomPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Top curve
    final Path topPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, height * 0.1)
      ..quadraticBezierTo(width * 0.25, height * 0.2, width * 0.5, height * 0.1)
      ..quadraticBezierTo(width * 0.75, 0, width, height * 0.1)
      ..lineTo(width, 0)
      ..close();
    canvas.drawPath(topPath, topPaint);

    // Bottom curve
    final Path bottomPath = Path()
      ..moveTo(0, height * 0.9)
      ..quadraticBezierTo(width * 0.75, height, width * 0.5, height * 0.9)
      ..quadraticBezierTo(width * 0.25, height * 0.8, width, height * 0.9)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
    canvas.drawPath(bottomPath, topPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SignInPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double height = size.height;
    final double width = size.width;

    // Define paint objects
    final Paint topPaint = Paint()
      ..color = Color.fromARGB(255, 243, 242, 241)
      ..style = PaintingStyle.fill;

    final Paint bottomPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;

    // Top curve
    final Path topPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, height * 0.25)
      ..lineTo(width * 0.1, height * 0.2)
      ..quadraticBezierTo(
          width * 0.19, height * 0.16, width * 0.265, height * 0.2)
      ..lineTo(width * 0.85, height * 0.55)
      ..quadraticBezierTo(
          width * 0.93, height * 0.6, width * 0.85, height * 0.65)
      ..lineTo(width * 0.28, height * 0.93)
      ..quadraticBezierTo(
          width * 0.19, height * 0.965, width * 0.1, height * 0.93)
      ..lineTo(0, height * 0.875)
      ..close();
    canvas.drawPath(topPath, topPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

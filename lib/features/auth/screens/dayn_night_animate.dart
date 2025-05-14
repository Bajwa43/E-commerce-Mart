import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendoora_mart/features/auth/screens/prfile.dart';

// import 'flip_login_signup.dart';

class DayAndNightLoginAnimation extends StatefulWidget {
  const DayAndNightLoginAnimation({super.key});

  @override
  State<DayAndNightLoginAnimation> createState() =>
      _DayAndNightLoginAnimationState();
}

class _DayAndNightLoginAnimationState extends State<DayAndNightLoginAnimation> {
  var sizeOfScreen;
  double heightOfScreen = 0;
  double widthOfScreen = 0;
  // double widthOfImageHolder = 0;
  // double heightOfImageHolder = 0;
  var cross;
  var colorOfIcon;
  var darkBackGroundColor;
  double getSun = 0;
  double getMoon = 0;
  // double heightOfMoon = 0;
  // double withOfMoon = 0;
  // double heightOfSun = 0;
  // double widthOfSun = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // sizeOfScreen = MediaQuery.of(context).size;
    // heightOfScreen = sizeOfScreen.height - kToolbarHeight;
    heightOfScreen = 1.sh;
    widthOfScreen = 1.sw;
    // widthOfScreen = sizeOfScreen.width;
    // cross = CrossFadeState.showSecond;
    colorOfIcon = Colors.white;
    darkBackGroundColor = const [
      Color(0xFF8C2480),
      Color(0xFFCE587D),
      Color(0xFFFF9485)
    ];
    getSun = heightOfScreen * 0.9;
    getMoon = 0;
    // heightOfMoon = 0;
    // withOfMoon = 0;
    // heightOfSun = 0;
    // widthOfSun = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // backgroundColor: Color.fromARGB(255, 237, 232, 129),
        backgroundColor: Color(0xFF8C2480),
        appBar:
            AppBar(centerTitle: true, title: const Text("Welcome"), actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  if (cross == CrossFadeState.showFirst) {
                    cross = CrossFadeState.showSecond;
                    colorOfIcon = Colors.white;
                    darkBackGroundColor = const [
                      Color(0xFF8C2480),
                      Color(0xFFCE587D),
                      Color(0xFFFF9485)
                    ];
                    getSun = heightOfScreen * 0.9;
                    getMoon = 0;
                    // heightOfMoon = 0;
                    // withOfMoon = 0;
                    // heightOfSun = 100;
                    // widthOfSun = 100;
                  } else {
                    cross = CrossFadeState.showFirst;
                    colorOfIcon = Colors.black;
                    darkBackGroundColor = const [
                      Color(0xFF0D1441),
                      Color(0xFF283584),
                      Color(0xFF376AB2),
                    ];
                    getMoon = heightOfScreen * 0.9;
                    getSun = 0;
                    // heightOfMoon = 100;
                    // withOfMoon = 100;
                    // heightOfSun = 0;
                    // widthOfSun = 0;
                  }
                });
              },
              child: RotatedBox(
                quarterTurns: 3,
                child: Icon(
                  Icons.nightlight,
                  color: colorOfIcon,
                ),
              ))
        ]),
        body: Stack(children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: heightOfScreen,
            width: widthOfScreen,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: darkBackGroundColor)),
          ),

          // SUN IMAGE
          AnimatedPositioned(
            height: 100,
            width: 100,
            left: widthOfScreen * 0.17,
            top: heightOfScreen - getSun,
            duration: const Duration(seconds: 1),
            child: AnimatedRotation(
              duration: const Duration(seconds: 2),
              turns: 5,
              child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 90,
                            color: Color.fromARGB(255, 250, 221, 4))
                      ]),
                  height: 100,
                  width: 100,
                  child: Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/1/sun2.png'))),
            ),
          ),

          // MOON IMAGE
          AnimatedPositioned(
            height: 100,
            width: 100,
            left: 40,
            top: heightOfScreen - getMoon,
            duration: const Duration(seconds: 1),
            child: AnimatedRotation(
              duration: const Duration(seconds: 1),
              turns: 3,
              child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 40,
                            color: Colors.white38)
                      ]),
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/images/1/moon.png')),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 0),
            top: heightOfScreen * 0.56,
            width: widthOfScreen,
            child: Image.asset(
              "assets/images/1/land_tree_light.png",
              // "assets/images/1/land_tree_dark.png",
              height: 420,
              fit: BoxFit.fitHeight,
            ),
          ),
          //Login Container
          Positioned(
              top: heightOfScreen * 0.25,
              left: widthOfScreen * 0.1,
              child: SizedBox(
                height: heightOfScreen * 0.6,
                width: widthOfScreen * 0.8,
                child: const ProfileCard(),
              ))
        ]),
      ),
    );
  }
}

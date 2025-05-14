import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/auth/screens/loginScreen.dart';
import 'package:vendoora_mart/features/auth/screens/registration.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard();

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isFlipped = true;
  var sizeOfMyScreen;
  double heightOfScreen = 0;
  double widthOfScreen = 0;
  double heightOfContainer = 0;
  double widthOfContainer = 0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      // String username = _usernameController.text;
      // String password = _passwordController.text;

      try {
        AuthService.loginUserWithEmailAndPassword(
            context, _usernameController, _passwordController);
      } catch (e) {
        HelperFunctions.showToast('Network Issue');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!kReleaseMode) {
      _usernameController.text = "nomanali@gmail.com";
      _passwordController.text = "nomanali";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sizeOfMyScreen = MediaQuery.of(context).size;
    heightOfScreen = sizeOfMyScreen.height;
    widthOfScreen = sizeOfMyScreen.width;
    heightOfContainer = heightOfScreen * 0.5;
    widthOfContainer = widthOfScreen * 0.8;
  }

  @override
  Widget build(BuildContext context) {
    // return CardHolder(
    //     toggler: isFlipped,
    // frontCard:
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
              height: heightOfScreen * 0.5,
              width: widthOfScreen * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              child: Stack(
                children: [
                  Positioned(
                      top: heightOfContainer * 0.02,
                      child: Container(
                        alignment: Alignment.center,
                        height: heightOfContainer * 0.1,
                        width: widthOfContainer,
                        color: Colors.transparent,
                        child: const Text(
                          "Login Here",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      )),

                  Positioned(
                      top: heightOfContainer * 0.15,
                      left: widthOfContainer * 0.05,
                      child: SizedBox(
                        // height: heightOfContainer * 0.12,
                        width: widthOfContainer * 0.9,
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                      )),

                  Positioned(
                      top: heightOfContainer * 0.35,
                      left: widthOfContainer * 0.05,
                      child: SizedBox(
                        // height: heightOfContainer * 0.12,
                        width: widthOfContainer * 0.9,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                      )),

                  // LOGIN BUTTON
                  Positioned(
                      top: heightOfContainer * 0.72,
                      child: GestureDetector(
                        onTap: () => _validateAndLogin(),
                        child: Container(
                          alignment: Alignment.center,
                          height: heightOfContainer * 0.1,
                          width: widthOfContainer,
                          color: Colors.white.withOpacity(0.4),
                          child: const Text("Login"),
                        ),
                      )),

                  // REGISTER BUTTON
                  Positioned(
                    top: heightOfContainer * 0.88,
                    child: GestureDetector(
                        onTap: () {
                          HelperFunctions.navigateToScreen(
                              context: context, screen: RegistrationScreen());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: heightOfContainer * 0.12,
                          width: widthOfContainer,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24))),
                          child: const Text("Go for Register",
                              style: TextStyle(color: Colors.white)),
                        )),
                  )
                ],
              )),
        ],
      ),
    );
    // backCard: Column(
    //   children: [
    //     Container(
    //         height: heightOfScreen * 0.5,
    //         width: widthOfScreen * 0.8,
    //         decoration: BoxDecoration(
    //             color: Colors.white.withOpacity(0.2),
    //             borderRadius: const BorderRadius.all(Radius.circular(24))),
    //         child: Stack(
    //           children: [
    //             //here we go
    //             Positioned(
    //                 top: heightOfContainer * 0.02,
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   height: heightOfContainer * 0.1,
    //                   width: widthOfContainer,
    //                   color: Colors.transparent,
    //                   child: const Text(
    //                     "Sign Up Here",
    //                     style: TextStyle(color: Colors.black, fontSize: 22),
    //                   ),
    //                 )),

    //             Positioned(
    //                 top: heightOfContainer * 0.15,
    //                 left: widthOfContainer * 0.05,
    //                 child: SizedBox(
    //                     height: heightOfContainer * 0.12,
    //                     width: widthOfContainer * 0.9,
    //                     child: const TextField(
    //                       decoration: InputDecoration(
    //                           hintText: "Username",
    //                           border: OutlineInputBorder(
    //                               borderRadius:
    //                                   BorderRadius.all(Radius.circular(12)),
    //                               borderSide:
    //                                   BorderSide(color: Colors.black))),
    //                     ))),
    //             Positioned(
    //                 top: heightOfContainer * 0.30,
    //                 left: widthOfContainer * 0.05,
    //                 child: SizedBox(
    //                     height: heightOfContainer * 0.12,
    //                     width: widthOfContainer * 0.9,
    //                     child: const TextField(
    //                       decoration: InputDecoration(
    //                           hintText: "Password",
    //                           border: OutlineInputBorder(
    //                               borderRadius:
    //                                   BorderRadius.all(Radius.circular(12)),
    //                               borderSide:
    //                                   BorderSide(color: Colors.black))),
    //                     ))),
    //             Positioned(
    //                 top: heightOfContainer * 0.45,
    //                 left: widthOfContainer * 0.05,
    //                 child: SizedBox(
    //                     height: heightOfContainer * 0.12,
    //                     width: widthOfContainer * 0.9,
    //                     child: const TextField(
    //                       decoration: InputDecoration(
    //                           hintText: "Repeat Password",
    //                           border: OutlineInputBorder(
    //                               borderRadius:
    //                                   BorderRadius.all(Radius.circular(12)),
    //                               borderSide:
    //                                   BorderSide(color: Colors.black))),
    //                     ))),
    //             Positioned(
    //                 top: heightOfContainer * 0.72,
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   height: heightOfContainer * 0.1,
    //                   width: widthOfContainer,
    //                   color: Colors.white.withOpacity(0.4),
    //                   child: const Text("Sign Up"),
    //                 )),
    //             Positioned(
    //               top: heightOfContainer * 0.88,
    //               child: GestureDetector(
    //                 onTap: () {
    //                   // _onCardHolderPressed();
    //                 },
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   height: heightOfContainer * 0.12,
    //                   width: widthOfContainer,
    //                   decoration: BoxDecoration(
    //                       color: Colors.black.withOpacity(0.4),
    //                       borderRadius: const BorderRadius.only(
    //                           bottomLeft: Radius.circular(24),
    //                           bottomRight: Radius.circular(24))),
    //                   child: const Text("Go for Login",
    //                       style: TextStyle(color: Colors.white)),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         )),
    //   ],
    // ));
  }

  // void _onCardHolderPressed() {
  //   setState(() {
  //     isFlipped = !isFlipped;
  //   });
  // }
}

// class CardHolder extends StatelessWidget {
//   final bool toggler;
//   final Widget frontCard;
//   final Widget backCard;

//   const CardHolder({
//     required this.toggler,
//     required this.backCard,
//     required this.frontCard,
//   });

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     child: AnimatedSwitcher(
  //       duration: const Duration(milliseconds: 800),
  //       transitionBuilder: _transitionBuilder,
  //       //with out curves
  //       // switchInCurve: Curves.bounceInOut,
  //       //switchInCurve: Curves.bounceIn,
  //       //switchOutCurve: Curves.bounceOut,
  //       child: toggler
  //           ? SizedBox(key: const ValueKey('front'), child: frontCard)
  //           : SizedBox(key: const ValueKey('back'), child: backCard),
  //     ),
  //   );
  // }

  // Widget _transitionBuilder(Widget widget, Animation<double> animation) {
  //   final rotateAnimation = Tween(begin: pi, end: 0.0).animate(animation);
  //   return AnimatedBuilder(
  //     animation: rotateAnimation,
  //     child: widget,
  //     builder: (context, widget) {
  //       final isFront = ValueKey(toggler) == widget!.key;
  //       final rotationY = isFront
  //           ? rotateAnimation.value
  //           : min(rotateAnimation.value, pi * 0.5);
  //       return Transform(
  //         transform: Matrix4.rotationY(rotationY)..setEntry(0, 2, 0),
  //         alignment: Alignment.center,
  //         child: widget,
  //       );
  //     },
  //   );
  // }
// }

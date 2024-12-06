import 'package:flutter/material.dart';
import 'package:xflix/views/homepage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3),(){
     Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0), end: Offset.zero)
              .animate(animation),
          child: const Homescreen(),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ),
    (route) => false,
  );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: Image.asset("assets/A.gif"),
      ),
    );
  }
}
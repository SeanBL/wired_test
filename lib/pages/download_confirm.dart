import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wired_test/pages/home_page.dart';
import 'package:wired_test/pages/policy.dart';

import '../utils/custom_app_bar.dart';
import '../utils/custom_nav_bar.dart';
import 'module_library.dart';

class DownloadConfirm extends StatefulWidget {
  //const DownloadConfirm({Key? key}) : super(key: key);
  const DownloadConfirm({super.key, required this.moduleName});
  final String moduleName;

  @override
  State<DownloadConfirm> createState() => _DownloadConfirmState();
}

class _DownloadConfirmState extends State<DownloadConfirm> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF0DC),
                  Color(0xFFF9EBD9),
                  Color(0xFFFFC888),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Imported from utils/custom_app_bar.dart
                    CustomAppBar(
                      onBackPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Text(
                      "You have downloaded the following module:",
                      style: TextStyle(
                        //fontSize: 36,
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF548235),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
                    ),
                    Container(
                      //height: 150,
                      height: screenHeight * 0.16,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          widget.moduleName,
                          style: TextStyle(
                            //fontSize: 36,
                            fontSize: screenWidth * 0.075,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0070C0),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Flexible(
                      child: Container(
                        height: screenHeight * 0.33,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "View module in",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.072,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("My Library");
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleLibrary()));
                                },
                                child: Container(
                                  //height: 60,
                                  height: screenHeight * 0.062,
                                  //width: 200,
                                  width: screenWidth * 0.453,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF519921), Color(0xFF93D221), Color(0xFF519921),], // Your gradient colors
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(1, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "My Library",
                                      style: TextStyle(
                                        //fontSize: 32,
                                        fontSize: screenWidth * 0.0715,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "or return",
                                style: TextStyle(
                                  // fontSize: 32,
                                  fontSize: screenWidth * 0.0715,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                                },
                                child: Container(
                                  //height: 60,
                                  height: screenHeight * 0.062,
                                  //width: 200,
                                  width: screenWidth * 0.453,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF0070C0), Color(0xFF00C1FF), Color(0xFF0070C0),], // Your gradient colors
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(1, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Home",
                                      style: TextStyle(
                                        // fontSize: 32,
                                        fontSize: screenWidth * 0.0715,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(
              onHomeTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
              },
              onLibraryTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleLibrary()));
              },
              onHelpTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Policy()));
              },
            ),
          ),
        ]
      ),
    );
  }
}

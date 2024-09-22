import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onHelpTap;

  const CustomBottomNavBar({
    Key? key,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onHelpTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.transparent,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: onHomeTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, size: 36, color: Colors.black),
                Text(
                    "Home",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.044,
                        fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: onLibraryTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.library_books, size: 36, color: Colors.black),
                Text(
                    "My Library",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.044,
                        fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: onHelpTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info, size: 36, color: Colors.black),
                Text(
                    "Help",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.044,
                        fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
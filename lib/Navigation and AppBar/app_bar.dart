import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Screens/profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({
    Key? key,
  })  : preferredSize = Size.fromHeight(80.0), // Set preferred height
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400], // Set background color to gray
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure minimum height
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/CrystallineFinalLogo.png',
                    fit: BoxFit.contain,
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      // IconButton(
                      //   icon:
                      //       Icon(CupertinoIcons.cart_fill, color: Colors.black),
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => CartScreen(),
                      //         ));
                      //   },
                      // ),
                      IconButton(
                        icon: Icon(CupertinoIcons.person_fill,
                            color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black, // Divider color
              thickness: 2.0, // Divider thickness
              height: 1.0, // Divider height
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBarWithoutPerson extends StatelessWidget
    implements PreferredSizeWidget {
  final List<Widget>? actions;

  @override
  final Size preferredSize;

  CustomAppBarWithoutPerson({
    Key? key,
    this.actions,
  })  : preferredSize = Size.fromHeight(80.0), // Set preferred height
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400], // Set background color to gray
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure minimum height
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/Crystallinelogo.jpg',
                    fit: BoxFit.contain,
                    height: 50.0,
                  ),
                  Row(
                    children: [
                      // IconButton(
                      //   icon:
                      //       Icon(CupertinoIcons.cart_fill, color: Colors.black),
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => CartScreen(),
                      //       ),
                      //     );
                      //   },
                      // ),
                      if (actions != null) ...actions!,
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black, // Divider color
              thickness: 2.0, // Divider thickness
              height: 1.0, // Divider height
            ),
          ],
        ),
      ),
    );
  }
}

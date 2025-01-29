import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myshop_app/Screens/supportus_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';

import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/app_bar.dart';
import 'package:myshop_app/Widgets/back_button.dart';
import 'package:myshop_app/Screens/Compare/compare_screen.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';
import 'package:myshop_app/Screens/Order/order_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BackButtonWidget(),

            Container(
              padding: EdgeInsets.all(16.0),
              child: Image.asset(
                "assets/CrystallineFinalLogo.png",
              ),
              height: 200,
              width: 200,
            ),
            Divider(thickness: 1),
            // Navigation Icons
            _buildMenuItem(
              context,
              icon: CupertinoIcons.home,
              text: 'Home',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeView()));
              },
            ),
            Divider(thickness: 1),
            _buildMenuItem(
              context,
              icon: CupertinoIcons.square_list,
              text: 'Orders',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderScreen()));
              },
            ),
            Divider(thickness: 1),
            _buildMenuItem(
              context,
              icon: Icons.compare_rounded,
              text: 'Compare',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompareScreen(
                              products: [],
                            )));
              },
            ),
            Divider(thickness: 1),
            _buildMenuItem(
              context,
              icon: CupertinoIcons.shopping_cart,
              text: 'Cart',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
            Divider(thickness: 1),

            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SupportUsMenu(),
                          ));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.support_agent_rounded),
                        Text(
                          'Support Us',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.purple.shade300,
              child: Column(
                children: [
                  //  Divider(thickness: 1),
                  Center(
                    child: Image.asset(
                      "assets/snmlogo.png",
                      height: 60,
                      width: 80,
                    ),
                  ),
                  // SizedBox(height: 10),
                  // GestureDetector(
                  //   onTap: () {
                  //     const url = "https://snmtechcraftinnovation.com";
                  //     _launchURL(url);
                  //   },
                  //   child: Text(
                  //     'Developed by\nhttps://snmtechcraftinnovation.com',
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontStyle: FontStyle.italic,
                  //       color: Colors.white,
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Commented-out sections removed for readability
}

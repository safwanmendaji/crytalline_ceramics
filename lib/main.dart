import 'package:flutter/material.dart';
import 'package:myshop_app/Helper/string_helper.dart';
import 'package:myshop_app/Screens/Cart/cart_provider.dart';
import 'package:myshop_app/Screens/SplashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyShopApp(),
    ),
  );
}

class MyShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringHelper.crystalline,
        theme: ThemeData(
          primaryColor: Colors.grey[350],
          //primarySwatch: Colors.brown,
          useMaterial3: true,
        ),
        //home: HomeView())
        // home: LoginPage());
        // home: Registration())
        home: SplashScreen());
  }
}

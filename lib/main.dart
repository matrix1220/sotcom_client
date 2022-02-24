import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';

//import 'package:sotcom/sotcom.dart';
//import 'package:sotcom/sharedpref.dart';

import 'package:sotcom/loadpage.dart';
import 'package:sotcom/homepage.dart';
import 'package:sotcom/loginpage.dart';
import 'package:sotcom/orderspage.dart';



void main() {
	runApp(
		MaterialApp(
			title: 'Sotuvchi',
			theme: ThemeData(
				primarySwatch: Colors.blue,
				visualDensity: VisualDensity.adaptivePlatformDensity,
			),
			initialRoute: '/',
			routes: {
				'/': (context) => LoadPage(),
				'/login': (context) => LoginPage(),
				'/home': (context) => HomePage(),
				'/orders': (context) => OrdersPage(),
			},
		)
	);
}
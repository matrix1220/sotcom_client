import 'package:flutter/material.dart';
import 'package:sotcom/sharedpref.dart';

class HomePage extends StatelessWidget {
	void _logout(BuildContext context) async {
		await SharedPref.remove("name");
		await SharedPref.remove("token");
		Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Sotuvchi"),
			),
			drawer: Drawer(
				child: ListView(
					children: <Widget>[
						ListTile(
							title: Text("Log out"),
							onTap: (){_logout(context);},
						),
						ListTile(
							title: Text("Forget filters"),
							onTap: () async {await SharedPref.remove("filters");},
						)
					]
				)
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						RaisedButton(
							child: Text("Orders"),
							onPressed: () {Navigator.of(context).pushNamed('/orders');}
						)
					],
				),
			),
		);
	}
}
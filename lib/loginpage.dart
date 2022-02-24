import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sotcom/sharedpref.dart';
import 'package:sotcom/sotcom.dart';

class LoginPage extends StatefulWidget {
	@override
	State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	final _token = TextEditingController();
	@override
	void dispose() {
		_token.dispose();
		super.dispose();
	}

	void _check(BuildContext context) async {
		var sotcom = SotCom(_token.text);
		try {
			var courier = await sotcom.me();
			await SharedPref.save("name", courier['name']);
			await SharedPref.save("token", _token.text);
			Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
		} catch(e) {
			Fluttertoast.showToast(msg: e.toString());
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Kirish"),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(12),
							child: TextField(
								controller: _token,
								decoration: InputDecoration(
									hintText: 'Token',
									contentPadding: EdgeInsets.all(8),
								),
							),
						),
						RaisedButton(
							child: Text("ok"),
							onPressed: () {_check(context);}
						)
					],
				),
			),
		);
	}
}
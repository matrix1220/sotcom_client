import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sotcom/sharedpref.dart';
import 'package:sotcom/sotcom.dart';

class LoadPage extends StatefulWidget {
	_LoadPageState createState() => _LoadPageState();
}
class _LoadPageState extends State<LoadPage> {
	void _load() async {
		if(await SharedPref.exists("token")) {
			var sotcom = SotCom(await SharedPref.read("token"));
			try {
				await sotcom.me();
				Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
				return;
			} catch(e) {
				Fluttertoast.showToast(msg: e.toString());
			}
		}
		Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
	}
	@override
	void initState() {
		super.initState();
		_load();
	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(
				child: CircularProgressIndicator()
			),
		);
	}
}
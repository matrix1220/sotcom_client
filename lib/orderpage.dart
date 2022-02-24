import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sotcom/sharedpref.dart';
import 'package:sotcom/sotcom.dart';

class OrderPage extends StatefulWidget {
	final data;
	OrderPage(this.data);

	@override
	State<OrderPage> createState() => _OrderPageState(this.data);
}

class _OrderPageState extends State<OrderPage> {
	final data;
	_OrderPageState(this.data);
	SotCom _sotcom;
	void _loadFilters() async {
		_sotcom = SotCom(await SharedPref.read("token"));
	}
	@override
	void initState() {
		super.initState();
		_loadFilters();
	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Order"),
			),
			body: Column(
				children: <Widget>[
					Card(
						color: Color.fromRGBO(240, 240, 240, 0.9),
						elevation: 2.0,
						child: Column(
							children: <Widget> [
								Text(data[0]['name'] + ", " + data[0]['phone']),
								Text(data[0]['quantity'] + " dona " + data[1]['short_name'] + ", " + data[0]['cost']),
								Text(data[0]['message']),
							]
						)
					),
					Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							RaisedButton(
								child: Icon(
									Icons.check
								),
								onPressed: () async {
									try {
										await _sotcom.orderStatus(data[0]['id'], 4);
									} catch(e) {
										Fluttertoast.showToast(msg: e.toString());
									}
									Navigator.pop(context, true);
								}
							),
							RaisedButton(
								child: Icon(
									Icons.remove
								),
								onPressed: () async {
									try {
										await _sotcom.orderStatus(data[0]['id'], 3);
									} catch(e) {
										Fluttertoast.showToast(msg: e.toString());
									}
									Navigator.pop(context, true);
								}
							)
						]
					)
				]
			),
		);
	}
}
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import 'package:sotcom/sharedpref.dart';
import 'package:sotcom/sotcom.dart';

import 'package:sotcom/OrderPage.dart';

import 'dart:collection';
class Selector extends ListBase<DropdownMenuItem<int>> {
	Map _data;
	List<DropdownMenuItem<int>> _inner;

	int get length => _inner.length;
	set length(int length) {
		_inner.length = length;
	}
	void operator[]=(int index, DropdownMenuItem<int> value) {
		_inner[index] = value;
	}
	DropdownMenuItem<int> operator [](int index) => _inner[index];

	Selector.fromData(this._data) {
		_inner = _data.entries.map<DropdownMenuItem<int>>(
			(item) => DropdownMenuItem<int>(value: int.parse(item.key), child: Text(item.value['name']))
		).toList();
	}
}


class OrderCard extends StatelessWidget {
	final item;
	OrderCard(this.item);
	_openOrder(BuildContext context, item) async {
		final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage(item)));
		if(result!=true) return;
		//_orders.remove(item);
		//_setOrderItems();
		//Fluttertoast.showToast(msg: result);
	}
	@override
	Widget build(BuildContext context) {
		return Card(
			color: Color.fromRGBO(240, 240, 240, 0.9),
			elevation: 2.0,
			child: InkWell(
				splashColor: Colors.pinkAccent,
				onTap: () {
					_openOrder(context, item);
				},
				child: Column(
					children: <Widget> [
						Text(item[0]['name'] + ", " + item[0]['phone']),
						Text(item[0]['quantity'] + " dona " + item[1]['short_name'] + ", " + item[0]['cost']),
						Text(item[0]['message']),
					]
				)
			)
		);
	}
}

class Orders extends StatelessWidget {
	final _orders;
	Orders(this._orders);
	@override
	Widget build(BuildContext context) {
		return ListView(
			padding: EdgeInsets.all(8.0),
			children: _orders.map<Widget>(
				(item) => OrderCard(item)
			).toList()
		);
	}
}

class RegionSelector extends StatelessWidget {
	final _orderPageState;
	RegionSelector(this._orderPageState);
	@override
	Widget build(BuildContext context) {
		return DropdownButton<int>(
			value: _orderPageState.regionId,
			hint: Text('Tuman'),
			items: Selector.fromData(_orderPageState.regions),
			onChanged: (int id) { _orderPageState.districtId = null; _orderPageState.regionId = id;},
		);
	}
}

class OrdersPage extends StatefulWidget {
	@override
	State<OrdersPage> createState() => _OrdersPageState();
}

class DistrictSelector extends StatelessWidget {
	final _orderPageState;
	DistrictSelector(this._orderPageState);
	@override
	Widget build(BuildContext context) {
		return DropdownButton<int>(
			value: _orderPageState.districtId,
			hint: Text('Tuman'),
			items: Selector.fromData(_orderPageState.districts),
			onChanged: (int id) => _orderPageState.districtId = id,
		);
	}
}

class _OrdersPageState extends State<OrdersPage> {
	SotCom _sotcom;
	var _filters;
	void _loadFilters() async {
		_sotcom = SotCom(await SharedPref.read("token"));
		var tmp;
		if(await SharedPref.exists("filters")) {
			tmp = await SharedPref.read("filters");
		} else {
			tmp = await _sotcom.filters();
			await SharedPref.save("filters", tmp);
		}
		print(_filters);
		setState(() => _filters = tmp);
	}
	@override
	void initState() {
		super.initState();
		_loadFilters();
	}

	int _regionId;
	int get regionId => _regionId;
	set regionId (int id) => setState(() => _regionId = id);
	get regions {
		if(_filters==null) return {};
		return _filters['regions'];
	}

	int _districtId;
	int get districtId => _districtId;
	set districtId (int id) => setState(() => _districtId = id);
	get districts {
		if(_filters==null) return {};
		if(regionId==null) return _filters['districts'];
		return _filters['regions'][regionId.toString()]['districts'];
	}
	void _refresh() async {
		var tmp = await _sotcom.orders({"region_id":regionId, "district_id":districtId});
		setState(() => _orders = tmp);
	}

	var _orders = [];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Sotuvchi"),
			),
			body: Column(
				children: <Widget>[
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceAround,
						children: <Widget>[
							RegionSelector(this),
							DistrictSelector(this),
							FlatButton(
								child: Icon(
									Icons.close
								),
								onPressed: () {
									regionId = null;
									districtId = null;
								}
							),
							OutlineButton(
								child: Icon(
									Icons.refresh
								),
								onPressed: _refresh,
							),
						]
					),
					Expanded(
						child: Orders(_orders)
					)
				]
			)
		);
	}
}


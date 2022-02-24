import 'package:http/http.dart' as http;
import 'dart:convert';

class SotCom {
	static const API_URL = 'http://168.119.118.220:8080/';
	//static const API_URL = 'http://192.168.1.164:8080/';
	final String token;
	SotCom(this.token);
	_send(String method, String submethod, data) async {
		var uri = Uri.parse(API_URL + submethod);
		var request = http.Request(method, uri) ;
		request.headers.addAll({'token':this.token});
		print(data);
		request.body = json.encode(data);

		//var response = await request.send();
		//return json.decode(response.stream.toString());
		var response = await http.Response.fromStream(await request.send());
		print(response.body);
		var body = json.decode(response.body);
		if(body['ok']) return body['result'];
		else throw Exception(body['err_str']);
	}
	me() async {
		return _send('GET', 'me', {});
	}
	filters() async {
		return _send('GET', 'Filters', {});
	}
	orderStatus(int orderId, int status, [String message]) async {
		return _send('POST', 'OrderStatus', {"order_id":orderId, "status":status, "message":message});
	}
	orders(Map<String, dynamic> data) async {
		return _send('GET', 'Orders', data);
	}
	// noSuchMethod(Invocation invocation) {
	//	 if (invocation.isGetter) {
	//		 var ret = _data[invocation.memberName.toString()];
	//		 if (ret != null) {
	//			 return ret;
	//		 } else {
	//			 super.noSuchMethod(invocation);
	//		 }
	//	 }
	//	 if (invocation.isSetter) {
	//		 _data[invocation.memberName.toString().replaceAll('=', '')] =
	//				 invocation.positionalArguments.first;
	//	 } else {
	//		 super.noSuchMethod(invocation);
	//	 }
	// }

}
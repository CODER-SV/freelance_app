import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderAPI {
  static String orderIDUrl = 'https://api.razorpay.com/v1/orders';
  static Future<Map<String, String>> getHeader() async {
    return {
      'Content-Type': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode(''))}',
    };
  }

  static Future<String> generateOrderID(int amount) async {
    final header = await getHeader();
    var response = await http.post(
      Uri.parse(orderIDUrl),
      headers: header,
      body: jsonEncode({'amount': amount, 'currency': 'INR'}),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['id']; // <-- This is your order_id
    } else {
      print('Failed to create order: ${response.body}');
      return '';
    }
  }
}

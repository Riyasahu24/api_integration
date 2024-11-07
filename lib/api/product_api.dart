import 'dart:convert';
import 'package:assignment/model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductApi {
  Future<ProductModel> getItemByShopId() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://lpwala.com/admin/api/getItembyShopId'))
      ..fields['shop_id'] = 'ST3f14';

    var response = await request.send();

    if (response.statusCode == 200) {
      // Capture the response body as a string
      var responseBody = await response.stream.bytesToString();

      try {
        Map<String, dynamic> jsonData = jsonDecode(responseBody);
        ProductModel data = ProductModel.fromJson(jsonData);
        return data;
      } catch (e) {
        print('Error parsing JSON: $e');
        throw Exception('Failed to parse the JSON response');
      }
    } else {
      throw Exception('Failed to load items');
    }
  }
}

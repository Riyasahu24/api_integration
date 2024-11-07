import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment/model/product_model.dart';

class PreferencesHelper {
  static const String servicesKey = 'selectedServices';

  static Future<void> saveSelectedService(
      Services service, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> services = prefs.getString(servicesKey) != null
        ? json.decode(prefs.getString(servicesKey)!)
        : {};

    double discount = (double.tryParse(service.price) ?? 0.0) /
        (double.tryParse(service.discount[0].percentage) ?? 0.0);
    double discountedPrice = (double.tryParse(service.price) ?? 0.0) - discount;

    services[service.itemId] = {
      'quantity': quantity,
      'price': service.price,
      'itemName': service.itemName,
      'discount': discountedPrice,
    };

    await prefs.setString(servicesKey, json.encode(services));
  }

  static Future<Map<String, dynamic>> getSelectedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? servicesString = prefs.getString(servicesKey);

    if (servicesString != null) {
      return Map<String, dynamic>.from(json.decode(servicesString));
    }
    return {};
  }

  static Future<int> getServiceQuantity(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> services = await getSelectedServices();
    if (services.containsKey(itemId)) {
      return services[itemId]['quantity'] ?? 0;
    }
    return 0;
  }

  static Future<void> removeServiceQuantity(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> services = await getSelectedServices();
    services.remove(itemId);
    await prefs.setString(servicesKey, json.encode(services));
  }
}

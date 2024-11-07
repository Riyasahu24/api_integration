import 'package:assignment/helper/db_helper.dart';
import 'package:flutter/material.dart';

class CartBody extends StatefulWidget {
  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  Map<String, dynamic> savedServices = {};
  double totalPrice = 0.0;
  double totalDiscount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavedServices();
  }

  void _calculateTotalPriceAndDiscount() {
    double price = 0.0;
    double discount = 0.0;

    savedServices.forEach((key, value) {
      int quantity = value['quantity'] ?? 0;
      double servicePrice = double.tryParse(value['price'].toString()) ?? 0.0;
      double serviceDiscount = value['discount'] ?? 0.0;

      price += servicePrice * quantity;
      discount += serviceDiscount * quantity;
    });

    setState(() {
      totalPrice = price;
      totalDiscount = totalPrice - discount;
    });
  }

  Future<void> _loadSavedServices() async {
    final services = await PreferencesHelper.getSelectedServices();
    print(services);
    setState(() {
      savedServices = services;
    });
    _calculateTotalPriceAndDiscount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  savedServices.isEmpty
                      ? Center(
                          child: Text('No saved services'),
                        )
                      : ListView.builder(
                          itemCount: savedServices.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            String serviceId =
                                savedServices.keys.elementAt(index);
                            var serviceDetails = savedServices[serviceId];

                            int quantity = serviceDetails['quantity'] ?? 0;
                            double price = double.tryParse(
                                    serviceDetails['price'].toString()) ??
                                0.0;

                            String itemName = serviceDetails['itemName'] ??
                                'Service $serviceId';

                            double discount = serviceDetails['discount'] ?? 1;

                            return CartItem(
                              isUrgent: true,
                              quantity: quantity,
                              price: price,
                              discountedPrice: discount,
                              itemName: itemName,
                            );
                          },
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:
                        Text("Add More", style: TextStyle(color: Colors.blue)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text("Terms and Condition",
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  )),
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: OfferSection()),
                  PriceSummary(
                    discount: totalDiscount,
                    subTotal: totalPrice,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final bool isUrgent;
  final int quantity;
  final double price;
  final double discountedPrice;
  final String itemName;

  CartItem({
    required this.isUrgent,
    required this.quantity,
    required this.price,
    required this.discountedPrice,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isUrgent
              ? Container(
                  margin: EdgeInsets.all(4),
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 2)),
                )
              : SizedBox(),
          // Checkbox(

          //   value: isUrgent, onChanged: (value) {}),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isUrgent ? " Urgent" : "",
                    ),
                    Text(" $quantity x $price ",
                        style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        itemName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Text(itemName, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "${(price * quantity).toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text('₹${(discountedPrice * quantity).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class OfferSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("All Offers & Coupons",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 16)),
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      ],
    );
  }
}

class PriceSummary extends StatelessWidget {
  final double subTotal;
  final double discount;
  const PriceSummary({required this.discount, required this.subTotal});
  @override
  Widget build(BuildContext context) {
    final finalAmt = subTotal - discount;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sub Total"),
              Text("₹$subTotal"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discount"),
              Text("₹${discount.toStringAsFixed(2)}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Offer"),
              Text("0"),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Final Amount",
                  style: TextStyle(fontSize: 16, color: Colors.blue)),
              Text(finalAmt.toStringAsFixed(2), style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

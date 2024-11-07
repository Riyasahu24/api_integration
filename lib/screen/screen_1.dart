import 'package:assignment/api/product_api.dart';
import 'package:assignment/helper/db_helper.dart';
import 'package:assignment/model/product_model.dart';
import 'package:assignment/screen/screen_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final ValueNotifier<double> totalAmount = ValueNotifier<double>(0);
  final ValueNotifier<int> totalItems = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _loadTotalValues();
  }

  Future<void> _loadTotalValues() async {
    final prefs = await SharedPreferences.getInstance();
    totalAmount.value = prefs.getDouble('totalAmount') ?? 0;
    totalItems.value = prefs.getInt('totalItems') ?? 0;
  }

  Future<void> updateTotal(double priceChange, int itemChange) async {
    totalAmount.value += priceChange;
    totalItems.value += itemChange;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalAmount', totalAmount.value);
    await prefs.setInt('totalItems', totalItems.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        height: 60,
        child: Container(
          color: Colors.blue,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder<double>(
                valueListenable: totalAmount,
                builder: (context, value, child) {
                  return Text('Total ${value.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white, fontSize: 16));
                },
              ),
              VerticalDivider(
                color: Colors.white,
              ),
              ValueListenableBuilder<int>(
                valueListenable: totalItems,
                builder: (context, value, child) {
                  return Text('$value Items Added',
                      style: TextStyle(color: Colors.white, fontSize: 16));
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => CartBody(),
                    ),
                  );
                },
                child: Text('Next >',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: ProductApi().getItemByShopId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.data.itemList[0].services.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.data.itemList[0].services[index];
                return ItemCard(
                  data: data,
                  currency: snapshot.data!.data.currencyCode,
                  updateTotal: updateTotal,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final Services data;
  final String currency;
  final Function(double, int) updateTotal;

  const ItemCard({
    Key? key,
    required this.data,
    required this.currency,
    required this.updateTotal,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isExpanded = false;
  int quantity = 0;
  Map<String, bool> extraServiceSelections = {};

  @override
  void initState() {
    super.initState();

    for (var service in widget.data.extraServices) {
      extraServiceSelections[service.addonServiceId] = false;
    }

    PreferencesHelper.getServiceQuantity(widget.data.itemId)
        .then((savedQuantity) {
      setState(() {
        quantity = savedQuantity;
      });
    });
  }

  Future<void> _incrementQuantity() async {
    setState(() {
      quantity++;
      widget.updateTotal(double.parse(widget.data.price), 1);
    });

    await PreferencesHelper.saveSelectedService(widget.data, quantity);
  }

  Future<void> _decrementQuantity() async {
    if (quantity > 0) {
      setState(() {
        quantity--;
        widget.updateTotal(-double.parse(widget.data.price), -1);
      });

      if (quantity == 0) {
        await PreferencesHelper.removeServiceQuantity(widget.data.itemId);
      } else {
        await PreferencesHelper.saveSelectedService(widget.data, quantity);
      }
    }
  }

  // Handle extra services
  void _toggleExtraService(String serviceId, double price, bool isSelected) {
    setState(() {
      extraServiceSelections[serviceId] = isSelected;
      final priceChange = isSelected ? price : -price;
      widget.updateTotal(priceChange, isSelected ? 1 : -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(8),
            // horizontalTitleGap: 4,
            leading: Image.network(
              widget.data.image,
              width: 60,
              height: 50,
            ),
            title: Text(
              widget.data.itemName,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₹${widget.data.price}',
                  style: TextStyle(fontSize: 14),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), backgroundColor: Colors.blue),
                    onPressed: _decrementQuantity,
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    )),
                Text(
                  '$quantity',
                  style: TextStyle(fontSize: 14),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), backgroundColor: Colors.blue),
                    onPressed: _incrementQuantity,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
              ],
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Column(
              children: widget.data.extraServices.map((service) {
                final servicePrice = double.parse(service.addonServicePrice);
                return CheckboxListTile(
                  activeColor: Colors.black87,
                  title: Text(
                      '${service.addonServiceId} (₹${service.addonServicePrice})'),
                  value: extraServiceSelections[service.addonServiceId],
                  onChanged: (bool? value) {
                    if (value != null) {
                      _toggleExtraService(
                          service.addonServiceId, servicePrice, value);
                    }
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

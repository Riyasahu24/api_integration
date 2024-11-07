class ProductModel {
  final int status;
  final String message;
  final Data data;

  ProductModel({
    required this.status,
    required this.message,
    required this.data,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] ?? 0,
        message = json['message'] ?? '',
        data = Data.fromJson(json['data'] ?? {});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  final String currencyCode;
  final List<ItemList> itemList;

  Data({
    required this.currencyCode,
    required this.itemList,
  });

  Data.fromJson(Map<String, dynamic> json)
      : currencyCode = json['currency_code'] ?? '',
        itemList = (json['item_list'] as List? ?? [])
            .map((v) => ItemList.fromJson(v))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency_code'] = currencyCode;
    data['item_list'] = itemList.map((v) => v.toJson()).toList();
    return data;
  }
}

class ItemList {
  final String serviceId;
  final String serviceName;
  final List<Services> services;

  ItemList({
    required this.serviceId,
    required this.serviceName,
    required this.services,
  });

  ItemList.fromJson(Map<String, dynamic> json)
      : serviceId = json['service_id'] ?? '',
        serviceName = json['service_name'] ?? '',
        services = (json['services'] as List? ?? [])
            .map((v) => Services.fromJson(v))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['services'] = services.map((v) => v.toJson()).toList();
    return data;
  }
}

class Services {
  final String sNo;
  final String itemId;
  final String shopId;
  final String serviceId;
  final String itemName;
  final String price;
  final String image;
  final String serviceName;
  final String serviceCategory;
  final String serviceSubcategory;
  final String subcategoryImage;
  final List<ExtraServices> extraServices;
  final List<String> pickupDelivery;
  final List<Discount> discount;

  Services({
    required this.sNo,
    required this.itemId,
    required this.shopId,
    required this.serviceId,
    required this.itemName,
    required this.price,
    required this.image,
    required this.serviceName,
    required this.serviceCategory,
    required this.serviceSubcategory,
    required this.subcategoryImage,
    required this.extraServices,
    required this.pickupDelivery,
    required this.discount,
  });

  Services.fromJson(Map<String, dynamic> json)
      : sNo = json['s_no'] ?? '0',
        itemId = json['item_id'] ?? '0',
        shopId = json['shop_id'] ?? '0',
        serviceId = json['service_id'] ?? '0',
        itemName = json['item_name'] ?? '',
        price = json['price'] ?? '0',
        image = json['image'] ?? '',
        serviceName = json['service_name'] ?? '',
        serviceCategory = json['service_category'] ?? '',
        serviceSubcategory = json['service_subcategory'] ?? '',
        subcategoryImage = json['subcategory_image'] ?? '',
        extraServices = (json['extra_services'] as List? ?? [])
            .map((v) => ExtraServices.fromJson(v))
            .toList(),
        pickupDelivery = List<String>.from(json['pickup_delivery'] ?? []),
        discount = (json['discount'] as List? ?? [])
            .map((v) => Discount.fromJson(v))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['s_no'] = sNo;
    data['item_id'] = itemId;
    data['shop_id'] = shopId;
    data['service_id'] = serviceId;
    data['item_name'] = itemName;
    data['price'] = price;
    data['image'] = image;
    data['service_name'] = serviceName;
    data['service_category'] = serviceCategory;
    data['service_subcategory'] = serviceSubcategory;
    data['subcategory_image'] = subcategoryImage;
    data['extra_services'] = extraServices.map((v) => v.toJson()).toList();
    data['pickup_delivery'] = pickupDelivery;
    data['discount'] = discount.map((v) => v.toJson()).toList();
    return data;
  }
}

class ExtraServices {
  final String asId;
  final String serviceId;
  final String itemId;
  final String addonServiceId;
  final String addonServicePrice;
  final String createdDate;

  ExtraServices({
    required this.asId,
    required this.serviceId,
    required this.itemId,
    required this.addonServiceId,
    required this.addonServicePrice,
    required this.createdDate,
  });

  ExtraServices.fromJson(Map<String, dynamic> json)
      : asId = json['as_id'] ?? '0',
        serviceId = json['service_id'] ?? '0',
        itemId = json['item_id'] ?? '0',
        addonServiceId = json['addon_service_id'] ?? '0',
        addonServicePrice = json['addon_service_price'] ?? '0',
        createdDate = json['created_date'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['as_id'] = asId;
    data['service_id'] = serviceId;
    data['item_id'] = itemId;
    data['addon_service_id'] = addonServiceId;
    data['addon_service_price'] = addonServicePrice;
    data['created_date'] = createdDate;
    return data;
  }
}

class Discount {
  final String discountId;
  final String shopId;
  final String serviceId;
  final String priceRangeFrom;
  final String priceRangeTo;
  final String minQty;
  final String percentage;
  final String status;
  final String postDate;

  Discount({
    required this.discountId,
    required this.shopId,
    required this.serviceId,
    required this.priceRangeFrom,
    required this.priceRangeTo,
    required this.minQty,
    required this.percentage,
    required this.status,
    required this.postDate,
  });

  Discount.fromJson(Map<String, dynamic> json)
      : discountId = json['discount_id'],
        shopId = json['shop_id'],
        serviceId = json['service_id'],
        priceRangeFrom = json['price_range_from'],
        priceRangeTo = json['price_range_to'],
        minQty = json['min_qty'],
        percentage = json['percentage'],
        status = json['status'],
        postDate = json['post_date'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discount_id'] = discountId;
    data['shop_id'] = shopId;
    data['service_id'] = serviceId;
    data['price_range_from'] = priceRangeFrom;
    data['price_range_to'] = priceRangeTo;
    data['min_qty'] = minQty;
    data['percentage'] = percentage;
    data['status'] = status;
    data['post_date'] = postDate;
    return data;
  }
}

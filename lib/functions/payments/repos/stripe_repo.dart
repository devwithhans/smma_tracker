import 'dart:async';
import 'dart:convert';

import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:js' as js;

class StripeRepo {
  AuthCubit authCubit;
  StripeRepo(this.authCubit);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Product> getProduct() async {
    Map response = await stripeApi(
      'https://api.stripe.com/v1/products/prod_M88SchKfAQKngE',
    );

    Product product = Product(
      defaultPriceId: response['default_price'],
      description: response['description'] ?? '',
    );

    Map priceResponse = await stripeApi(
        'https://api.stripe.com/v1/prices/${product.defaultPriceId}');
    product = product.copyWith(
      price: priceResponse['unit_amount'] / 100,
      currency: priceResponse['currency'],
    );

    return product;
  }

  Future<void> startCheckoutSession(int quantity, String priceId) async {
    String userId = authCubit.state.appUser!.id;
    String copmanyId = authCubit.state.company!.id;
    try {
      DocumentReference<Map<String, dynamic>> resp = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .collection('checkout_sessions')
          .add({
        'price': priceId,
        'metadata': {
          'companyId': copmanyId,
        },
        'allow_promotion_codes': true,
        'tax_id_collection': true,
        'quantity': quantity,
        'success_url': "http://localhost:58212/",
        'cancel_url': "https://example.com/cancel",
      });
      DocumentSnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .collection('checkout_sessions')
          .doc(resp.id)
          .snapshots()
          .firstWhere(
              (event) => event.data() != null && event.data()!['url'] != null)
          .timeout(const Duration(seconds: 60));
      js.context.callMethod('open', [result.data()!['url']]);
      return;
    } on FirebaseFunctionsException catch (e) {
      rethrow;
      print(e);
    }
  }
}

Future<Map> stripeApi(url) async {
  String token =
      'rk_test_51IpZAiHKwYexcFxMvBtENAS71iXs7yYQvCik8h8iNJFN1fti0oWTfWNobSRMKvkgPDu7f8F5uyz8JZioz4V6XBLr006A8T2E3z';
  final response = await http.get(Uri.parse(url), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  Map rawMap = JsonDecoder().convert(response.body);
  return rawMap;
}

class Product {
  double price;
  String defaultPriceId;
  String description;
  String currency;

  Product copyWith({
    double? price,
    String? defaultPriceId,
    String? description,
    String? currency,
  }) {
    return Product(
      defaultPriceId: defaultPriceId ?? this.defaultPriceId,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }

  Product({
    this.price = 0,
    required this.defaultPriceId,
    this.description = '',
    this.currency = 'USD',
  });
}

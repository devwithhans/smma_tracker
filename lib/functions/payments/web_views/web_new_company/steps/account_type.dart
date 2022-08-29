import 'package:agency_time/functions/payments/web_views/checkout_widget.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({
    Key? key,
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool forMySelfe = false;

  @override
  Widget build(BuildContext context) {
    return StripeCheckout();
  }
}

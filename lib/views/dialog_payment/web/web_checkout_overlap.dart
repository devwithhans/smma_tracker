import 'dart:ui';
import '../paymeny_view_dependencies.dart';

class WebCheckoutOverlap extends StatelessWidget {
  const WebCheckoutOverlap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            decoration: shadowRoundedWhiteBox,
            constraints: const BoxConstraints(maxHeight: 500, maxWidth: 1000),
            padding: const EdgeInsets.all(20),
            child: const StripeCheckout(),
          ),
        ),
      ),
    );
  }
}

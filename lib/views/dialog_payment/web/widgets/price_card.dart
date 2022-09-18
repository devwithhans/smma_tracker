import 'package:agency_time/logic/payments/repos/stripe_repo.dart';

import '../../paymeny_view_dependencies.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({
    required this.product,
    required this.seats,
    Key? key,
  }) : super(key: key);

  final Product product;
  final int seats;

  @override
  Widget build(BuildContext context) {
    final moneyFormatter = CustomCurrencyFormatter.getFormatter(
        countryCode: product.currency.toUpperCase());
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        color: kColorGrey.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pr. seat', style: AppTextStyle.boldMedium),
              Row(
                children: [
                  Text(moneyFormatter.format(product.price / 12),
                      style: AppTextStyle.boldMedium),
                  const Text(
                    ' / month',
                    style: TextStyle(
                      height: 1,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          smallY,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTextStyle.boldLarge),
              Row(
                children: [
                  Text(moneyFormatter.format((product.price * seats) / 12),
                      style: AppTextStyle.boldLarge),
                  const Text(
                    ' / month',
                    style: TextStyle(
                      height: 2,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          smallY,
          Text('Billed ${moneyFormatter.format(product.price * seats)} yearly')
        ],
      ),
    );
  }
}

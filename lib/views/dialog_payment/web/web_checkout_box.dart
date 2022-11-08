import 'package:agency_time/logic/payments/payment_bloc/payment_bloc.dart';
import 'package:agency_time/logic/payments/repos/stripe_repo.dart';

import '../../../utils/widgets/buttons/main_button.dart';
import '../paymeny_view_dependencies.dart';

class StripeCheckout extends StatefulWidget {
  const StripeCheckout({
    Key? key,
  }) : super(key: key);

  @override
  State<StripeCheckout> createState() => _StripeCheckoutState();
}

class _StripeCheckoutState extends State<StripeCheckout> {
  bool forMySelfe = false;
  int seats = 1;

  @override
  Widget build(BuildContext context) {
    StripeRepo stripeRepo = StripeRepo(context.read<AuthorizationCubit>());
    return BlocProvider(
      create: (context) => PaymentCubit(stripeRepo),
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          bool loadingCheckoutPage =
              state.paymentStatus == PaymentStatus.loading;
          if (state.product == null) {
            return const LoadingScreen();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Start using our tool',
                style: AppTextStyle.boldLarge,
              ),
              Text(
                'More features does not cost us anymore, neither should it for you!',
                style: AppTextStyle.medium,
              ),
              xtraLargeY,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'How many seats do you need?',
                            style: AppTextStyle.boldSmall,
                          ),
                          mediumY,
                          QuantitySelect(
                            onChange: (v) {
                              seats = v;
                              setState(() {});
                            },
                            initial: seats,
                          )
                        ],
                      ),
                      largeY
                    ],
                  ),
                  PriceCard(
                    product: state.product!,
                    seats: seats,
                  ),
                ],
              ),
              xtraLargeY,
              CustomElevatedButton(
                loading: loadingCheckoutPage,
                text: 'Go to checkout',
                onPressed: () {
                  context.read<PaymentCubit>().startCheckout(seats);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

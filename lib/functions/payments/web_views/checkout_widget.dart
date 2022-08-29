import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/payments/blocs/payment_bloc/payment_bloc.dart';
import 'package:agency_time/functions/payments/models/new_company_cubit/new_company_cubit.dart';
import 'package:agency_time/functions/payments/repos/stripe_repo.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

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
    StripeRepo stripeRepo = StripeRepo(context.read<AuthCubit>());
    return BlocProvider(
      create: (context) => PaymentCubit(stripeRepo),
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          if (state.product == null) {
            return LoadingScreen();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Checkout',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
              Text(
                'More features does not cost us anymore, neither should it for you!',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 40),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'How many seats do you nees?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            QuantitySelect(
                              onChange: (v) {
                                seats = v;
                                setState(() {});
                              },
                              initial: seats,
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    PriceCard(
                      product: state.product!,
                      seats: seats,
                    ),
                    SizedBox(height: 40),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 40),
              CustomElevatedButton(
                  text: 'Checkout',
                  onPressed: () {
                    stripeRepo.startCheckoutSession(
                        seats, state.product!.defaultPriceId);
                  })
            ],
          );
        },
      ),
    );
  }
}

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
    Company company = BlocProvider.of<AuthCubit>(context).state.company!;

    final moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: company.countryCode);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
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
              Text(
                'Pr. seat',
                style: TextStyle(
                  height: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    moneyFormatter.format(product.price / 12),
                    style: TextStyle(
                      height: 1,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  height: 1,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    moneyFormatter.format((product.price * seats) / 12),
                    style: TextStyle(
                      height: 1,
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
          SizedBox(height: 10),
          Text('Billed ${moneyFormatter.format(product.price * seats)} yearly')
        ],
      ),
    );
  }
}

class QuantitySelect extends StatefulWidget {
  const QuantitySelect({
    this.initial = 1,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  final int initial;
  final Function(int value) onChange;

  @override
  State<QuantitySelect> createState() => _QuantitySelectState();
}

class _QuantitySelectState extends State<QuantitySelect> {
  late int value;
  @override
  void initState() {
    // TODO: implement initState
    value = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          splashRadius: 20,
          onPressed: () {
            if (value > 1) {
              value--;
              widget.onChange(value);

              setState(() {});
            }
          },
          icon: Text(
            '-',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: CustomInputForm(
            controller: TextEditingController(text: value.toString()),
            onChanged: (v) {
              value = int.parse(v);
              widget.onChange(value);
            },
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            value++;
            widget.onChange(value);

            setState(() {});
          },
          icon: Text(
            '+',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}

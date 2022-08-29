import 'package:agency_time/functions/payments/repos/stripe_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  StripeRepo stripeRepo;

  PaymentCubit(this.stripeRepo) : super(PaymentState()) {
    _getProduct();
  }

  Future<void> _getProduct() async {
    Product product = await stripeRepo.getProduct();

    emit(state.copyWith(product: product));
  }

  Future<void> startCheckout() async {}
}

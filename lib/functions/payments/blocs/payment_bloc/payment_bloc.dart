import 'package:agency_time/functions/payments/repos/stripe_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
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

  Future<void> startCheckout(int seats) async {
    emit(state.copyWith(paymentStatus: PaymentStatus.loading));
    try {
      await stripeRepo.startCheckoutSession(
          seats, state.product!.defaultPriceId);
      emit(state.copyWith(paymentStatus: PaymentStatus.initial));
    } on FirebaseFunctionsException catch (e) {
      emit(state.copyWith(paymentStatus: PaymentStatus.failed));
    }
  }
}

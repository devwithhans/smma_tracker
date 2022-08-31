part of 'payment_bloc.dart';

enum PaymentStatus { initial, loading, failed }

class PaymentState extends Equatable {
  final Product? product;
  final PaymentStatus paymentStatus;

  const PaymentState(
      {this.product, this.paymentStatus = PaymentStatus.initial});

  PaymentState copyWith({
    Product? product,
    PaymentStatus? paymentStatus,
  }) {
    return PaymentState(
      product: product ?? this.product,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  @override
  List get props => [product, paymentStatus];
}

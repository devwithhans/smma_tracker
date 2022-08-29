part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final Product? product;

  const PaymentState({this.product});

  PaymentState copyWith({
    Product? product,
  }) {
    return PaymentState(
      product: product ?? this.product,
    );
  }

  @override
  List get props => [product];
}

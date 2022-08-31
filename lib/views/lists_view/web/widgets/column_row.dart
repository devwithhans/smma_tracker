import 'package:agency_time/views/payment_view/paymeny_view_dependencies.dart';

class ColumnRow extends StatelessWidget {
  const ColumnRow({
    required this.items,
    Key? key,
  }) : super(key: key);

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items
              .map(
                (e) => Expanded(child: e),
              )
              .toList()),
    );
  }
}

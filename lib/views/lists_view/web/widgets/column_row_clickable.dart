import 'package:agency_time/views/lists_view/web/widgets/column_row.dart';
import 'package:agency_time/views/payment_view/paymeny_view_dependencies.dart';

class ColumnRowClickable extends StatelessWidget {
  const ColumnRowClickable({
    required this.onPressed,
    required this.items,
    Key? key,
  }) : super(key: key);
  final void Function()? onPressed;
  final List<Widget> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          onPressed: onPressed,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: ColumnRow(items: items),
        ),
        const Divider(height: 0),
      ],
    );
  }
}

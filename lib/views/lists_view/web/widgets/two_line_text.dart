import 'package:agency_time/views/payment_view/paymeny_view_dependencies.dart';

class TwoLineText extends StatelessWidget {
  const TwoLineText({
    required this.subTitle,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  final dynamic subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        subTitle is Widget
            ? subTitle
            : subTitle is String
                ? Text(
                    subTitle,
                    style: const TextStyle(fontSize: 10),
                  )
                : const SizedBox(),
      ],
    );
  }
}

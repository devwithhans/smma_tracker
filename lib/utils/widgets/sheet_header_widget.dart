import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                padding: EdgeInsets.zero,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: AppTextStyle.boldMedium,
                  ),
                ),
              ),
              const SizedBox(),
            ],
          ),
        ),
        const Divider(
          height: 0,
        ),
      ],
    );
  }
}

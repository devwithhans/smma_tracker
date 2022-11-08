import 'package:agency_time/features/auth/models/error.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({
    this.error,
    Key? key,
  }) : super(key: key);

  final HcError? error;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          error!.frontendMessage,
          textAlign: TextAlign.center,
          style: AppTextStyle.smallRed,
        ),
      );
    }
    return SizedBox();
  }
}

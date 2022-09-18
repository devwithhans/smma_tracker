import 'package:agency_time/views/dialog_payment/paymeny_view_dependencies.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key? key,
    required this.isTracking,
    required this.onPressed,
  }) : super(key: key);

  final bool isTracking;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: isTracking ? kColorBlack : kColorGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      padding: EdgeInsets.all(10),
      child: Icon(
        isTracking ? Icons.stop_rounded : Icons.play_arrow_rounded,
        color: Colors.white,
      ),
    );
  }
}

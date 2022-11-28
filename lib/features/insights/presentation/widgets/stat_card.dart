import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

class StatBox extends StatelessWidget {
  const StatBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 5,
            offset: Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

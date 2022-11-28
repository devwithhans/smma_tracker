import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

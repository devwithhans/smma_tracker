import 'package:agency_time/features/client/models/client.dart';
import 'package:agency_time/features/client/presentation/client_details/client_insights.dart';
import 'package:agency_time/features/client/presentation/widgets/custom_web_tab.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ClientDetails extends StatelessWidget {
  const ClientDetails({required this.client, super.key});

  final Client client;

  @override
  Widget build(BuildContext context) {
    return CustomWebTab(
      backButton: true,
      tabs: [
        TabScreen(screen: ClientInsights(client: client), title: 'Insights'),
        TabScreen(screen: Center(child: Text('Trackings')), title: 'Trackings'),
        TabScreen(screen: Center(child: Text('Services')), title: 'Services'),
        TabScreen(screen: Center(child: Text('Edit')), title: 'Edit'),
      ],
      title: client.name,
    );
  }
}

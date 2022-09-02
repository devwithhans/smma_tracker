// import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
// import 'package:agency_time/functions/authentication/models/company.dart';
// import 'package:agency_time/functions/authentication/models/user.dart';
// import 'package:agency_time/functions/clients/views/client_view/edit_client_view.dart';
// import 'package:agency_time/functions/clients/views/client_view/widgets/client_stats.dart';
// import 'package:agency_time/functions/clients/views/client_view/widgets/custom_app_bar.dart';
// import 'package:agency_time/functions/clients/views/client_view/widgets/tracking_card.dart';
// import 'package:agency_time/functions/tracking/blocs/trackings_cubit/trackings_cubit.dart';
// import 'package:agency_time/functions/tracking/blocs/update_trackig_cubit/update_tracking_cubit.dart';
// import 'package:agency_time/functions/tracking/models/tracking.dart';
// import 'package:agency_time/functions/clients/repos/client_repo.dart';
// import 'package:agency_time/functions/clients/models/client.dart';
// import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ClientView extends StatelessWidget {
//   const ClientView({required this.client, Key? key}) : super(key: key);

//   static String id = 'clientView';
//   final Client client;

//   @override
//   Widget build(BuildContext context) {
//     AppUser user = BlocProvider.of<AuthCubit>(context).state.appUser!;
//     Company company = BlocProvider.of<AuthCubit>(context).state.company!;

//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 CustomAppBar(
//                     title: client.name,
//                     icon: IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => EditClientView(
//                                       client: client,
//                                     )));
//                       },
//                     )),
//                 Expanded(
//                   child: ListView(
//                     padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//                     children: [
//                       const SizedBox(height: 20),
//                       ClientStats(client: client),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Latest trackings:',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600, fontSize: 20),
//                       ),
//                       const SizedBox(height: 10),
//                       BlocProvider(
//                         create: (context) =>
//                             TrackingsCubit(context.read<ClientsRepo>())
//                               ..fetchTrackings(client.id),
//                         child: BlocBuilder<TrackingsCubit, TrackingsState>(
//                           builder: (context, state) {
//                             List<Tracking> trackings = state.trackings ?? [];
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: trackings
//                                   .map((e) => BlocProvider(
//                                         create: (context) =>
//                                             UpdateTrackingCubit(
//                                                 context.read<TrackerRepo>()),
//                                         child: trackingCard(
//                                           tracking: e,
//                                           client: client,
//                                         ),
//                                       ))
//                                   .toList(),
//                             );
//                           },
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

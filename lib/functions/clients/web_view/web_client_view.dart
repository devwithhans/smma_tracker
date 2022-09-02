// import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
// import 'package:agency_time/functions/authentication/models/company.dart';
// import 'package:agency_time/functions/authentication/models/user.dart';
// import 'package:agency_time/functions/clients/views/client_view/edit_client_view.dart';
// import 'package:agency_time/functions/clients/views/client_view/widgets/client_stats.dart';
// import 'package:agency_time/functions/clients/views/client_view/widgets/custom_app_bar.dart';
// import 'package:agency_time/functions/clients/views/client_view/widgets/tracking_card.dart';
// import 'package:agency_time/functions/tracking/blocs/trackings_cubit/trackings_cubit.dart';
// import 'package:agency_time/functions/tracking/blocs/update_trackig_cubit/update_tracking_cubit.dart';
// import 'package:agency_time/functions/tracking/models/tag.dart';
// import 'package:agency_time/functions/tracking/models/tracking.dart';
// import 'package:agency_time/functions/clients/repos/client_repo.dart';
// import 'package:agency_time/functions/clients/models/client.dart';
// import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
// import 'package:agency_time/utils/functions/print_duration.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:side_sheet/side_sheet.dart';
// import 'package:agency_time/functions/tracking/views/finish_tracking/finish_tracking_view.dart';

// class WebClientView extends StatelessWidget {
//   const WebClientView({required this.client, Key? key}) : super(key: key);

//   static String id = 'clientView';
//   final Client client;

//   @override
//   Widget build(BuildContext context) {
//     AppUser user = BlocProvider.of<AuthCubit>(context).state.appUser!;
//     Company company = BlocProvider.of<AuthCubit>(context).state.company!;

//     return Scaffold(
//         body: SafeArea(
//             bottom: false,
//             child: Stack(children: [
//               Column(children: [
//                 CustomAppBar(
//                     title: client.name,
//                     icon: IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         SideSheet.right(
//                             width: 500,
//                             body: EditClientView(
//                               client: client,
//                             ),
//                             context: context);
//                       },
//                     )),
//                 Expanded(
//                   child: ListView(
//                     padding: EdgeInsets.only(
//                       top: 20,
//                     ),
//                     children: [
//                       const SizedBox(height: 20),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: ClientStats(client: client),
//                       ),
//                       const SizedBox(height: 20),
//                       const Padding(
//                         padding: EdgeInsets.only(left: 20, right: 20),
//                         child: Text(
//                           'Latest trackings:',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 20),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       BlocProvider(
//                           create: (context) =>
//                               TrackingsCubit(context.read<ClientsRepo>())
//                                 ..fetchTrackings(client.id),
//                           child: BlocBuilder<TrackingsCubit, TrackingsState>(
//                               builder: (context, state) {
//                             List<Tracking> trackings = state.trackings ?? [];

//                             return Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20.0),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: const [
//                                       Expanded(
//                                         child: Text(
//                                           'Name',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           'Total tracking',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           'Last tracking',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 Divider(height: 0),
//                                 Column(
//                                     children: trackings.map(
//                                   (e) {
//                                     return Column(
//                                       children: [
//                                         RawMaterialButton(
//                                           onPressed: () {
//                                             SideSheet.right(
//                                                 width: 500,
//                                                 body: FinishTrackingDialog(
//                                                   tag: e.tag,
//                                                   tags: BlocProvider.of<
//                                                           AuthCubit>(context)
//                                                       .state
//                                                       .company!
//                                                       .tags,
//                                                   client: ClientLite(
//                                                       id: client.id,
//                                                       name: client.name,
//                                                       internal:
//                                                           client.internal),
//                                                   onDelete: () {},
//                                                   onSave: (
//                                                     Tag? tag,
//                                                     Duration duration,
//                                                   ) {
//                                                     BlocProvider.of<
//                                                                 UpdateTrackingCubit>(
//                                                             context)
//                                                         .updateTracking(
//                                                       e,
//                                                       duration,
//                                                       tag!.id,
//                                                     );

//                                                     Navigator.pop(context);
//                                                   },
//                                                   duration: e.duration,
//                                                 ),
//                                                 context: context);
//                                           },
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 20.0),
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 20.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Expanded(
//                                                   child: Text(
//                                                     '${e.userName}',
//                                                     style:
//                                                         TextStyle(fontSize: 16),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Text(
//                                                     printDuration(e.duration),
//                                                     style:
//                                                         TextStyle(fontSize: 16),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Text(
//                                                     DateFormat(
//                                                             'EEE, dd MMM HH:MM ')
//                                                         .format(e.stop),
//                                                     style:
//                                                         TextStyle(fontSize: 16),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Divider(height: 0),
//                                       ],
//                                     );
//                                     // return Column(
//                                     //   crossAxisAlignment: CrossAxisAlignment.stretch,
//                                     //   children: trackings
//                                     //       .map((e) => BlocProvider(
//                                     //             create: (context) =>
//                                     //                 UpdateTrackingCubit(
//                                     //                     context.read<TrackerRepo>()),
//                                     //             child: trackingCard(
//                                     //               tracking: e,
//                                     //               client: client,
//                                     //             ),
//                                     //           ),)
//                                     //       .toList(),
//                                     // );
//                                   },
//                                 ).toList())
//                               ],
//                             );
//                           }))
//                     ],
//                   ),
//                 ),
//               ])
//             ])));
//   }
// }

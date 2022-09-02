// import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
// import 'package:agency_time/functions/clients/models/client.dart';
// import 'package:agency_time/functions/tracking/blocs/update_trackig_cubit/update_tracking_cubit.dart';
// import 'package:agency_time/functions/tracking/models/tag.dart';
// import 'package:agency_time/functions/tracking/models/tracking.dart';
// import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
// import 'package:agency_time/functions/tracking/views/finish_tracking/finish_tracking_view.dart';
// import 'package:agency_time/utils/constants/colors.dart';
// import 'package:agency_time/utils/functions/print_duration.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

// class trackingCard extends StatelessWidget {
//   const trackingCard({
//     required this.tracking,
//     required this.client,
//     Key? key,
//   }) : super(key: key);

//   final Tracking tracking;
//   final Client client;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showModalBottomSheet(
//             backgroundColor: Colors.transparent,
//             context: context,
//             isScrollControlled: true,
//             builder: (v) => FinishTrackingDialog(
//                   tag: tracking.tag,
//                   tags: BlocProvider.of<AuthCubit>(context).state.company!.tags,
//                   client: ClientLite(
//                       id: client.id,
//                       name: client.name,
//                       internal: client.internal),
//                   onDelete: () {},
//                   onSave: (
//                     Tag? tag,
//                     Duration duration,
//                   ) {
//                     BlocProvider.of<UpdateTrackingCubit>(context)
//                         .updateTracking(
//                       tracking,
//                       duration,
//                       tag!.id,
//                     );
//                     Navigator.pop(context);
//                   },
//                   duration: tracking.duration,
//                 ));
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 10),
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         decoration: BoxDecoration(
//           border: Border.all(color: kColorGrey),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   DateFormat('EEE, dd MMM ').format(tracking.start),
//                   style: TextStyle(
//                       height: 1,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black),
//                 ),
//                 Text(
//                   printDuration(tracking.duration),
//                   style: TextStyle(
//                       height: 1,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Text(
//               'User: ${tracking.userName}',
//               style: TextStyle(height: 1, color: Colors.black),
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Tag: ${tracking.tag.tag}',
//               style: TextStyle(height: 1, color: Colors.black),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

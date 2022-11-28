import 'package:agency_time/features/insights/presentation/widgets/stat_card.dart';
import 'package:agency_time/utils/widgets/stats_card.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Insights extends StatelessWidget {
  const Insights({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Expanded(
          //   child: Column(
          //     children: [
          //       Container(
          //         decoration: const BoxDecoration(
          //             image: DecorationImage(
          //                 image: AssetImage('assets/cover.png'),
          //                 fit: BoxFit.cover)),
          //         height: 250,
          //       ),
          //       Expanded(child: Container())
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left: 300, right: 300, top: 100),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'Company Insights',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 40,
          //         ),
          //       ),
          //       SizedBox(height: 50),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: const [
          //           StatBox(),
          //           StatBox(),
          //           StatBox(),
          //           StatBox(),
          //           StatBox(),
          //         ],
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

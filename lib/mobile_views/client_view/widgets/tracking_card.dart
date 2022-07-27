import 'package:agency_time/mobile_views/client_view/widgets/edit_sheet.dart';
import 'package:agency_time/models/tracking.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class trackingCard extends StatelessWidget {
  const trackingCard({
    required this.tracking,
    Key? key,
  }) : super(key: key);

  final Tracking tracking;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditTracking(tracking: tracking)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: kColorGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEE, dd MMM ').format(tracking.start),
                  style: TextStyle(
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                Text(
                  printDuration(tracking.duration),
                  style: TextStyle(
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'User: ${tracking.userName}',
              style: TextStyle(height: 1, color: Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              'Tag: ${tracking.tag.tag}',
              style: TextStyle(height: 1, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

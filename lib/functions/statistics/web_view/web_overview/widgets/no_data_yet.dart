import 'package:agency_time/functions/clients/views/add_clients_view.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';

class NoDataYetWidget extends StatelessWidget {
  const NoDataYetWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Welcome to SMMA tracker, create a your first client to begin uptimizing your agency',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          CustomElevatedButton(
              text: 'Create a clients',
              onPressed: () {
                SideSheet.right(
                    body: AddClientView(), context: context, width: 500);
              })
        ],
      ),
    );
  }
}

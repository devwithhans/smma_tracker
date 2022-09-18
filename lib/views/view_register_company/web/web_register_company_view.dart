import 'package:agency_time/logic/authentication/new_company_cubit/new_company_cubit.dart';
import 'package:agency_time/utils/constants/spacings.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:agency_time/utils/widgets/responsive_widgets/splitscreen.dart';
import 'package:agency_time/views/view_register_company/web/widgets/company_details.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class WebNewCompany extends StatefulWidget {
  static String pageName = 'register-company';

  const WebNewCompany({Key? key}) : super(key: key);

  @override
  State<WebNewCompany> createState() => _WebNewCompanyState();
}

class _WebNewCompanyState extends State<WebNewCompany> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ManageCompanyCubit(),
        child: ResponsiveSplitScreen(
          left: BlocBuilder<ManageCompanyCubit, ManageCompanyState>(
            builder: (context, state) {
              if (state.newCompanyStatus == NewCompanyStatus.loading) {
                return const LoadingScreen();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CompanyDetail(),
                  largeY,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

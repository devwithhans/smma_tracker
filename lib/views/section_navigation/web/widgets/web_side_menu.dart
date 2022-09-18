import 'package:agency_time/logic/data_visualisation/blocs/navigation_cubit/navigation_cubit.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/views/section_navigation/web/web_screens.dart';
import 'package:agency_time/views/section_navigation/web/widgets/web_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class WebSideMenu extends StatefulWidget {
  const WebSideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<WebSideMenu> createState() => _WebSideMenuState();
}

class _WebSideMenuState extends State<WebSideMenu> {
  String selectedTitle = '';
  List single =
      webScreens.where((element) => element.dropDownTitle == null).toList();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints(minWidth: 110, maxWidth: 300),
      width: width * 0.01,
      padding: EdgeInsets.all(20),
      color: kColorBlack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/whitelogo.svg',
                    width: 70,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Divider(
                height: 10,
                color: Color(0xff434343),
              ),
              Column(
                children: single
                    .map(
                      (e) => Column(
                        children: [
                          WebMenuButton(
                            onPressed: (v) {
                              selectedTitle = v;
                              setState(() {});
                              context
                                  .read<NavigationCubit>()
                                  .selectIndex(webScreens.indexOf(e));
                            },
                            selected: selectedTitle,
                            icon: e.icon,
                            text: e.title,
                          ),
                          Divider(
                            height: 10,
                            color: Color(0xff434343),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

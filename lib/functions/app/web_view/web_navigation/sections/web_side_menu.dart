import 'package:agency_time/functions/app/blocs/navigation_cubit/navigation_cubit.dart';
import 'package:agency_time/functions/app/web_view/web_navigation/sections/web_menu_button.dart';
import 'package:agency_time/functions/app/web_view/web_navigation/web_screens.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Container(
      width: 300,
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
                  Image.asset(
                    'assets/whitelogo.png',
                    scale: 3,
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

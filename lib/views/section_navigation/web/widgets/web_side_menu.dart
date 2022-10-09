import 'package:agency_time/logic/data_visualisation/blocs/navigation_cubit/navigation_cubit.dart';
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
      constraints: BoxConstraints(minWidth: 80, maxWidth: 200),
      width: width * 0.01,
      padding: EdgeInsets.all(5),
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/whitelogo.svg',
                    width: 45,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
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
                          const Divider(
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

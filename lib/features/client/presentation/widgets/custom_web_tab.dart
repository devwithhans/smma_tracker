import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/utils/widgets/buttons/icon_button.dart';
import 'package:agency_time/utils/widgets/buttons/main_button.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

class CustomWebTab extends StatefulWidget {
  const CustomWebTab({
    this.buttons = const [],
    required this.title,
    required this.tabs,
    this.backButton = false,
    Key? key,
  }) : super(key: key);

  final List<Widget> buttons;
  final List<TabScreen> tabs;
  final String title;
  final bool backButton;

  @override
  State<CustomWebTab> createState() => _CustomWebTabState();
}

class _CustomWebTabState extends State<CustomWebTab> {
  int index = 0;

// required this.client,
  @override
  Widget build(BuildContext context) {
    Company company = context.read<AuthorizeCubit>().state.company!;

    final moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: company.countryCode);
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade100,
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.backButton
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: CustomElevatedButton(
                              backgroundColor: Colors.grey,
                              text: 'Back',
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyle.boldLarge,
                    ),
                    Row(
                      children: widget.buttons,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: widget.tabs.map((e) {
                      int eIndex = widget.tabs.indexOf(e);
                      return CustomTabButton(
                        title: e.title,
                        onPressed: (v) {
                          index = eIndex;
                          setState(() {});
                        },
                        selected: index == eIndex,
                      );
                    }).toList())
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 100, right: 100, top: 40),
              child: widget.tabs[index].screen,
            ),
          )
        ],
      ),
    );
  }
}

class TabScreen {
  final Widget screen;
  final String title;
  TabScreen({required this.screen, required this.title});
}

class CustomTabButton extends StatelessWidget {
  const CustomTabButton({
    required this.selected,
    required this.onPressed,
    required this.title,
    Key? key,
  }) : super(key: key);

  final bool selected;
  final Function(String) onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: selected ? Colors.white : Colors.transparent,
      focusColor: selected ? Colors.white : Colors.transparent,
      splashColor: selected ? Colors.white : Colors.transparent,
      hoverColor: selected ? Colors.white : Colors.transparent,
      elevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      onPressed: () {
        print(title);
        onPressed(title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Text(
            title,
            style: AppTextStyle.boldSmall,
          ),
        ),
      ),
    );
  }
}

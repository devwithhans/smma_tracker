import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FiltersScroll extends StatefulWidget {
  const FiltersScroll({
    Key? key,
    this.inital = '',
    this.filters = const [],
    required this.onTap,
  }) : super(key: key);
  final String inital;

  final List<String> filters;
  final void Function(String value, bool topDown) onTap;

  @override
  State<FiltersScroll> createState() => _FiltersScrollState();
}

class _FiltersScrollState extends State<FiltersScroll> {
  String selected = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.inital;
  }

  bool topDown = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView(
        padding: EdgeInsets.only(
          left: 20,
        ),
        scrollDirection: Axis.horizontal,
        children: widget.filters
            .map((e) => SelectCard(
                  text: e,
                  icon: e == selected
                      ? Icon(
                          topDown
                              ? Icons.arrow_drop_down_rounded
                              : Icons.arrow_drop_up_rounded,
                          color: Colors.white,
                        )
                      : null,
                  selected: selected == e,
                  onTap: () {
                    if (selected == e) {
                      topDown = !topDown;
                    } else {
                      widget.filters.removeWhere((element) => element == e);
                      widget.filters.add(e);
                    }
                    HapticFeedback.lightImpact();
                    widget.onTap(e, topDown);
                    selected = e;
                    setState(() {});
                  },
                ))
            .toList(),
      ),
    );
  }
}

class SelectCard extends StatelessWidget {
  const SelectCard({
    Key? key,
    this.icon,
    this.preIcon,
    required this.text,
    this.secondaryText,
    this.onTap,
    this.height,
    this.margin = const EdgeInsets.only(right: 10),
    this.selected = false,
  }) : super(key: key);

  final bool selected;
  final double? height;
  final String text;
  final String? secondaryText;
  final EdgeInsetsGeometry? margin;
  final Icon? icon;
  final Icon? preIcon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.transparent,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            preIcon ?? SizedBox(),
            Text(
              text,
              style: TextStyle(color: selected ? Colors.white : Colors.black),
            ),
            secondaryText != null
                ? Text(
                    secondaryText!,
                    style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                : SizedBox(),
            icon ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}

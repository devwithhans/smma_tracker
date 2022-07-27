import 'package:flutter/material.dart';

class PeriodDropdown extends StatefulWidget {
  const PeriodDropdown({
    Key? key,
    this.onSelected,
    required this.values,
  }) : super(key: key);

  final void Function(String)? onSelected;
  final List<String> values;

  @override
  State<PeriodDropdown> createState() => _PeriodDropdownState();
}

class _PeriodDropdownState extends State<PeriodDropdown> {
  late String currentSelected;
  @override
  void initState() {
    currentSelected = widget.values[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      position: PopupMenuPosition.under,
      iconSize: 30,
      elevation: 0,
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      itemBuilder: (context) {
        return widget.values.map((str) {
          return PopupMenuItem(
            padding: EdgeInsets.symmetric(vertical: 1),
            value: str,
            child: Center(
              child: Text(
                str,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 10),
          Text(
            currentSelected,
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          Icon(Icons.arrow_drop_down),
        ],
      ),
      onSelected: (v) {
        currentSelected = v;
        setState(() {});
        widget.onSelected != null ? widget.onSelected!(v) : null;
      },
    );
  }
}

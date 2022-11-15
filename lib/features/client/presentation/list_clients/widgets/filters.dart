import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

class SelectFilter extends StatefulWidget {
  const SelectFilter({
    required this.filters,
    required this.onTap,
    this.initial,
    Key? key,
  }) : super(key: key);

  final List<String> filters;
  final String? initial;
  final Function(String) onTap;

  @override
  State<SelectFilter> createState() => _SelectFilterState();
}

class _SelectFilterState extends State<SelectFilter> {
  String selectedFilter = '';

  @override
  void initState() {
    // TODO: implement initState
    selectedFilter = widget.initial ?? widget.filters.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text(
            'Sort after: ',
            style: AppTextStyle.boldMedium,
          ),
          SizedBox(width: 10),
          Row(
            children: widget.filters.map(
              (e) {
                bool selected = e == selectedFilter;
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      selectedFilter = e;
                      widget.onTap(e);
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Text(
                        e,
                        style: TextStyle(
                            color: selected ? Colors.white : Colors.black),
                      ),
                      decoration: BoxDecoration(
                          color: selected ? Colors.black : Colors.grey.shade300,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }
}

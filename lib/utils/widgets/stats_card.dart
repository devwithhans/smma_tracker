import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/widgets/procentage_card.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:shimmer/shimmer.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    Key? key,
    required this.valueCard,
    required this.selectedGraph,
    this.expanded = false,
    this.responsive = false,
    required this.onPressed,
    this.loading = false,
  }) : super(key: key);

  final ValueCard valueCard;
  final String selectedGraph;
  final bool loading;
  final bool expanded;
  final bool responsive;
  final Function(String selected)? onPressed;
  @override
  Widget build(BuildContext context) {
    bool selected = selectedGraph == valueCard.title;
    double screenWidth = MediaQuery.of(context).size.width;
    double smallTextSize = responsive ? screenWidth * 0.008 : 12;
    if (loading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 150,
          width: 200,
          decoration: BoxDecoration(
            border: !selected ? Border.all(color: kColorGrey) : null,
            borderRadius: BorderRadius.circular(15),
            color: Colors.black,
          ),
        ),
      );
    }
    return Expanded(
      child: RawMaterialButton(
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        fillColor: selected ? Colors.black : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        constraints: BoxConstraints(minHeight: 50, maxHeight: 120),
        onPressed: () {
          if (onPressed != null) {
            onPressed!(valueCard.title);
          }
        },
        shape: RoundedRectangleBorder(
            side: BorderSide(color: kColorGrey),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              valueCard.title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: smallTextSize > 14
                      ? 14
                      : smallTextSize < 14
                          ? 14
                          : smallTextSize,
                  color: selected ? Colors.white70 : kColorGreyText),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  valueCard.value,
                  style: TextStyle(
                      fontSize: 35,
                      height: responsive ? screenWidth * 0.00055 : 1,
                      fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : Colors.black),
                ),
                valueCard.subValue is String
                    ? Text(
                        valueCard.subValue,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white70 : kColorGreyText,
                        ),
                      )
                    : valueCard.subValue.isNaN
                        ? const SizedBox()
                        : ProcentageChange(procentage: valueCard.subValue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

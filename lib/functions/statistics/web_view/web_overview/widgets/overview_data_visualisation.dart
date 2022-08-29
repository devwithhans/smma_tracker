import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/statistics/views/bottom_navigation.dart';
import 'package:agency_time/functions/statistics/web_view/web_overview/widgets/overview_stat_card.dart';
import 'package:flutter/material.dart';

import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:agency_time/utils/widgets/custom_graph.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class StatCardObject {
  final String title;
  final String value;
  final dynamic subValue;
  final List<GraphDataSpots>? graphDataSpots;

  const StatCardObject({
    required this.title,
    required this.subValue,
    required this.value,
    this.graphDataSpots,
  });
}

class OverviewData extends StatefulWidget {
  const OverviewData({
    required this.cardsList,
    this.pieChartList,
    Key? key,
  }) : super(key: key);

  final List<StatCardObject> cardsList;
  final List<Widget>? pieChartList;

  @override
  State<OverviewData> createState() => _OverviewDataState();
}

class _OverviewDataState extends State<OverviewData> {
  List<GraphDataSpots>? graphDataSpots;
  late String selectedGraph;
  @override
  void initState() {
    selectedGraph = widget.cardsList.first.title;
    graphDataSpots = widget.cardsList.first.graphDataSpots;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    graphDataSpots ??= widget.cardsList.first.graphDataSpots;

    double width = MediaQuery.of(context).size.width - 500;
    int gridWidth = 10;
    double breakPoint = 800;
    bool breaked = width > breakPoint;
    int widePart(double procentage) =>
        breaked ? (gridWidth * procentage).ceil() : 10;
    Company company = context.read<AuthCubit>().state.company!;

    final NumberFormat moneyFormatter = CustomCurrencyFormatter.getFormatter(
        countryCode: company.countryCode, short: false);

    List<Widget> cardWidgets = [];

    int count = 0;
    widget.cardsList.forEach(
      (e) {
        if (count != 0 && count != widget.cardsList.length) {
          cardWidgets.add(
            SizedBox(height: 20, width: 20),
          );
        }
        cardWidgets.add(OverStatCard(
          responsive: true,
          selected: selectedGraph,
          value: e.value,
          title: e.title,
          subValue: e.subValue,
          onTap: () {
            selectedGraph = e.title;
            graphDataSpots = e.graphDataSpots ?? [];
            setState(() {});
          },
        ));
        count += 1;
      },
    );

    return Column(
      children: [
        StaggeredGrid.count(
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: gridWidth,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: widePart(0.4),
              mainAxisCellCount: breaked
                  ? 3
                  : widget.cardsList.length == 6
                      ? 3
                      : 2,
              child: Builder(builder: (context) {
                if (widePart(0.4) == 10) {
                  if (widget.cardsList.length == 6) {
                    List<Widget> firstColumn = [];
                    List<Widget> secondColumn = [];
                    for (var i = 0; i < widget.cardsList.length; i++) {
                      StatCardObject e = widget.cardsList[i];
                      Widget card = OverStatCard(
                        responsive: true,
                        selected: selectedGraph,
                        value: e.value,
                        title: e.title,
                        subValue: e.subValue,
                        onTap: () {
                          selectedGraph = e.title;
                          graphDataSpots = e.graphDataSpots ?? [];
                          setState(() {});
                        },
                      );

                      if (i < 3) {
                        firstColumn.add(card);
                        if (i != 2) {
                          firstColumn.add(SizedBox(width: 20));
                        }
                      } else {
                        secondColumn.add(card);
                        if (i != 5) {
                          secondColumn.add(SizedBox(width: 20));
                        }
                      }
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: firstColumn,
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: secondColumn,
                          ),
                        )
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: cardWidgets,
                  );
                } else {
                  if (widget.cardsList.length == 6) {
                    List<Widget> firstColumn = [];
                    List<Widget> secondColumn = [];
                    for (var i = 0; i < widget.cardsList.length; i++) {
                      StatCardObject e = widget.cardsList[i];
                      Widget card = OverStatCard(
                        responsive: true,
                        selected: selectedGraph,
                        value: e.value,
                        title: e.title,
                        subValue: e.subValue,
                        onTap: () {
                          selectedGraph = e.title;
                          graphDataSpots = e.graphDataSpots ?? [];
                          setState(() {});
                        },
                      );

                      if (i < 3) {
                        firstColumn.add(card);
                        if (i != 2) {
                          firstColumn.add(SizedBox(height: 20));
                        }
                      } else {
                        secondColumn.add(card);
                        if (i != 5) {
                          secondColumn.add(SizedBox(height: 20));
                        }
                      }
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: firstColumn,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: secondColumn,
                          ),
                        )
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: cardWidgets,
                  );
                }
              }),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: widePart(0.6),
              mainAxisCellCount: breaked ? 3 : 5,
              child: SizedBox(
                  child: UniversalGraph(
                title: selectedGraph,
                graphDataSpots: graphDataSpots ?? [],
                moneyFormatter: moneyFormatter,
              )),
            ),
            Visibility(
              visible: widget.pieChartList != null,
              child: StaggeredGridTile.count(
                crossAxisCellCount: widePart(1),
                mainAxisCellCount: breaked ? 1.2 : 7,
                child: Builder(builder: (context) {
                  if (widePart(0.4) == 10) {
                    return Column(
                      children: widget.pieChartList!,
                    );
                  } else {
                    return Row(children: widget.pieChartList!);
                  }
                }),
              ),
            )
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

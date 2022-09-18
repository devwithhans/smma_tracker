import 'package:agency_time/models/company.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/stats_card.dart';
import 'package:agency_time/views/view_lists/web/widgets/client_list_result.dart';
import '../../data_visualisation_dependencies.dart';
import 'package:intl/intl.dart';

class ValueCard {
  final String title;
  final String value;
  final dynamic subValue;
  final List<GraphDataSpots>? graphDataSpots;

  const ValueCard({
    required this.title,
    required this.subValue,
    required this.value,
    this.graphDataSpots,
  });
}

class DataVisualisationTemplate extends StatefulWidget {
  const DataVisualisationTemplate({
    required this.cardsList,
    this.pieChartList,
    Key? key,
  }) : super(key: key);

  final List<ValueCard> cardsList;
  final List<Widget>? pieChartList;

  @override
  State<DataVisualisationTemplate> createState() =>
      _DataVisualisationTemplateState();
}

class _DataVisualisationTemplateState extends State<DataVisualisationTemplate> {
  List<GraphDataSpots>? graphDataSpots;
  late String selectedGraph;
  @override
  void initState() {
    selectedGraph = widget.cardsList.first.title;
    graphDataSpots = widget.cardsList.first.graphDataSpots;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    graphDataSpots ??= widget.cardsList.first.graphDataSpots;

    double width = MediaQuery.of(context).size.width - 500;

    Company company = context.read<AuthorizationCubit>().state.company!;
    final NumberFormat moneyFormatter = CustomCurrencyFormatter.getFormatter(
        countryCode: company.countryCode, short: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  StatCard(
                    onPressed: () {
                      graphDataSpots = widget.cardsList[0].graphDataSpots;
                      setState(() {});
                    },
                    title: widget.cardsList[0].title,
                    type: StatCardType.white,
                    value: widget.cardsList[0].value,
                    subText: widget.cardsList[0].subValue,
                  ),
                  const SizedBox(width: 20),
                  StatCard(
                    onPressed: () {
                      graphDataSpots = widget.cardsList[1].graphDataSpots;
                      setState(() {});
                    },
                    title: widget.cardsList[1].title,
                    type: StatCardType.white,
                    value: widget.cardsList[1].value,
                    subText: widget.cardsList[1].subValue,
                  ),
                  const SizedBox(width: 20),
                  StatCard(
                    onPressed: () {
                      graphDataSpots = widget.cardsList[2].graphDataSpots;
                      setState(() {});
                    },
                    type: StatCardType.white,
                    title: widget.cardsList[2].title,
                    value: widget.cardsList[2].value,
                    subText: widget.cardsList[2].subValue,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  StatCard(
                    onPressed: () {
                      graphDataSpots = widget.cardsList[3].graphDataSpots;
                      setState(() {});
                    },
                    title: widget.cardsList[3].title,
                    type: StatCardType.white,
                    value: widget.cardsList[3].value,
                    subText: widget.cardsList[3].subValue,
                  ),
                  const SizedBox(width: 20),
                  StatCard(
                    onPressed: () {
                      graphDataSpots = widget.cardsList[4].graphDataSpots;
                      setState(() {});
                    },
                    title: widget.cardsList[4].title,
                    type: StatCardType.white,
                    value: widget.cardsList[4].value,
                    subText: widget.cardsList[4].subValue,
                  ),
                  const SizedBox(width: 20),
                  StatCard(
                    onPressed: () {
                      graphDataSpots = widget.cardsList[5].graphDataSpots;
                      setState(() {});
                    },
                    type: StatCardType.white,
                    title: widget.cardsList[5].title,
                    value: widget.cardsList[5].value,
                    subText: widget.cardsList[5].subValue,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Expanded(
            child: UniversalGraph(
                graphDataSpots: graphDataSpots!,
                title: 'Company history',
                moneyFormatter: moneyFormatter),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top 3 hourly rate',
                style: AppTextStyle.boldMedium,
              ),
              Text(
                'Maybe you should spend some more time here?',
                style: AppTextStyle.fatGray,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Divider(
          height: 0,
        ),
        BlocBuilder<ClientsBloc, ClientsState>(
          builder: (context, state) {
            return ClientListResult(
                searchResult: state.clients, moneyFormatter: moneyFormatter);
          },
        )
      ],
    );
  }
}

List<List<Widget>> splitList(List list) {
  int arraySized = (list.length / 2).ceil();
  List<Widget> firstList = [];
  List<Widget> secondList = [];

  for (var i = 0; i < list.length; i++) {
    if (i >= arraySized) {
      secondList.add(list[i]);
    } else {
      firstList.add(list[i]);
    }
  }
  return [firstList, secondList];
}

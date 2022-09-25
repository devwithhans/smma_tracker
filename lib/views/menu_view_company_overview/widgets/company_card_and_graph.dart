import 'package:agency_time/models/company.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/stats_card.dart';
import 'package:agency_time/views/view_lists/web/widgets/client_list_result.dart';
import '../../view_data_visualisation/data_visualisation_dependencies.dart';
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

class GraphAndCards extends StatefulWidget {
  const GraphAndCards({
    required this.cardsList,
    Key? key,
  }) : super(key: key);

  final List<ValueCard> cardsList;

  @override
  State<GraphAndCards> createState() => _GraphAndCardsState();
}

class _GraphAndCardsState extends State<GraphAndCards> {
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
                    valueCard: widget.cardsList[0],
                    selectedGraph: selectedGraph,
                    onPressed: () {
                      graphDataSpots = widget.cardsList[0].graphDataSpots;
                      selectedGraph = widget.cardsList[0].title;
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 20),
                  StatCard(
                    valueCard: widget.cardsList[1],
                    selectedGraph: selectedGraph,
                    onPressed: () {
                      graphDataSpots = widget.cardsList[1].graphDataSpots;
                      selectedGraph = widget.cardsList[1].title;
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 20),
                  StatCard(
                    valueCard: widget.cardsList[2],
                    selectedGraph: selectedGraph,
                    onPressed: () {
                      graphDataSpots = widget.cardsList[2].graphDataSpots;
                      selectedGraph = widget.cardsList[2].title;
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  StatCard(
                    onPressed: () {
                      graphDataSpots = widget.cardsList[3].graphDataSpots;
                      selectedGraph = widget.cardsList[3].title;
                      setState(() {});
                    },
                    valueCard: widget.cardsList[3],
                    selectedGraph: selectedGraph,
                  ),
                  const SizedBox(width: 20),
                  StatCard(
                    onPressed: () {
                      graphDataSpots = widget.cardsList[4].graphDataSpots;
                      selectedGraph = widget.cardsList[4].title;
                      setState(() {});
                    },
                    valueCard: widget.cardsList[4],
                    selectedGraph: selectedGraph,
                  ),
                  const SizedBox(width: 20),
                  StatCard(
                    onPressed: () {
                      graphDataSpots = widget.cardsList[5].graphDataSpots;
                      selectedGraph = widget.cardsList[5].title;
                      setState(() {});
                    },
                    valueCard: widget.cardsList[5],
                    selectedGraph: selectedGraph,
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
          child: UniversalGraph(
              graphDataSpots: graphDataSpots!,
              title: 'Company history',
              moneyFormatter: moneyFormatter),
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

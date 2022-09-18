import 'package:agency_time/logic/clients/clients_bloc/clients_bloc.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:agency_time/views/dialog_payment/paymeny_view_dependencies.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class WebListHeader extends StatelessWidget {
  const WebListHeader({
    required this.onSearch,
    required this.onPlusPressed,
    required this.currentMonth,
    required this.title,
    required this.searchHint,
    Key? key,
  }) : super(key: key);

  final void Function(String) onSearch;
  final DateTime currentMonth;
  final String title;
  final String searchHint;
  final void Function()? onPlusPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: AppTextStyle.boldLarge),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: onPlusPressed,
                    icon: const Icon(Icons.add_circle),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: CustomSearchField(
                  hintText: searchHint,
                  onSearch: onSearch,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          CustomMonthButton(
              icon: Icons.calendar_month,
              onPressed: () async {
                DateTime? selection = await showMonthPicker(
                  firstDate: context.read<StatsBloc>().state.months.first.date!,
                  lastDate: context.read<StatsBloc>().state.months.last.date!,
                  context: context,
                  initialDate: currentMonth,
                );
                if (selection != null) {
                  context.read<StatsBloc>().add(GetStats(month: selection));
                  context
                      .read<ClientsBloc>()
                      .add(GetClientsWithMonth(month: selection));
                }
              },
              text: DateFormat('MMM, y').format(currentMonth))
        ],
      ),
    );
  }
}

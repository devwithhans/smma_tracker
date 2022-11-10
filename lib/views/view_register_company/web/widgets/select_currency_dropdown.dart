import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class DropDownSearch extends StatefulWidget {
  const DropDownSearch({
    required this.currencies,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  final List<Currency> currencies;
  final Function(String v) onChange;

  @override
  State<DropDownSearch> createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<DropDownSearch> {
  String searchParameter = '';
  Currency? selectedCurrency;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    List<Currency> result = widget.currencies
        .where((element) =>
            element.code.toLowerCase().contains(searchParameter.toLowerCase()))
        .toList();

    focusNode.addListener(() async {});
    return Column(
      children: [
        CustomInputForm(
          focusNode: focusNode,
          maxLines: 1,
          hintText: 'Search currency',
          controller: controller,
          validator: ((value) {
            if (selectedCurrency == null) {
              return 'Please select your preffered currency';
            }
          }),
          onChanged: (v) {
            searchParameter = v;
            selectedCurrency = null;
            setState(() {});
          },
          title: 'Choose preffered currency',
        ),
        Visibility(
          visible: selectedCurrency == null &&
              searchParameter.isNotEmpty &&
              focusNode.hasFocus,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(1, 4),
                    )
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border:
                      Border.all(color: const Color(0xFFC8C8C8), width: 0.5),
                ),
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 200, minHeight: 0),
                child: ListView(
                    children: result
                        .map(
                          (currency) => CurrencySearchResultTile(
                            currency: currency,
                            onTap: () {
                              selectedCurrency = currency;
                              widget.onChange(currency.code);
                              controller.text =
                                  '${CurrencyUtils.currencyToEmoji(currency.flag ?? '')} ${currency.code}';
                              setState(() {});
                            },
                          ),
                        )
                        .toList()),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CurrencySearchResultTile extends StatelessWidget {
  const CurrencySearchResultTile({
    required this.onTap,
    required this.currency,
    Key? key,
  }) : super(key: key);

  final void Function()? onTap;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(CurrencyUtils.currencyToEmoji(currency.flag ?? '')),
                Text(currency.code),
              ],
            ),
            Text(currency.symbol),
          ],
        ),
      ),
    );
  }
}

class CurrencyUtils {
  static String currencyToEmoji(String currencyFlag) {
    if (currencyFlag.isEmpty) return '';
    final int firstLetter = currencyFlag.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = currencyFlag.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}

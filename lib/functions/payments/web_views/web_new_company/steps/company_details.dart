import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/payments/models/new_company_cubit/new_company_cubit.dart';

import 'package:agency_time/utils/constants/currencies.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyDetail extends StatelessWidget {
  const CompanyDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    AuthState authState = context.read<AuthCubit>().state;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Let\'s set up your company',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
          ),
          const Text(
            'It only takes a few seconds',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 40),
          CustomInputForm(
            title: 'Company name',
            hintText: 'Company name',
            maxLines: 1,
            onChanged: (v) {
              context.read<ManageCompanyCubit>().updateValues(companyName: v);
            },
            validator: (b) {
              if (b == null || b.isEmpty) {
                return 'place enter a valid name';
              }
              return null;
            },
          ),
          SizedBox(height: 40),
          CustomInputForm(
            title: 'VAT number (Optional)',
            hintText: 'VAT number (Optional)',
            validator: (b) {},
            onChanged: (v) {
              context.read<ManageCompanyCubit>().updateValues(vatNumber: v);
            },
            keyboardType: TextInputType.number,
            maxLines: 1,
            inputFormatters: [],
          ),
          SizedBox(height: 40),
          DropDownSearch(
            items: currencies.map((e) => Currency.from(json: e)).toList(),
            onChange: ((v) => context
                .read<ManageCompanyCubit>()
                .updateValues(countryCode: v)),
          ),
          SizedBox(height: 40),
          CustomElevatedButton(
              text: 'Next',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context
                      .read<ManageCompanyCubit>()
                      .createCompany(authState.appUser!.id);
                }
              })
        ],
      ),
    );
  }
}

class DropDownSearch extends StatefulWidget {
  const DropDownSearch({
    required this.items,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  final List<Currency> items;
  final Function(String v) onChange;

  @override
  State<DropDownSearch> createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<DropDownSearch> {
  String searchParameter = '';
  Currency? selectedValue;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    List<Currency> result = widget.items
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
            if (selectedValue == null) {
              return 'Please select your preffered currency';
            }
          }),
          onChanged: (v) {
            searchParameter = v;
            selectedValue = null;
            setState(() {});
          },
          title: 'Choose preffered currency',
        ),
        Visibility(
          visible: selectedValue == null &&
              searchParameter.isNotEmpty &&
              focusNode.hasFocus,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(1, 4),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Color(0xFFC8C8C8), width: 0.5)),
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 200, minHeight: 0),
            child: ListView(
                children: result
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          selectedValue = e;
                          widget.onChange(e.code);
                          controller.text =
                              '${CurrencyUtils.currencyToEmoji(e.flag ?? '')} ${e.code}';
                          setState(() {});
                          print(e);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(CurrencyUtils.currencyToEmoji(
                                      e.flag ?? '')),
                                  Text(e.code),
                                ],
                              ),
                              Text(e.symbol),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList()),
          ),
        )
      ],
    );
  }
}

class CurrencyUtils {
  /// Return Flag (Emoji Unicode) of a given currency
  static String currencyToEmoji(String currencyFlag) {
    if (currencyFlag.isEmpty) return '';
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :u
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = currencyFlag.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = currencyFlag.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}

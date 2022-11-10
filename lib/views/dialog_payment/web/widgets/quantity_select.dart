import '../../paymeny_view_dependencies.dart';

class QuantitySelect extends StatefulWidget {
  const QuantitySelect({
    this.initial = 1,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  final int initial;
  final Function(int value) onChange;

  @override
  State<QuantitySelect> createState() => _QuantitySelectState();
}

class _QuantitySelectState extends State<QuantitySelect> {
  late int value;
  @override
  void initState() {
    value = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          splashRadius: 20,
          onPressed: () {
            if (value > 1) {
              value--;
              widget.onChange(value);

              setState(() {});
            }
          },
          icon: Text(
            '-',
            style: AppTextStyle.boldMedium,
          ),
        ),
        SizedBox(
          width: 80,
          child: CustomInputForm(
            controller: TextEditingController(text: value.toString()),
            onChanged: (v) {
              value = int.parse(v);
              widget.onChange(value);
            },
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            value++;
            widget.onChange(value);
            setState(() {});
          },
          icon: Text(
            '+',
            style: AppTextStyle.boldMedium,
          ),
        )
      ],
    );
  }
}

import 'package:agency_time/logic/timer/repositories/timer_repo.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/custom_alert_dialog.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/sheet_header_widget.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

class FinishTimerView extends StatefulWidget {
  const FinishTimerView({
    Key? key,
    required this.tags,
    this.tag,
    required this.client,
    required this.onDelete,
    required this.onSave,
    required this.duration,
  }) : super(key: key);

  final Duration duration;
  final List<Tag> tags;
  final Tag? tag;
  final Client client;
  final void Function(Tag? selected, Duration duration) onSave;
  final void Function() onDelete;

  @override
  State<FinishTimerView> createState() => _FinishTimerViewState();
}

class _FinishTimerViewState extends State<FinishTimerView> {
  Duration _duration = const Duration();
  Duration? _newDuration;

  Tag? selectedTag;
  List<Tag> tags = [];
  bool newTag = false;
  String typedTag = '';

  @override
  void initState() {
    super.initState();
    selectedTag = widget.tag;
    tags = widget.tags;
    _duration = widget.duration;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetHeader(
              title: 'Finish ${widget.client.name} tracking',
            ),
            DurationAndTagEdit(
              onDurationChanged: (v) {
                _newDuration = v;
              },
              onTagSelected: (v) {
                selectedTag = v;
              },
              internal: widget.client.internal,
              tags: tags,
              selectedTag: selectedTag,
              originalDuration: _duration,
              newDuration: _newDuration,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormField(validator: (v) {
                    if (selectedTag == null) {
                      if (widget.client.internal) return null;

                      return 'You need to select or create a tag';
                    }
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        formState.hasError
                            ? Text(
                                formState.errorText ?? '',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.smallRed,
                              )
                            : const SizedBox(),
                        CustomElevatedButton(
                          text: 'SAVE',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (selectedTag != null) {
                                if (tags
                                    .where((element) =>
                                        element.id == selectedTag!.id)
                                    .isEmpty) {
                                  RepositoryProvider.of<TimerRepository>(
                                          context)
                                      .addTag(selectedTag!);
                                  context
                                      .read<AuthorizationCubit>()
                                      .state
                                      .company!
                                      .tags
                                      .add(selectedTag!);
                                }
                              }
                              widget.onSave(
                                  selectedTag, _newDuration ?? _duration);
                            }
                          },
                          backgroundColor: kColorGreen,
                        ),
                      ],
                    );
                  }),
                  CustomTextButton(
                    text: 'Delete',
                    onPressed: () {
                      customAlertDialog(
                        context: context,
                        title: 'Are you sure you wanna delete this tracking?',
                        description: 'You cannot restore this tracking',
                        onAccepted: () {
                          widget.onDelete();
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      );
                    },
                    backgroundColor: kColorRed,
                    textColor: kColorRed,
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

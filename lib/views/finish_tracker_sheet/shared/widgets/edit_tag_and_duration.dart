import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/functions/tracking/views/finish_tracking/widgets/search_tags.dart';
import 'package:agency_time/views/data_visualisation_views/data_visualisation_dependencies.dart';
import 'package:agency_time/views/finish_tracker_sheet/shared/widgets/duration_formfield.dart';

class DurationAndTagEdit extends StatelessWidget {
  const DurationAndTagEdit({
    required this.newDuration,
    required this.onDurationChanged,
    required this.originalDuration,
    required this.internal,
    required this.onTagSelected,
    required this.selectedTag,
    required this.tags,
    Key? key,
  }) : super(key: key);

  final Duration originalDuration;
  final bool internal;
  final Duration? newDuration;
  final void Function(Duration) onDurationChanged;
  final void Function(Tag?) onTagSelected;
  final List<Tag> tags;
  final Tag? selectedTag;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Original: ${printDuration(originalDuration)}',
            ),
            DurationFormField(
              initialDuration: newDuration ?? originalDuration,
              onChanged: onDurationChanged,
            ),
          ],
        ),
        const Divider(
          height: 10,
        ),
        const SizedBox(height: 20),
        internal
            ? const SizedBox()
            : SearchTags(
                selectedTag: selectedTag,
                onChange: onTagSelected,
                tags: tags,
              ),
      ],
    ));
  }
}

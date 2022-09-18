class Tag {
  final int id;
  final String tag;
  final String description;
  final bool active;
  final int? value;

  Tag copyWith({
    int? id,
    String? tag,
    String? description,
    bool? active,
    int? value,
  }) {
    return Tag(
        description: description ?? this.description,
        tag: tag ?? this.tag,
        value: value ?? this.value,
        id: id ?? this.id,
        active: active ?? this.active);
  }

  Tag({
    required this.description,
    required this.id,
    this.value,
    required this.tag,
    this.active = true,
  });
}

class Service {
  final int id;
  final String title;
  final String description;
  final bool active;
  final int? value;

  Service copyWith({
    int? id,
    String? title,
    String? description,
    bool? active,
    int? value,
  }) {
    return Service(
        description: description ?? this.description,
        title: title ?? this.title,
        value: value ?? this.value,
        id: id ?? this.id,
        active: active ?? this.active);
  }

  Service({
    required this.description,
    required this.id,
    this.value,
    required this.title,
    this.active = true,
  });
}

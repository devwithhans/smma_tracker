import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/models/user.dart';

class Company {
  String id;
  List<Tag> tags;
  String companyName;
  List<Member> members;
  Map roles;
  String countryCode;
  Subscription? subscription;

  Company({
    required this.tags,
    required this.roles,
    required this.members,
    required this.companyName,
    required this.id,
    this.subscription,
    this.countryCode = 'USD',
  });

  Company copyWith({
    String? id,
    List<Tag>? tags,
    String? companyName,
    List<Member>? members,
    Map? roles,
    String? countryCode,
    Subscription? subscription,
  }) {
    return Company(
      countryCode: countryCode ?? this.countryCode,
      subscription: subscription ?? this.subscription,
      tags: tags ?? this.tags,
      members: members ?? this.members,
      roles: roles ?? this.roles,
      companyName: companyName ?? this.companyName,
      id: id ?? this.id,
    );
  }

  static Company convert(Map value, String id) {
    List<Tag> tags = [];
    Map<String, dynamic> tagsMap = value['tags'] != null
        ? Map<String, dynamic>.from(value['tags'])
        : const {};

    tagsMap.forEach((key, value) {
      tags.add(Tag(
          id: int.parse(key),
          description: value['description'] ?? '',
          tag: value['tag'] ?? {},
          active: value['active'] ?? true));
    });

    return Company(
      id: id,
      tags: tags,
      roles: value['members'],
      subscription: value['subscription'] != null
          ? Subscription(
              active: value['subscription']['status'] == 'active',
              id: value['subscription']['subscriptionId'] ?? '',
              seats: value['subscription']['seats'])
          : null,
      members: [],
      countryCode: value['countryCode'],
      companyName: value['companyName'],
    );
  }
}

class Subscription {
  bool active;
  String id;
  int seats;

  Subscription({required this.active, required this.id, required this.seats});
}

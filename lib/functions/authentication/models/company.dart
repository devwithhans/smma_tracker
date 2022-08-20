import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Company {
  String id;
  List<Tag> tags;
  String companyName;
  List<Member> members;
  Map roles;
  String countryCode;

  Company({
    required this.tags,
    required this.roles,
    required this.members,
    required this.companyName,
    required this.id,
    this.countryCode = 'en',
  });

  Company copyWith({
    String? id,
    List<Tag>? tags,
    String? companyName,
    List<Member>? members,
    Map? roles,
    String? countryCode,
  }) {
    return Company(
      countryCode: countryCode ?? this.countryCode,
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
      members: [],
      countryCode: value['countryCode'],
      companyName: value['companyName'],
    );
  }
}

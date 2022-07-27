import 'dart:convert';

import 'package:agency_time/models/tag.dart';

class Company {
  String id;
  List<Tag> tags;
  String companyName;

  Company({required this.tags, required this.companyName, required this.id});

  static Company convert(Map value, String id) {
    List<Tag> tags = [];
    Map<String, dynamic> tagsMap = value['tags'] != null
        ? Map<String, dynamic>.from(value['tags'])
        : const {};

    tagsMap.forEach((key, value) {
      tags.add(Tag(
          id: int.parse(key),
          description: value['description'],
          tag: value['tag']));
    });

    return Company(
      id: id,
      tags: tags,
      companyName: value['companyName'],
    );
  }
}

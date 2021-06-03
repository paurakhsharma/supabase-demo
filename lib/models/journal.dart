import 'dart:convert';

import 'package:flutter/foundation.dart';

class Journal {
  final int id;
  final String title;
  final String description;
  final List<String> images;
  final DateTime date;
  Journal({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.date,
  });

  Journal copyWith({
    int? id,
    String? title,
    String? description,
    List<String>? images,
    DateTime? date,
  }) {
    return Journal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Journal.fromMap(Map<String, dynamic> map) {
    return Journal(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      images: List<String>.from(map['images']),
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Journal.fromJson(String source) =>
      Journal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Journal(id: $id, title: $title, description: $description, images: $images, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Journal &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        listEquals(other.images, images) &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        images.hashCode ^
        date.hashCode;
  }
}

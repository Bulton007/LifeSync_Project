import 'dart:convert';

final class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.attachments = const [],
  });

  final int? id;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  /// Base64-encoded image bytes. Journal data never leaves this device.
  final List<String> attachments;

  JournalEntry copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    List<String>? attachments,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, Object?> toDatabase() => {
    if (id != null) 'id': id,
    'title': title,
    'body': body,
    'tags_json': jsonEncode(tags),
    'attachments_json': jsonEncode(attachments),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory JournalEntry.fromDatabase(Map<String, Object?> data) {
    List<String> stringsFrom(String key) =>
        (jsonDecode(data[key]! as String) as List<dynamic>)
            .map((value) => value.toString())
            .toList(growable: false);

    return JournalEntry(
      id: data['id']! as int,
      title: data['title']! as String,
      body: data['body']! as String,
      tags: stringsFrom('tags_json'),
      attachments: stringsFrom('attachments_json'),
      createdAt: DateTime.parse(data['created_at']! as String),
      updatedAt: DateTime.parse(data['updated_at']! as String),
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userId': instance.userId,
    };

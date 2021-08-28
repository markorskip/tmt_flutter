// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goal _$GoalFromJson(Map<String, dynamic> json) {
  return Goal(
    json['title'] as String,
    json['description'] as String?,
    (json['costInDollars'] as num).toDouble(),
    json['timeInHours'] as int,
  )
    ..complete = json['complete'] as bool
    ..isDeleted = json['isDeleted'] as bool
    ..levelDeep = json['levelDeep'] as int
    ..goals = (json['goals'] as List<dynamic>)
        .map((e) => Goal.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$GoalToJson(Goal instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'costInDollars': instance.costInDollars,
      'timeInHours': instance.timeInHours,
      'complete': instance.complete,
      'isDeleted': instance.isDeleted,
      'levelDeep': instance.levelDeep,
      'goals': instance.goals,
    };

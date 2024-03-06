import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String descrption;
  final bool check;
  const Task({
    required this.id,
    required this.descrption,
    required this.check,
  });

  @override
  List<Object?> get props => [id, descrption, check];

  Task copyWith({
    int? id,
    String? descrption,
    bool? check,
  }) {
    return Task(
      id: id ?? this.id,
      descrption: descrption ?? this.descrption,
      check: check ?? this.check,
    );
  }
}

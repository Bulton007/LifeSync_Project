enum FocusMode { pomodoro, stopwatch }

final class FocusSession {
  const FocusSession({
    required this.id,
    required this.mode,
    required this.startedAt,
    required this.durationSeconds,
    required this.completed,
    this.taskName,
    this.soundName,
  });

  final int? id;
  final FocusMode mode;
  final String? taskName;
  final String? soundName;
  final DateTime startedAt;
  final int durationSeconds;
  final bool completed;

  FocusSession copyWith({
    int? id,
    String? soundName,
  }) => FocusSession(
    id: id ?? this.id,
    mode: mode,
    taskName: taskName,
    soundName: soundName ?? this.soundName,
    startedAt: startedAt,
    durationSeconds: durationSeconds,
    completed: completed,
  );

  Map<String, Object?> toDatabase() => {
    if (id != null) 'id': id,
    'mode': mode.name,
    'task_name': taskName,
    'sound_name': soundName,
    'started_at': startedAt.toIso8601String(),
    'duration_seconds': durationSeconds,
    'completed': completed ? 1 : 0,
  };

  factory FocusSession.fromDatabase(Map<String, Object?> data) => FocusSession(
    id: data['id']! as int,
    mode: FocusMode.values.byName(data['mode']! as String),
    taskName: data['task_name'] as String?,
    soundName: data['sound_name'] as String?,
    startedAt: DateTime.parse(data['started_at']! as String),
    durationSeconds: data['duration_seconds']! as int,
    completed: data['completed']! as int == 1,
  );
}

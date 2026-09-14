import 'package:life_sync_app/features/focus/data/models/focus_session.dart';

abstract interface class FocusRepository {
  Future<List<FocusSession>> readAll();

  Future<FocusSession> create(FocusSession session);
}

import 'database_factory_init_stub.dart'
    if (dart.library.io) 'database_factory_init_io.dart'
    if (dart.library.js_interop) 'database_factory_init_web.dart'
    if (dart.library.html) 'database_factory_init_web.dart';

void initLifeSyncDatabaseFactory() {
  initializeDatabaseFactoryPlatform();
}

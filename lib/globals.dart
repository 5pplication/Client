library client.globals;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

FlutterSecureStorage? secureStorage;

void initSecureStorage() {
  secureStorage = const FlutterSecureStorage();
}

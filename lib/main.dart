import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  new Routes();
}

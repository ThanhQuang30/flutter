import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split/splitwise/database.dart';
import 'package:split/splitwise/groups/group_manager.dart';
import 'package:split/splitwise/split/splitwise_info.dart';
import 'package:split/src/fire_base/fire_base.dart';
import 'package:split/src/resources/login.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentUser()),
        ChangeNotifierProvider(create: (_) => SplitwiseInfo()),
        Provider(create: (_) => GroupManager()),
        Provider<OurDatabase>(
          create: (_) => OurDatabase(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

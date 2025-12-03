import 'package:flutter/material.dart';
import 'pages/login_page.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qumqjiypyfhuwcdordpb.supabase.co', // Project URL
    anonKey: 'sb_publishable_uzRQazMCSotJURE8iUG7jg_5yaZS_bu', // API key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Ship-Tracker',
      home: LoginPage(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/deliveries/presentation/screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox<String>('delivery_cache');

  runApp(const ProviderScope(child: PureDropDairyApp()));
}

class PureDropDairyApp extends StatelessWidget {
  const PureDropDairyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PureDrop Dairy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1677D2)),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const DashboardScreen(),
    );
  }
}

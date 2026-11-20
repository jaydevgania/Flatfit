import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatfit/app.dart';
import 'package:flatfit/core/network/supabase_client.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Set portrait orientation by default for mobile
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set transparent status bar overlay
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    // Initialize Supabase client
    await SupabaseService.initialize();

    runApp(
      const ProviderScope(
        child: FlatFitApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('Uncaught top-level error: $error\n$stack');
  });
}

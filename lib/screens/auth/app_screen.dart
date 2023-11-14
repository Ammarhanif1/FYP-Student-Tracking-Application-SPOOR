import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/screens/auth/error_screen.dart';

import '../../providers/firebase_app_provider.dart';
import 'auth_check.dart';
import 'loading_screen.dart';

/// This page gets shown IMMEDIATELY after the splash screen.
/// This page is the actual "FIRST" page that determines whether user is logged in
/// or not.

class AppScreen extends ConsumerWidget {
  const AppScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialize = ref.watch(firebaseinitializerProvider);

    return initialize.when(
        data: (data) {
          return const AuthChecker();
        },
        loading: () => const LoadingScreen(),
        error: (e, stackTrace) {
          debugPrint("App_Screen: ${e.toString()}");
          debugPrintStack(stackTrace: stackTrace);
          return ErrorScreen(e, stackTrace);
        });
  }
}

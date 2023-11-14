import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/screens/auth/stdlogin.dart';
import 'package:fyp/screens/auth/error_screen.dart';
import 'package:fyp/screens/auth/loading_screen.dart';
import 'package:fyp/screens/latselection.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
        data: (data) {
          // if (data != null) return const HomePage();
          if (data != null) {
            return SelectionPage(data.uid, data.displayName!);
          }
          return const LoginScreen();
        },
        loading: () => const LoadingScreen(),
        error: (e, trace) => ErrorScreen(e, trace));
  }
}

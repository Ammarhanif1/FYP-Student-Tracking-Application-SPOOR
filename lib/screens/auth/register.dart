import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/providers/auth_provider.dart';
import 'package:fyp/providers/user_doc_provider.dart';
import 'package:fyp/screens/auth/auth_check.dart';

import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  //  A loading variable to show the loading animation when you a function is ongoing
  bool _isLoading = false;
  void loading() {
    if (mounted) {
      setState(() {
        _isLoading = !_isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authenticationProvider);

    Future<void> onSignUpPressed() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      loading();
      await auth
          .signUpWithEmailAndPassword(
              _emailController.text, _passwordController.text, context)
          .whenComplete(() => auth.authStateChange.listen((event) async {
                if (event == null) {
                  loading();
                  return;
                } else {
                  await event.updateDisplayName(_usernameController.text);
                  ref.invalidate(authStateProvider);
                  ref.invalidate(studentDocProvider);
                  if (mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AuthChecker(),
                    ));
                  }
                }
              }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              'Registration',
            ),
          ],
        ),
        backgroundColor: const Color(0xff5c5cff),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffEDEFFF),
                    border: Border.all(
                      color: const Color(0xffEDEFFF),
                    ),
                    borderRadius: BorderRadius.circular(120),
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    onSaved: (_) {},
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefix: Text(' '),
                      hintText: '   Username',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid username!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffEDEFFF),
                    border: Border.all(
                      color: const Color(0xffEDEFFF),
                    ),
                    borderRadius: BorderRadius.circular(120),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (_) {},
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefix: Text(' '),
                      hintText: '   Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !value.contains('@') ||
                          !value.endsWith(".com")) {
                        return "Invalid email!";
                      } else if (!value.endsWith("hotmail.com") &&
                          !value.endsWith("gmail.com")) {
                        return 'Invalid email provider!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffEDEFFF),
                    border: Border.all(
                      color: const Color(0xffEDEFFF),
                    ),
                    borderRadius: BorderRadius.circular(120),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefix: Text(' '),
                      hintText: '   Password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Stack(children: [
                    SizedBox(
                      height: 50,
                      width: 310,
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton.icon(
                              // <-- ElevatedButton
                              onPressed: onSignUpPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff5c5cff),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(120),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              ),
                              icon: const ImageIcon(
                                AssetImage("assets/images/onlylogo.png"),
                                size: 35,
                              ),
                              label: Text(
                                  style: GoogleFonts.nunito(fontSize: 20),
                                  'Sign Up'),
                            ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

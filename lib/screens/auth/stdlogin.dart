import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/screens/auth/register.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/auth_provider.dart';

// ?? @SupremeDeity: Tip: Try replacing MediaQueries and Positioned elements
// these cause weird artifacts and positioning while using on different mobiles
// with different sizes.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();

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
    return Consumer(builder: (context, ref, child) {
      final auth = ref.watch(authenticationProvider);

      Future<void> onSignInPressed() async {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        loading();
        await auth
            .signInWithEmailAndPassword(_email.text, _password.text, context)
            .whenComplete(() => auth.authStateChange.listen((event) async {
                  if (event == null) {
                    loading();
                    return;
                  }
                }));
      }

      return SafeArea(
          child: Scaffold(
              backgroundColor: const Color(0xff181a20),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 580,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/images/Group.png"),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 111,
                            left: 38,
                            height: 102,
                            width: 284,
                            child: Text("Login With Your Email",
                                style: GoogleFonts.nunito(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xffFFFFFF))),
                          ),
                          Positioned(
                            width: 250,
                            height: 330,
                            left: 25,
                            top: 200,
                            child: Image.asset("assets/images/key.png"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffEDEFFF),
                                border: Border.all(
                                  color: const Color(0xffEDEFFF),
                                ),
                                borderRadius: BorderRadius.circular(120),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Center(
                                  child: TextFormField(
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress,
                                    onSaved: (_) {},
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefix: Text(' '),
                                      hintText: 'Email',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Invalid email!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffEDEFFF),
                                border: Border.all(
                                  color: const Color(0xffEDEFFF),
                                ),
                                borderRadius: BorderRadius.circular(120),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Center(
                                  child: TextFormField(
                                    controller: _password,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefix: Text(' '),
                                      hintText: 'Password',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 6) {
                                        return 'Password is too short!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Stack(children: [
                              SizedBox(
                                height: 50,
                                width: 310,
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : ElevatedButton.icon(
                                        // onPressed: () {
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               const SelectionPage()));
                                        // },
                                        onPressed: onSignInPressed,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff5c5cff),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(120),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                        ),
                                        icon: const ImageIcon(
                                          AssetImage(
                                              "assets/images/onlylogo.png"),
                                          size: 35,
                                        ),
                                        label: Text(
                                            style: GoogleFonts.nunito(
                                                fontSize: 20),
                                            'Login'),
                                      ),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen(),
                                ));
                              },
                              child: const Text(
                                "Create an Account",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Text(
                              "Welcome to Students Panel",
                              style: GoogleFonts.nunito(
                                  fontSize: 14, color: const Color(0xff7C82BA)),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Read our Privacy Policy and Terms and Conditions",
                              style: GoogleFonts.nunito(
                                  fontSize: 11, color: const Color(0xff7C82BA)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )));
    });
  }
}

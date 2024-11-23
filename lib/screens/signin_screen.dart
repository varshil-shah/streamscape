import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:streamscape/constants.dart';
import 'package:streamscape/models/user_model.dart';
import 'package:streamscape/providers/user_provider.dart';
import 'package:streamscape/routes.dart';
import 'package:streamscape/services/auth_service.dart';
import 'package:streamscape/widgets/form_button.dart';
import 'package:streamscape/widgets/custom_snackbar.dart';
import 'package:streamscape/widgets/input_field.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    void handleSignup() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        isLoading = true;
      });

      final email = emailController.text;
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        return CustomSnackBar.showSnackBar(
          context,
          "Please fill in all the fields",
        );
      }

      final User? user = await authService.signin(context, email, password);
      setState(() {
        isLoading = false;
      });

      if (user != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(user);

        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.main,
          (route) => false,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/access_account.svg",
                    height: size.height * 0.35,
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextInputField(
                          controller: emailController,
                          hintText: "Enter your email address",
                          icon: Icons.mail,
                          keyboardType: TextInputType.emailAddress,
                          validator: (email) {
                            if (email!.isEmpty || !email.contains("@")) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextInputField(
                          controller: passwordController,
                          hintText: "Enter your password",
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          icon: Icons.lock,
                          validator: (password) {
                            if (password!.isEmpty) {
                              return "Please enter your password";
                            }

                            if (password.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: FormButton(
                                  text: "Sign in",
                                  onPressed: handleSignup,
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.signup);
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    void handleSignup(BuildContext ctx) async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        isLoading = true;
      });

      final name = nameController.text;
      final email = emailController.text;
      final password = passwordController.text;

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        return CustomSnackBar.showSnackBar(
          context,
          "Please fill in all the fields",
        );
      }

      if (!mounted) return;

      final User? user = await authService.signup(ctx, name, email, password);
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    "assets/images/secure_login.svg",
                    height: size.height * 0.3,
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
                          controller: nameController,
                          hintText: "Enter your name",
                          icon: Icons.person,
                          validator: (name) {
                            if (name!.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextInputField(
                          controller: emailController,
                          hintText: "Enter your email address",
                          icon: Icons.mail,
                          keyboardType: TextInputType.emailAddress,
                          validator: (email) {
                            if (email!.isEmpty || !email.contains("@")) {
                              return "Please enter your email address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextInputField(
                          controller: passwordController,
                          hintText: "Enter your password",
                          obscureText: true,
                          icon: Icons.lock,
                          keyboardType: TextInputType.visiblePassword,
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
                              ))
                            : SizedBox(
                                width: double.infinity,
                                child: FormButton(
                                  text: "Sign up",
                                  onPressed: () {
                                    handleSignup(context);
                                  },
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.signin);
                              },
                              child: const Text(
                                "Sign in",
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

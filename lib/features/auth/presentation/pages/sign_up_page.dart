import 'package:compareitr/core/common/widgets/loader.dart';
import 'package:compareitr/core/theme/app_pallete.dart';
import 'package:compareitr/core/utils/show_snackbar.dart';
import 'package:compareitr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:compareitr/features/auth/presentation/pages/welcome_page.dart';
import 'package:compareitr/features/auth/presentation/widgets/auth_button.dart';
import 'package:compareitr/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    streetController.dispose();
    locationController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          resizeToAvoidBottomInset: true, // Ensures layout adjusts to keyboard
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              } else if (state is AuthSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top Container
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                            decoration: const BoxDecoration(
                              color: AppPallete.authColor,
                            ),
                            child: const SafeArea(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Create Your \nAccount",
                                      style: TextStyle(
                                        color: AppPallete.backgroundColor,
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                    Text(
                                      "Sign up to create your account",
                                      style: TextStyle(
                                        color: AppPallete.secondaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Form Fields
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 25),
                                  AuthField(
                                    hintText: "Name",
                                    controller: nameController,
                                  ),
                                  const SizedBox(height: 20),
                                  AuthField(
                                    hintText: "Email",
                                    controller: emailController,
                                  ),
                                  const SizedBox(height: 20),
                                  AuthField(
                                    hintText: "Password",
                                    controller: passwordController,
                                    isObscureText: true,
                                  ),
                                  const SizedBox(height: 20),
                                  AuthField(
                                    hintText: "Location",
                                    controller: locationController,
                                    isObscureText: false,
                                  ),
                                  const SizedBox(height: 20),
                                  AuthField(
                                    hintText: "Street Name",
                                    controller: streetController,
                                    isObscureText: false,
                                  ),
                                  const SizedBox(height: 20),
                                  AuthField(
                                    hintText: "Phone Number",
                                    controller: phoneController,
                                    keyboardType: TextInputType
                                        .phone, // Add this for numeric input
                                  ),

                                  const SizedBox(height: 15),

                                  // Sign Up Button
                                  AuthButton(
                                    buttonText: "Sign Up",
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                              AuthSignUp(
                                                street: streetController.text
                                                    .trim(),
                                                name:
                                                    nameController.text.trim(),
                                                password: passwordController
                                                    .text
                                                    .trim(),
                                                email:
                                                    emailController.text.trim(),
                                                location: locationController
                                                    .text
                                                    .trim(),
                                                phoneNumber: int.tryParse(
                                                        phoneController.text
                                                            .trim()) ??
                                                    0,
                                                
                                              ),
                                            );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

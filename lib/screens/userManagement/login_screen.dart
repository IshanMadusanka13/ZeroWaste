import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/repositories/user_repository.dart';
import 'package:zero_waste/utils/validators.dart';
import 'package:zero_waste/widgets/submit_button.dart';
import 'package:zero_waste/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade200, Colors.blue.shade200],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () {
                  context.go('/dashboard'); // Use GoRouter to navigate
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(
                    left: 120.0, bottom: 155.0), // Moves the text upwards
                title: const Text(
                  'Record Garbage',
                  style: TextStyle(
                    color: Colors.green, // Sets the text color to white
                    fontWeight: FontWeight.bold, // Makes the text bold
                    fontSize: 20.0, // Adjusts the font size
                  ),
                ),
                background: Image.asset(
                  'assets/garbage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldInput(
                        title: "Email",
                        icon: Icons.person,
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                        validator: Validators.validateEmail),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "Password",
                        icon: Icons.person,
                        controller: _passwordController,
                        inputType: TextInputType.visiblePassword,
                        validator: Validators.validatePassword),
                    const SizedBox(height: 24),
                    SubmitButton(
                        icon: Icons.send,
                        text: "Login",
                        whenPressed: _submitForm),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    ));
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = User(
        email: _emailController.text,
        password: _passwordController.text,
        userType: 'HouseholdUser',
      );
      UserRepository().login(user).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User registered successfully!')));
        context.go("/home");
      }).catchError((error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to register HouseholdUser')));
      });
    }
  }
}

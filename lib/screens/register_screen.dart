import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _noOfHouseholdsController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: content(context),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bgImg.jpg"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(50, 30),
                  bottomRight: Radius.elliptical(50, 30))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/Logo.png"),
          ),
        ),
        const SizedBox(height: 50),
        Form(
          key: _formKey,
          child: Column(
            children: [
              inputStyle(
                  "First Name", "Enter Your First Name", _fnameController, validateEmail),
              inputStyle(
                  "Last Name", "Enter Your Last Name", _lnameController, validateEmail),
              inputStyle(
                  "Email", "Enter Your Email", _emailController, validateEmail),
              inputStyle("Password", "Enter Your Password", _passwordController,
                  validatePassword),
            ],
          ),
        ),
        const SizedBox(height: 80),
        Container(
          height: 60,
          margin: const EdgeInsets.fromLTRB(40, 5, 20, 10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {}
            },
            child: Text("Register", style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      ],
    );
  }

  Widget inputStyle(String title, String helpText,
      TextEditingController controller, String? Function(String?)? validator) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 5, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3))
                ]),
            child: SizedBox(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 10),
                    hintText: helpText),
                validator: validator,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be atleast 8 characters';
    }
    return null;
  }
}

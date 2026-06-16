import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});

@override
State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

final emailController = TextEditingController();
final passwordController = TextEditingController();

final AuthService authService = AuthService();

bool isLoading = false;

Future<void> login() async {


try {

  setState(() {
    isLoading = true;
  });

  await authService.login(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
  );

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    ),
  );

} catch (e) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(e.toString()),
    ),
  );

}

setState(() {
  isLoading = false;
});


}

@override
Widget build(BuildContext context) {


return Scaffold(

  appBar: AppBar(
    title: const Text("Login"),
  ),

  body: Padding(

    padding: const EdgeInsets.all(20),

    child: Column(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Email",
          ),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Password",
          ),
        ),

        const SizedBox(height: 30),

        SizedBox(

          width: double.infinity,

          child: ElevatedButton(

            onPressed: isLoading ? null : login,

            child: isLoading
                ? const CircularProgressIndicator()
                : const Text("LOGIN"),

          ),

        ),

        const SizedBox(height: 20),

        TextButton(

          onPressed: () {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (context) => const SignupScreen(),

              ),

            );

          },

          child: const Text(
            "Don't have an account? Sign Up",
          ),

        ),

      ],

    ),

  ),

);


}

}

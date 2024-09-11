import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_project/blocs/login_bloc.dart';
import 'package:your_project/repositories/auth_repository.dart';
import 'package:your_project/ui/routes.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PoPup Event Login')),
      body: BlocProvider(
        create: (context) => LoginBloc(authRepository: AuthRepository()),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Navigate to the Home Page after login
          Navigator.pushReplacementNamed(context, AppRoutes.home);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login Success: ${state.user.email}'),
          ));
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login Failed: ${state.error}'),
          ));
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sign in to PoPup Event'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<LoginBloc>().add(LoginWithGooglePressed());
              },
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

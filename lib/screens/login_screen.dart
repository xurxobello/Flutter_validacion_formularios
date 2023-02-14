import 'package:flutter/material.dart';
import 'package:flutter_validacion_formularios/providers/login_form_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_validacion_formularios/user_interface/input_decorations.dart';
import 'package:flutter_validacion_formularios/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          CardContainer(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text('Login', style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 30),

                // sólo lo que está dentro de _LoginForm tendrá acceso a LoginFormProvider
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: _LoginForm(),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text('Crear una cuenta nueva',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    // ahora con loginForm tendremos acceso a todo lo que la clase LoginFormProvider nos ofrezca, como por ejemplo la key
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'john.doe@gmail.com',
                    labelText: 'Correo electrónico',
                    prefixIcon: Icons.alternate_email_rounded),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Los datos no se corresponden con un email';
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '*****',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe tener al menos 6 caracteres';
                },
              ),
              SizedBox(height: 30),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Espere...' : 'Entrar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: Colors.deepPurple,
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          if (!loginForm.isValidForm()) return;

                          loginForm.isLoading = true;

                          // hacemos el future para poder ver el Espere... durante dos segundos
                          await Future.delayed(Duration(seconds: 2));

                          loginForm.isLoading = false;

                          Navigator.pushReplacementNamed(context, 'home');
                        }),
            ],
          )),
    );
  }
}

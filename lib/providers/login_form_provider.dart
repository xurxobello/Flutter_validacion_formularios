import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  // GlobalKey necesita un State, en este caso como la key está dentro de un form va a ser un FormState, si la key estuviese dentro de un scaffold entonces sería ScaffoldState
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());
    return formKey.currentState?.validate() ?? false;
  }
}

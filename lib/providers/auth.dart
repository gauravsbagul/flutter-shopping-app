import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signUp(String email, String password) async {
    print('PASSWORD: $password');
    print('EMAIL: $email');
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAI3RJuJ9vyvt3brGJ0mG-x3EVwyfsn5eY';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(json.decode(response.body));
      print('prettyprint: $prettyprint');
    } catch (error) {
      print('ERROR: ${error.toString()}');
    }
  }

  Future<void> signIn(String email, String password) async {
    print('PASSWORD: $password');
    print('EMAIL: $email');
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAI3RJuJ9vyvt3brGJ0mG-x3EVwyfsn5eY';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(json.decode(response.body));
      print('prettyprint: signIn  $prettyprint');
    } catch (error) {
      print('ERROR: ${error.toString()}');
    }
  }
}

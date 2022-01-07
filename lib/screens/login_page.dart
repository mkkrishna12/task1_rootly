import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:task1_rootly/screens/pain_screen.dart';
import 'package:task1_rootly/screens/registration_page.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pain Measurement App'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              // Container(
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.all(10),
              //   child: const Text(
              //     'Task 1',
              //     style: TextStyle(
              //         color: Colors.blue,
              //         fontWeight: FontWeight.w500,
              //         fontSize: 30),
              //   ),
              // ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email Id',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  //forgot password screen
                },
                textColor: Colors.blue,
                child: const Text(''),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: const Text('Login'),
                    onPressed: () async {
                      setState(() {
                        _showSpinner = true;
                      });
                      try {
                        final _user = await _auth.signInWithEmailAndPassword(
                            email: nameController.text,
                            password: passwordController.text);
                        if (_user != null) {
                          Navigator.pushNamed(context, PainScreen.id);
                        } else {
                          print('invalid cred.');
                        }
                        setState(() {
                          _showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                        setState(() {
                          _showSpinner = false;
                        });
                      }
                    },
                  )),
              Container(
                child: Row(
                  children: <Widget>[
                    const Text('Does not have account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RegistrationPage.id);
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

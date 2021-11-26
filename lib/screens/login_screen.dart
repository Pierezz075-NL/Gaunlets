// SCREENS
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_setup/model/user_model.dart';
import 'package:firebase_setup/screens/create-character/character.dart';
import 'package:firebase_setup/screens/home_screen.dart';
import 'package:firebase_setup/screens/registration_screen.dart';

// GENERAL
import 'package:flutter/material.dart';

// FIREBASE
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // Firebase setup
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        errorStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    // Password Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password (Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        errorStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    // Login Button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/bg-gradient.jpeg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 150,
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 45),
                          emailField,
                          SizedBox(height: 25),
                          passwordField,
                          SizedBox(height: 45),
                          loginButton,
                          SizedBox(height: 45),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account? "),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationPage()));
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
              )),
            ),
          ),
        ));
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                newUser(uid, context)
          }).catchError((e) {
            Fluttertoast.showToast(msg: e!.message, timeInSecForIosWeb: 2);
          });
    }
  }
}

void newUser(currentUser, context) async {
  User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then((value) {
        var currentUser = UserModel.fromMap(value.data());
        if(currentUser.teamName == ''){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CharacterCreate()));
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
        }
  });
}
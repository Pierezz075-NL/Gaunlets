import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_setup/model/user_model.dart';
import 'package:flutter/material.dart';

import './../home_screen.dart';

class CharacterCreate extends StatefulWidget {
  const CharacterCreate({Key? key}) : super(key: key);

  @override
  _CharacterCreateState createState() => _CharacterCreateState();
}

class SelectedColor {
  String strColor;
  var isSelected = false;

  SelectedColor(this.strColor, this.isSelected);
}

class SelectedIcon {
  String strIcon;
  var isSelected = false;

  SelectedIcon(this.strIcon, this.isSelected);
}

class _CharacterCreateState extends State<CharacterCreate> {
  final _auth = FirebaseAuth.instance;

  String userColorText = "...";
  String userIconText = "...";

  @override
  Widget build(BuildContext context) {
    List _arrColorList = [
      {'color': Colors.blue, 'name': 'Red'},
      {'color': Colors.yellow, 'name': 'Yellow'},
      {'color': Colors.purple, 'name': 'Purple'},
      {'color': Colors.black, 'name': 'Black'},
      {'color': Colors.brown, 'name': 'Brown'},
      {'color': Colors.pink, 'name': 'Pink'},
    ];
    List _iconTypes = [
      {'icon': Icons.face, 'name': 'Bulletreign'},
      {'icon': Icons.flutter_dash, 'name': 'Antimania'},
      {'icon': Icons.api, 'name': 'Crossnite'},
      {'icon': Icons.anchor, 'name': 'Fireshot'},
      {'icon': Icons.outlet, 'name': 'Deadsite'},
      {'icon': Icons.sentiment_satisfied, 'name': 'Borderdroid'},
      {'icon': Icons.mood, 'name': 'Clusterborne'},
      {'icon': Icons.sentiment_neutral, 'name': 'Dragonsite'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Choose your clan color",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: _arrColorList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                      setState(() {
                          userColorText = _arrColorList[index]['name'];
                      });
                  },
                  child: Container(
                    color: _arrColorList[index]['color'],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Choose your clan icon",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: _iconTypes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                      setState(() {
                          userIconText = _iconTypes[index]['name'];
                      });
                  },
                  child: Container(
                    child: 
                      // Icon(_iconTypes[index]['icon']),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.black,
                        child: Icon(_iconTypes[index]['icon'],),
                      ),
                  )
                );
              },
            ),
          ),
          SizedBox(
            height: 45,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Your username is:",
                  style: TextStyle(fontSize: 20),
                ),
                Text(userColorText + ' ' +  userIconText,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 45,
          ), 
          
          ActionChip(
            label: CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              child: Text('Save')
            ),
            backgroundColor: Colors.transparent,
            onPressed: () {
              var teamName = userColorText + ' ' +  userIconText;
              postDetailsToFirestore(teamName);
            },
          ),           
        ],
      ),
    );
  }

  postDetailsToFirestore(teamName) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    print(user);

    UserModel userModel = UserModel();

    // writing all the values
    userModel.uid = user!.uid;
    userModel.teamName = teamName;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}

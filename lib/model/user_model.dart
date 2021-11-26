class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? elemental;
  String? emotion;
  String? teamName;
  String? userName;

  UserModel({
    this.uid, 
    this.email, 
    this.firstName, 
    this.secondName, 
    this.elemental, 
    this.emotion,
    this.teamName,
    this.userName,
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      elemental: map['elemental'],
      emotion: map['emotion'],
      teamName: map['teamName'],
      userName: map['teamName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'elemental': elemental,
      'emotion': emotion,
      'teamName': teamName,
      'userName': userName,
    };
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Validate {
  //Check if email is a Hofstra Email
  bool validateEmailField(String email) {
    RegExp emailRegex = RegExp("[A-Za-z0-9._]+@(pride.)?hofstra.edu");
    return emailRegex.hasMatch(email);
  }

  Future<bool> validateHofID(String hofID) async {
    RegExp emailRegex = RegExp("(h|H)70[0-9]{7}");
    var snapshot = FirebaseFirestore.instance
        .collection("users")
        .where('hofid', isEqualTo: hofID)
        .get();
    //check if
    return emailRegex.hasMatch(hofID);
  }

  //firebase will actually do this
  bool validatePassword(String password) {
    return true;
  }

  bool validateISBN(String password) {
    return true;
  }

  bool validatePrice(String price) {
    return true;
  }

  bool validatePost(String price) {
    return true;
  }
}

main() {
  Validate v = Validate();
  print(v.validateEmailField("7@gmail.com"));
  print(v.validateHofID("h702896277"));
}

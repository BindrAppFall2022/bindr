import 'package:cloud_firestore/cloud_firestore.dart';

class Validate {
  //Check if email is a Hofstra Email
  bool validateEmailField(String email) {
    RegExp emailRegex = RegExp("^[A-Za-z0-9._]+@(pride.)?hofstra.edu\$");
    return emailRegex.hasMatch(email);
  }

  Future<bool> validateHofID(String hofID) async {
    RegExp emailRegex = RegExp("^(h|H)70[0-9]{7}\$");
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

  bool validateISBN(String? isbn) {
    if (isbn is String) {
      RegExp isbnRegex = RegExp("^(([0-9]{13})|([0-9]{10}))\$");
      if (isbnRegex.hasMatch(isbn)) {
        return true;
      }
    }
    return false;
  }

  bool validatePrice(String? price) {
    if (price is String && price != "") {
      RegExp priceRegex = RegExp("^[0-9]{1,4}([.][0-9]+)?\$");
      if (priceRegex.hasMatch(price)) {
        return true;
      }
    }
    return false;
  }

  bool validateTitle(String? title) {
    if (title is String && title.length >= 5) {
      return true;
    }
    return false;
  }
}

main() {
  Validate v = Validate();
  // print(v.validateEmailField("7@gmail.com"));
  // print(v.validateHofID("h702896277"));
  //print(v.validateISBN("1234567890"));
  //print(v.validatePrice("12345"));
}

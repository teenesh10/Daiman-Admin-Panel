class Admin {
  String adminID;
  String email;

  Admin({
    required this.adminID,
    required this.email,
  });

  // Convert a Firebase DocumentSnapshot into an Admin object
  factory Admin.fromDocumentSnapshot(Map<String, dynamic> data, String documentId) {
    return Admin(
      adminID: documentId,
      email: data['email'],
    );
  }

  // Convert an Admin object into a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }
}

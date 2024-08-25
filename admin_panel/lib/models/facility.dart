class Facility {
  String facilityID;
  String facilityName;
  int capacity;
  String description;

  Facility({
    required this.facilityID,
    required this.facilityName,
    required this.capacity,
    required this.description,
  });

  // Convert a Firebase DocumentSnapshot into an Facility object
  factory Facility.fromDocumentSnapshot(
      Map<String, dynamic> data, String documentId) {
    return Facility(
      facilityID: documentId,
      facilityName: data['facilityName'],
      capacity: data['capacity'],
      description: data['description'],
    );
  }

  // Convert an Facility object into a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'facilityName': facilityName,
      'capacity': capacity,
      'description': description,
    };
  }
}

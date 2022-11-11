class Doctor {
  final String firstName;
  final String lastName;
  final String image;
  final String type;
  final double rating;

  Doctor({
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.type,
    required this.rating,
  });
}

class DoctorModel {
  String? uid;
  String? name;
  String? address;
  String? email;
  String? experience;
  String? specialist;
  String? password;
  String? description;
  String? phone;
  String? rating;
  var profileImage;

  DoctorModel({
    this.uid,
    this.name,
    this.address,
    this.email,
    this.experience,
    this.specialist,
    this.password,
    this.description,
    this.phone,
    this.rating,
    this.profileImage,
  });

//reciving data from server
  factory DoctorModel.fromMap(map) {
    return DoctorModel(
      uid: map['uid'],
      name: map['name'],
      address: map['address'],
      email: map['email'],
      experience: map['experience'],
      specialist: map['specialist'],
      password: map['password'],
      description: map['description'],
      phone: map['phone'],
      profileImage: map['profileImage'],
      rating: map['rating'],
    );
  }

//sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'address': address,
      'email': email,
      'experience': experience,
      'specialist': specialist,
      'password': password,
      'description': description,
      'phone': phone,
      'profileImage': profileImage,
      'rating': rating,
    };
  }
}

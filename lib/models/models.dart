class UserData {
  final String? uid;
  final String? firstName;
  final bool? isAdmin;
  final String? family;
  final String? email;

  UserData({this.uid, this.firstName, this.isAdmin, this.family, this.email});

  factory UserData.initialData() {
    return UserData(
      uid: '',
      email: '',
      firstName: '',
      family: '',
      isAdmin: null,
    );
  }

  factory UserData.error() {
    return UserData(
      firstName: 'Error',
    );
  }
}

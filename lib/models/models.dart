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
}

// class DocumentData {
//   late final docBody;
//   final String? docTitle;
//   final String? docID;
//   final String? type;
//   final bool? isPrivate;
//
//   DocumentData(
//       {this.docBody, this.docTitle, this.docID, this.type, this.isPrivate});
//
//   factory DocumentData.initialData() {
//     return DocumentData(
//       docID: '',
//       docTitle: '',
//       isPrivate: false,
//       type: '',
//       docBody: '',
//     );
//   }
// }

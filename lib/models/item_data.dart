import 'item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
var loggedInUser;

// class ItemData extends ChangeNotifier {
//   void itemStatus(SingleItem currentItem) {
//     final currentUser = _auth.currentUser;
//     if (currentUser != null) {
//       loggedInUser = currentUser;
//
//       Future<bool> getItemStatus() async {
//         DocumentReference userRef = db
//             .collection('users')
//             .doc(loggedInUser.uid)
//             .collection('lists')
//             .doc();
//         late bool isDone;
//         await userRef.get().then((snapshot) {
//           if (snapshot.data() != null) {
//             isDone = snapshot['isDone'];
//           }
//         });
//         return isDone;
//       }
//
//       getItemStatus();
//     }
//   }
//
//   void updateItem(SingleItem currentItem) {
//     currentItem.toggleDone();
//     notifyListeners();
//   }
// }

import '../models/event_detail.dart';
import '../models/favourite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<List<Favourite>> getUserFavourites(String uid) async {
    List<Favourite> favs = [];
    QuerySnapshot docs =
        await db.collection('favourites').where('userId', isEqualTo: uid).get();
    if (docs != null) {
      for (DocumentSnapshot doc in docs.docs) {
        favs.add(Favourite.map(doc));
      }
    }
    return favs;
  }

  static Future addFavourite(EventDetail eventDetail, String uid) async {
    Favourite fav = Favourite(null, uid, eventDetail.id);
    var result = await db
        .collection('favourites')
        .add(fav.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return result;
  }

  static Future deleteFavourite(String favID) async {
    await db.collection('favourites').doc(favID).delete();
  }
}

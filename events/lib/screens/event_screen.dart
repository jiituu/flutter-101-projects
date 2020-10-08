import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/event_detail.dart';
import 'package:events/models/favourite.dart';
import 'package:events/screens/login_screen.dart';
import 'package:events/shared/authentication.dart';
import 'package:events/shared/firestore_helper.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  final String uid;

  EventScreen(this.uid);

  @override
  Widget build(BuildContext context) {
    final Authentication auth = Authentication();
    return Scaffold(
        appBar: AppBar(
          title: Text('Event'),
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  auth.signOut().then((result) => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen())));
                })
          ],
        ),
        body: EventList(uid));
  }
}

class EventList extends StatefulWidget {
  final String uid;

  EventList(this.uid);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  _EventListState();

  List<Favourite> favourites = [];

  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<EventDetail> details = [];

  @override
  void initState() {
    getDetailsList().then((data) {
      setState(() {
        details = data;
      });
    });

    FirestoreHelper.getUserFavourites(widget.uid).then((data) {
      favourites = data;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (details != null) ? details.length : 0,
      itemBuilder: (context, position) {
        String sub =
            'Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}';
        Color starColor = (isUserFavourite(details[position].id)
            ? Colors.amber
            : Colors.grey);

        return ListTile(
          title: Text(details[position].description),
          subtitle: Text(sub),
          trailing: IconButton(
            icon: Icon(Icons.star, color: starColor),
            onPressed: () {
              toggleFavourite(details[position]);
            },
          ),
        );
      },
    );
  }

  Future<List<EventDetail>> getDetailsList() async {
    var data = await db.collection('event_details').get();
    int i = 0;
    if (data != null) {
      details = data.docs.map((document) {
        return EventDetail.fromMap(document);
      }).toList();
      details.forEach((detail) {
        detail.id = data.docs[i].id;
        i++;
      });
    }
    return details;
  }

  toggleFavourite(EventDetail ed) async {
    if (isUserFavourite(ed.id)) {
      Favourite favourite =
          favourites.firstWhere((Favourite f) => (f.eventId == ed.id));
      String favId = favourite.id;
      await FirestoreHelper.deleteFavourite(favId);
    } else {
      await FirestoreHelper.addFavourite(ed, widget.uid);
    }
    List<Favourite> updatedFavourites =
        await FirestoreHelper.getUserFavourites(widget.uid);
    setState(() {
      favourites = updatedFavourites;
    });
  }

  bool isUserFavourite(String eventId) {
    Favourite favourite = favourites.firstWhere(
        (Favourite f) => (f.eventId == eventId),
        orElse: () => null);

    if (favourite == null)
      return false;
    else
      return true;
  }
}

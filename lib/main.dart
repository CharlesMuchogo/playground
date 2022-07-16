// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pool/bottom.dart';
import 'package:pool/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      //darkTheme: ThemeData.dark(),

      debugShowCheckedModeBanner: false,
      home: Details(),
    ),
  );
}

class Details extends StatefulWidget {
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final CollectionReference _details =
      FirebaseFirestore.instance.collection('details');
  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    controller: searchcontroller,
                  ),
                ),
                IconButton(
                    onPressed: (() {
                      setState(() {
                        searchcontroller.text =
                            searchcontroller.text.toLowerCase();
                      });
                    }),
                    icon: Icon(Icons.search))
              ],
            ),
          ),
          search(searchcontroller.text),
        ],
      ),
    );
  }
}

Widget search(String keyword) {
  return Column(
    children: [
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection("details").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModalBottomSheet()),
                      ); //
                    },
                    child: Text("Click me please")),
                ...(streamSnapshot.data!.docs
                    .where(
                  (QueryDocumentSnapshot<Object?> element) =>
                      element["email"].toString().contains(keyword),
                )
                    .map(
                  (QueryDocumentSnapshot<Object?> data) {
                    return user_details(
                        "Email", Icons.email_outlined, data["email"]);
                  },
                )),
                // user_details("Email", Icons.email_outlined,
                //   documentSnapshot["email"]),
                // user_details("Name", Icons.person_outline,
                //   documentSnapshot["name"]),
                //user_details("phoneNumber", Icons.phone,
                //    documentSnapshot["phone number"]),
              ],
            );
          }
          return Container();
        },
      ),
    ],
  );
}

Widget user_details(String Title, IconData icon, String Subtitle) {
  return ListTile(
    leading: Icon(icon),
    title: Text(Title),
    subtitle: Text(Subtitle),
  );
}

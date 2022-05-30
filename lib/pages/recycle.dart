import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api.dart';
import '../assets/recyclePoint.dart';
import '../config.dart';

class addRecycledItems extends StatefulWidget {
  const addRecycledItems({
    super.key,
    required this.id,
    required this.plastic,
    required this.hartie,
    required this.sticla,
    required this.location,
  });

  final String id;
  final double plastic, hartie, sticla;
  final LatLng location;

  @override
  State<addRecycledItems> createState() => _addRecycledItemsState();
}

class _addRecycledItemsState extends State<addRecycledItems> {
  late double _recycledPlastic = 0;
  late double _recycledSticla = 0;
  late double _recycledHartie = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Spune-ne cât vrei să reciclezi",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "(în ambalaje)",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Slider(
              activeColor: Colors.amber,
              inactiveColor: Colors.amberAccent,
              value: _recycledPlastic,
              max: (1 - widget.plastic) * 100,
              divisions: 100,
              label: _recycledPlastic.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _recycledPlastic = value;
                });
              },
            ),
            const Text(
              "Plastic",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              activeColor: Colors.brown,
              inactiveColor: Colors.brown,
              value: _recycledHartie,
              max: (1 - widget.hartie) * 100,
              divisions: 100,
              label: _recycledHartie.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _recycledHartie = value;
                });
              },
            ),
            const Text(
              "Hartie",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              inactiveColor: Colors.blueAccent,
              value: _recycledSticla,
              max: (1 - widget.sticla) * 100,
              divisions: 100,
              label: _recycledSticla.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _recycledSticla = value;
                });
              },
            ),
            const Text(
              "Sticla",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            MaterialButton(
              onPressed: () async {
                var awaitPointData = await ApiClient.database.listDocuments(
                  collectionId: Config.recyclePointsID,
                  queries: [Query.equal("id", widget.id)],
                );
                var recyclePointData = awaitPointData.documents
                    .map((document) => recyclePoint.fromJson(document.data))
                    .first;
                recyclePointData.statPlastic += _recycledPlastic.round() / 100;
                recyclePointData.statHartie += _recycledHartie.round() / 100;
                recyclePointData.statSticla += _recycledSticla.round() / 100;
                var mapOfData = recyclePointData.toMap();
                await ApiClient.database.updateDocument(collectionId: Config.recyclePointsID, documentId: recyclePointData.docID, data: mapOfData);
                String gmapsLink =
                    'https://www.google.com/maps/search/?api=1&query=${widget.location.latitude},${widget.location.longitude}';
                await launchUrl(Uri.parse(gmapsLink));
              },
              elevation: 0,
              height: 35,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                "Reciclează acum!",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

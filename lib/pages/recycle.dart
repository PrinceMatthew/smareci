import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:percent_indicator/percent_indicator.dart';

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

  final int id;
  final int plastic, hartie, sticla;
  final LatLng location;

  @override
  State<addRecycledItems> createState() => _addRecycledItemsState();
}

class _addRecycledItemsState extends State<addRecycledItems> {
  late int _recycledPlastic = 0;
  late int _recycledSticla = 0;
  late int _recycledHartie = 0;
  late double _progressPlastic = 0, _progressSticla = 0, _progressHartie = 0;
  late String _objectType = '';
  TextEditingController _objectVolume = TextEditingController();

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
              "Scanează codurile produselor",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            MaterialButton(
              onPressed: () {},
              elevation: 0,
              height: 35,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                "Scanează",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              "sau",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "introdu manual detaliile",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 100,
                    child: DropdownButtonFormField(
                      hint: _objectType == ''
                          ? const Text("Material")
                          : Text(_objectType),
                      items: ["Carton", "Plastic", "Sticlă"].map(
                        (value) {
                          return DropdownMenuItem<String>(
                            child: Text(value),
                            value: value,
                          );
                        },
                      ).toList(),
                      decoration:
                          InputDecoration(contentPadding: EdgeInsets.zero),
                      onChanged: (value) {
                        if (value is String) {
                          setState(() {
                            _objectType = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: SizedBox(
                    width: 70,
                    child: TextFormField(
                      controller: _objectVolume,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 14),
                        alignLabelWithHint: true,
                        labelText: "Volum",
                        hintText: "În mL",
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            MaterialButton(
              onPressed: () {

              },
              elevation: 0,
              height: 35,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                "Adaugă",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: LinearPercentIndicator(
               percent: _progressHartie,
               leading: Text("Carton"),
             ),
           ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearPercentIndicator(
                percent: _progressPlastic,
                leading: Text("Plastic"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearPercentIndicator(
                percent: _progressSticla,
                leading: Text("Sticlă"),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            MaterialButton(
              onPressed: () async {
                if (_recycledHartie == 0 &&
                    _recycledSticla == 0 &&
                    _recycledPlastic == 0) {
                  return;
                }
                var awaitPointData = await ApiClient.database.listDocuments(
                  collectionId: Config.recyclePointsID,
                  queries: [Query.equal("id", widget.id)],
                );
                var recyclePointData = awaitPointData.documents
                    .map((document) => recyclePoint.fromJson(document.data))
                    .first;
                recyclePointData.statPlastic += _recycledPlastic;
                recyclePointData.statHartie += _recycledHartie;
                recyclePointData.statSticla += _recycledSticla;
                var mapOfData = recyclePointData.toMap();
                await ApiClient.database.updateDocument(
                    collectionId: Config.recyclePointsID,
                    documentId: recyclePointData.docID,
                    data: mapOfData);
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

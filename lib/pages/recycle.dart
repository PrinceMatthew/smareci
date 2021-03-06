import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smareci/models/object.dart';
import 'package:smareci/pages/thankyou.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api.dart';
import '../config.dart';
import '../models/recyclePoint.dart';

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
  late int _availablePlastic = widget.plastic;
  late int _availableSticla = widget.sticla;
  late int _availableCarton = widget.hartie;
  late int _progressPlastic = 0, _progressSticla = 0, _progressCarton = 0;
  late double _percentPlastic = 0, _percentSticla = 0, _percentCarton = 0;
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
              onPressed: () async {
                String? objectCode;
                try {
                  objectCode = await FlutterBarcodeScanner.scanBarcode(
                      "#ff6666", "Înapoi", false, ScanMode.BARCODE);
                } on PlatformException {
                  objectCode = 'Failed to scan code';
                }
                if (!mounted) return;
                var awaitObjectData = await ApiClient.database.listDocuments(
                  collectionId: Config.objectCodesID,
                  queries: [Query.equal("barcode", objectCode)],
                );
                if (awaitObjectData.total == 0) {
                  var snack = SnackBar(
                    content: Text("Obiectul nu a fost găsit în baza de date!"),
                    duration: Duration(seconds: 1),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                  return;
                }
                var recycledObjectData = awaitObjectData.documents
                    .map((document) => RecycledObject.fromJson(document.data))
                    .first;
                if (recycledObjectData.type == "Plastic") {
                  _progressPlastic += recycledObjectData.volume;
                  _availablePlastic -= recycledObjectData.volume;
                  setState(() {
                    _percentPlastic = _progressPlastic / _availablePlastic;
                  });
                } else if (recycledObjectData.type == "Carton") {
                  _progressCarton += recycledObjectData.volume;
                  _availableCarton -= recycledObjectData.volume;
                  setState(() {
                    _percentCarton = _progressCarton / _availableCarton;
                  });
                } else if (recycledObjectData.type == "Sticlă") {
                  _progressSticla += recycledObjectData.volume;
                  _availableSticla -= recycledObjectData.volume;
                  setState(() {
                    _percentSticla = _progressSticla / _availableSticla;
                  });
                }
                var snack = SnackBar(
                  content: Text("Obiectul scanat a fost adăugat!"),
                  duration: Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snack);
              },
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
                        contentPadding: EdgeInsets.only(bottom: 12),
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
                int? _objectVolumeInt = int.tryParse(_objectVolume.text);
                if (_objectType == 'Carton') {
                  if (_availableCarton >= _objectVolumeInt!) {
                    _progressCarton += _objectVolumeInt;
                    _availableCarton -= _objectVolumeInt;
                    setState(() {
                      _percentCarton = _progressCarton / widget.hartie;
                    });
                    const snack = SnackBar(
                      content: Text("Adăugat in lista de reciclare!"),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  } else {
                    var snack = SnackBar(
                      content: Text("Volum prea mare! Disponibili doar " +
                          _availableCarton.toString() +
                          " mL."),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                } else if (_objectType == 'Plastic') {
                  if (_availablePlastic >= _objectVolumeInt!) {
                    _progressPlastic += _objectVolumeInt;
                    _availablePlastic -= _objectVolumeInt;
                    setState(() {
                      _percentPlastic = _progressPlastic / widget.plastic;
                    });
                    const snack = SnackBar(
                      content: Text("Adăugat in lista de reciclare!"),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  } else {
                    var snack = SnackBar(
                      content: Text("Volum prea mare! Disponibili doar " +
                          _availablePlastic.toString() +
                          " mL."),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                } else if (_objectType == 'Sticlă') {
                  if (_availableSticla >= _objectVolumeInt!) {
                    _progressSticla += _objectVolumeInt;
                    _availableSticla -= _objectVolumeInt;
                    setState(() {
                      _percentSticla = _progressSticla / widget.sticla;
                    });
                    const snack = SnackBar(
                      content: Text("Adăugat in lista de reciclare!"),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  } else {
                    var snack = SnackBar(
                      content: Text("Volum prea mare! Disponibili doar " +
                          _availableSticla.toString() +
                          " mL."),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                }
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
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
                percent: _percentCarton,
                leading: Text("Carton/Hârtie"),
                progressColor: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearPercentIndicator(
                percent: _percentPlastic,
                leading: Text("Plastic/Metal"),
                progressColor: Colors.yellow,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearPercentIndicator(
                percent: _percentSticla,
                leading: Text("Sticlă"),
                progressColor: Colors.green,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            MaterialButton(
              onPressed: () async {
                if (_progressSticla == 0 &&
                    _progressPlastic == 0 &&
                    _progressCarton == 0) {
                  return;
                }
                var awaitPointData = await ApiClient.database.listDocuments(
                  collectionId: Config.recyclePointsID,
                  queries: [Query.equal("pointID", widget.id)],
                );
                var recyclePointData = awaitPointData.documents
                    .map((document) => RecyclePoint.fromJson(document.data))
                    .first;
                recyclePointData.statPlastic += _progressPlastic;
                recyclePointData.statHartie += _progressCarton;
                recyclePointData.statSticla += _progressSticla;
                var mapOfData = recyclePointData.toMap();
                await ApiClient.database.updateDocument(
                    collectionId: Config.recyclePointsID,
                    documentId: recyclePointData.docID,
                    data: mapOfData);
                String gmapsLink =
                    'https://www.google.com/maps/search/?api=1&query=${widget.location.latitude},${widget.location.longitude}';
                await launchUrl(Uri.parse(gmapsLink));
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ThankYou()));
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

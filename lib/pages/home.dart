import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smareci/assets/map_styles.dart';
import 'package:smareci/assets/recycle_points.dart';
import 'package:smareci/pages/recycle.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {};

  static const CameraPosition _kBucharest = CameraPosition(
    target: LatLng(44.439663, 26.096306),
    zoom: 10.8,
  );

  @override
  Widget build(BuildContext context) {
    createMarkers(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _kBucharest,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              controller.setMapStyle(MapStyle().night);
            },
          ),
          Positioned(
            top: 40,
            child: Column(
              children: [
                Text(
                  "Smareci",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                Text(
                  "Selectează un punct pentru a recicla",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  createMarkers(BuildContext context) {
    Marker marker;

    recyclePoints.forEach((point) async {
      marker = Marker(
        markerId: MarkerId(point['id']),
        position: point['position'],
        infoWindow: InfoWindow(
          title: point['name'],
          snippet: "Apasă pentru detalii",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => RecyclePage(id: point["id"], name: point["name"],)));
          },
        ),
      );

      setState(() {
        _markers.add(marker);
      });
    });
  }
}

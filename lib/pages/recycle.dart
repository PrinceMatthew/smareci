import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smareci/api.dart';
import 'package:smareci/assets/recyclePoint.dart';
import 'package:smareci/config.dart';
import 'package:url_launcher/url_launcher.dart';

class RecyclePage extends StatefulWidget {
  const RecyclePage({super.key, required this.id, required this.name});

  final String id, name;

  @override
  State<RecyclePage> createState() => _RecyclePageState();
}

class _RecyclePageState extends State<RecyclePage> {
  late Future getRecyclePointDataFuture;

  @override
  void initState() {
    super.initState();
    getRecyclePointDataFuture = _getRecyclePointData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text("Grad de ocupare al punctului de reciclare"),
            SizedBox(
              height: 32,
            ),
            FutureBuilder(
              future: getRecyclePointDataFuture,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  recyclePoint data = snapshot.data;
                  return Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: data.statPlastic,
                        animation: true,
                        center: Text("Plastic/Metal"),
                        progressColor: Colors.yellowAccent,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: data.statSticla,
                        animation: true,
                        center: Text("Sticlă"),
                        progressColor: Colors.blueAccent,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: data.statHartie,
                        animation: true,
                        center: Text("Hârtie/Carton"),
                        progressColor: Colors.brown,
                      ),
                    ],
                  );
                }
                return Column(
                  children: const [
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                        strokeWidth: 3,
                      ),
                    )
                  ],
                );
              },
            ),
            SizedBox(
              height: 32,
            ),
            MaterialButton(
              onPressed: () async {
                await launchUrl(Uri.parse(
                    "https://hartareciclarii.ro/cum-reciclez/14-obiecte-care-credeai-ca-se-recicleaza/"));
              },
              elevation: 0,
              height: 35,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                "Vezi ce nu poate fi reciclat",
                style: TextStyle(color: Colors.black),
              ),
            ),
            MaterialButton(
              onPressed: () {},
              elevation: 0,
              height: 35,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                "Vreau să reciclez!",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<recyclePoint?> _getRecyclePointData() async {
    try {
      var awaitPointData = await ApiClient.database.listDocuments(
        collectionId: Config.recyclePointsID,
        queries: [Query.equal("id", widget.id)],
      );
      var recyclePointData = awaitPointData.documents
          .map((document) => recyclePoint.fromJson(document.data))
          .first;
      return recyclePoint(
        statPlastic: recyclePointData.statPlastic,
        statSticla: recyclePointData.statSticla,
        statHartie: recyclePointData.statHartie,
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }
}

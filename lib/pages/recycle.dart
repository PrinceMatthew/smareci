import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class RecyclePage extends StatefulWidget {
  const RecyclePage({super.key, required this.id, required this.name});

  final String id, name;

  @override
  State<RecyclePage> createState() => _RecyclePageState();
}

class _RecyclePageState extends State<RecyclePage> {
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
            SizedBox(height: 32,),
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 10.0,
              percent: 0.8,
              center: new Text("Plastic/Metal"),
              progressColor: Colors.yellowAccent,
            ),
            SizedBox(height: 16,),
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 10.0,
              percent: 0.1,
              center: new Text("Sticlă"),
              progressColor: Colors.blueAccent,
            ),
            SizedBox(height: 16,),
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 10.0,
              percent: 0.45,
              center: new Text("Hârtie/Carton"),
              progressColor: Colors.brown,
            ),
            SizedBox(height: 32,),
            MaterialButton(
              onPressed: () async {
                await launchUrl(Uri.parse("https://hartareciclarii.ro/cum-reciclez/14-obiecte-care-credeai-ca-se-recicleaza/"));
              },
              elevation: 0,
              height: 35,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text("Vezi ce nu poate fi reciclat", style: TextStyle(color: Colors.black),),
            ),
            MaterialButton(
              onPressed: () {},
              elevation: 0,
              height: 35,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text("Vreau să reciclez!", style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}

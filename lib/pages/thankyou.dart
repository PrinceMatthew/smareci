import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class ThankYou extends StatelessWidget {
  const ThankYou({Key? key}) : super(key: key);

  final String recyclePNG = 'assets/thankyou.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(recyclePNG),
              width: 300,
              height: 300,
            ),
            GradientText(
              'Wohoo!',
              style: TextStyle(
                fontSize: 32.0,
              ),
            ),
            Text(
              "Îți mulțumim pentru că ai reciclat",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 150,),
            GradientButton(
              child: Text('Înapoi la hartă'),
              increaseWidthBy: 30,
              callback: () {
                Navigator.of(context).pop();
              },
              gradient: Gradients.backToFuture,
              shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.25),
            ),

          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../services/utils.dart';
class EmptyProdWidget extends StatelessWidget {
  const EmptyProdWidget({Key? key, required this.text}) : super(key: key);
final String text;
  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Image(image: AssetImage(
                'assets/cat/empty box.png'
            ),
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 15,),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class weatherItem extends StatelessWidget {
  const weatherItem({
    Key? key,
    required this.value, required this.text, required this.unit , required this.imageUrl
  });

  final int value;
  final String text;
  final String unit;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
           Text(text, style:  const  TextStyle(
            color: Colors.black54,
          ),),
      
          const SizedBox(
            height: 8
          ),
      
          Container(
            padding: const EdgeInsets.all(20.0),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Color(0xffEDBFB),
              borderRadius: BorderRadius.all(Radius.circular(10)),
      
            ),
            child: Image.asset(imageUrl),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(value.toString() + "km\h" , style: TextStyle(
              fontWeight: FontWeight.bold,
            ),)
        ],
      
    );
  }
}
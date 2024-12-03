import 'package:flutter/material.dart';
import 'package:project_app/models/constants.dart';
import 'package:project_app/ui/welcome.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: myConstants.primaryColor.withOpacity(.5),
        child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Image.asset("assets/get-started (2).png",
              width:300,
              height: 300,),
              const SizedBox(height: 30,),

              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(
                    context, MaterialPageRoute(
                      builder: (context) => const Welcome()));
                },
              
               child: Container(
                height: 40,
                width: size.width*0.4,
                decoration: BoxDecoration(
                  color: myConstants.primaryColor.withOpacity(.6),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                 child: const Center(
                  child: Text('Get Started',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),),
                 ),
              ),
              ),
            ],
            )  ,
            ),
      ),

  );
  }
}
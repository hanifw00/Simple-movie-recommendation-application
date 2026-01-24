
import 'package:amflix/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black ,
      body: Column(
        children: [

           Padding(
             padding: const EdgeInsets.only(top: 140),
             child: Center(
                child: Image.asset("assets/images/launch_icon.png",
                height: 450,
                width: 420,),
              ),
           ),
                    
            SizedBox(
              height:62 ,
              width: 322,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color(0xff1D546D) 
                 ),
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                }, child: 
              
              Text("Mulai",
              style: GoogleFonts.roboto(
                color: Color(0xffF2EDED),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),)),
            )
        ],
      ),
    );
  }
}

import 'package:amflix/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';




class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool isLoading = true;
  Future<UserCredential?> login() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return await FirebaseAuth.instance
          .signInWithCredential(credential);
    } catch (e) {
      debugPrint("Google login error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [        
          
             Center(
               child: Padding(
                 padding: const EdgeInsets.only(top: 80),
                 child: Image.asset("assets/images/logo_splash.png",
                  height:352 ,
                  width: 320,),
               ),
             ),
              

          SizedBox(height: 20,),      
          SizedBox(
            height:52 ,
            width: 340,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3498DB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
              onPressed: (){
                Navigator.pushReplacementNamed(context,AppRoutes.login);
              },
           
             child: Text("Masuk",
             style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
             ),
             )),
          ),

          SizedBox(height: 20,),
           SizedBox(
            height:52 ,
            width: 340,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(               
                foregroundColor: Color(0xff3498DB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                side: BorderSide(
                  color: Color(0xff3498DB)
                )
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(AppRoutes.register);
              },    
             child: Text("Mendaftar",
             style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
              ),
             )
            ),
          ),
          SizedBox(height: 50,),
           SizedBox(
            height: 52,
            width: 340,
            child: OutlinedButton(
             style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xffE74C3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              side: BorderSide(
                color: Color(0xffE74C3C)
              )
             ),
              onPressed: ()async{
                final result = await login();

                if (result != null) {                 
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.home, // atau home
                  );
                } else {                 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login Google dibatalkan"),
                    ),
                  );
                }
              },
             child: Text("Google",
             style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.bold
             ),
             )
             ),
          ),
          
        ],
      ),
    );
  }
}
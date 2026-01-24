import 'package:amflix/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';





class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  bool isLoading = false;
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 118, left: 109, right: 109),
                  child: Image.asset("assets/images/icon.png"),
                ),
        
                SizedBox(height: 40),
                SizedBox(
                  height: 52,
                  width: 322,
                  child: TextField(
                    controller: emailC,
                    style: const TextStyle(color: Color(0xffEEEEEE)),
                    decoration: InputDecoration(
                      fillColor: Color(0xffEEEEEE),
                      hintText: "Email",
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: 25),
                 SizedBox(
                  height: 52,
                  width: 322,
                  child: TextField(
                    controller: passC,
                    obscureText: true,
                    style: const TextStyle(color: Color(0xffEEEEEE)),
                    decoration: InputDecoration(
                      fillColor: Color(0xffEEEEEE),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(height: 62,
                width:322 ,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffBF092F)
                  ),
                  onPressed: () async{
                    setState(() => isLoading = true);                                         
                     try {
                    final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailC.text.trim(),
                          password: passC.text.trim(),
                        );
                        
        
                    if (result.user != null) {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                    }
                  } on FirebaseAuthException catch (e) {
                    String msg = "Email  or Password wrong";
        
                    if (e.code == 'user-not-found') {
                      msg = "Email tidak terdaftar";
                    } else if (e.code == 'wrong-password') {
                      msg = "Password salah";
                    } else if (e.code == 'invalid-email') {
                      msg = "Format email tidak valid";
                    }
        
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));
                  } finally {
                    setState(()=>isLoading = false);
                    }
                  }, child: 
                Text("Masuk",
                style: GoogleFonts.roboto(
                  color: Color(0xffF2EDED),
                  fontWeight: FontWeight.bold
                ),)),),
        
                SizedBox(height: 21,),          
                SizedBox(
                height: 62,
                width:322 ,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1D546D)
                  ),
                  onPressed: () async{
                    setState(() => isLoading = true); // 👈 DI SINI (AWAL)

                    try {
                      final result = await login(); // Google Sign-In

                      if (result != null) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.home,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login Google dibatalkan"),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Gagal login dengan Google"),
                        ),
                      );
                    } finally {
                      setState(() => isLoading = false); // 👈 DI SINI (AKHIR)
                    }
                  },
                  
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/group.png",
                    height: 25,
                    width: 25,),
                    Text("  Google",
                    style: GoogleFonts.roboto(
                      color: Color(0xffEEEEEE),
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                )
              ),
            ),
        
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum Memiliki Akun? ",
                    style: GoogleFonts.roboto(
                      fontSize: 15,     
                      color: Color(0xffFFFFFF)           
                    ),),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushNamed(AppRoutes.register);
                    }, 
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                    child: Text("Daftar ",
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,  
                      color: Color(0xffBF092F)
                    ),)),
                    Text("Disini",
                    style: GoogleFonts.roboto(
                      fontSize: 15,                
                      color: Color(0xffFFFFFF)
                    ),),
                  ],
                ),
                
            ],
          ),
        ),
         if (isLoading)
          Container(
            color: Colors.black87,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
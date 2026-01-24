import 'package:amflix/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  bool isLoading = false;


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
                
                SizedBox(height: 21),
                SizedBox(
                  height: 52,
                  width: 322,
                  child: TextField(
                    obscureText: true,
                    controller: passC,
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
                
                SizedBox(height: 21),
                SizedBox(
                  height: 52,
                  width: 322,
                  child: TextField(
                    obscureText: true,
                    controller: confirmPassC,
                    style: const TextStyle(color: Color(0xffEEEEEE)),
                    decoration: InputDecoration(
                      fillColor: Color(0xffEEEEEE),
                      hintText: "Konfirmasi Password",
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                
              SizedBox(height: 40,),
              SizedBox(
                height: 62,
                width: 322,
                child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffBF092F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                 ),
                 onPressed: () async {
                  if (emailC.text.isEmpty || passC.text.isEmpty || confirmPassC.text.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
                      return;
                    }
                
                    if (passC.text.length < 6) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Password minimal 6 karakter")));
                      return;
                    }
                
                    if (passC.text.trim() != confirmPassC.text.trim()) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Password tidak sama")));
                      return;
                    }
                
                  try {
                    setState(() => isLoading = true);
                    final result = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: emailC.text.trim(),
                          password: passC.text.trim(),
                        );
                
                    if (result.user != null) {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                    }
                
                  } on FirebaseAuthException catch (e) {
                    String msg = "Registration failed. Please try again.";
                
                    if (e.code == 'email-already-in-use') {
                      msg = "Email sudah terdaftar.";
                    } else if (e.code == 'weak-password') {
                      msg = "Password terlalu lemah (min 6 karakter).";
                    } else if (e.code == 'invalid-email') {
                      msg = "Format email tidak valid.";
                    }
                
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));
                  } finally {
                    setState(()=>isLoading = false);
                    }
                
                 },
                 child: Text("Daftar",
                 style: GoogleFonts.roboto(      
                  fontSize: 20,        
                    color: Color(0xffF2EDED),
                    fontWeight: FontWeight.bold
                  ),
                 )
                ),
              ),
                
              SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah Memiliki Akun? ",
                    style: GoogleFonts.roboto(
                      fontSize: 15,     
                      color: Color(0xffFFFFFF)           
                    ),),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushNamed(AppRoutes.login);
                    }, 
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                          child: Text("Masuk ",
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
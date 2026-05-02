import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
      // Password
                bool isPasswordHidden = true; // 👈 add this in State class

  void signup() async {
    
    try {
      setState(() => isLoading = true);

      // 🔥 1. Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
await userCredential.user!
    .updateDisplayName(nameController.text.trim());
      String uid = userCredential.user!.uid;

      // 🔥 2. Realtime Database
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("users/$uid");

      await ref.set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
      });

      setState(() => isLoading = false);

      // ✅ Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signup Successful ✅"),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(Duration(seconds: 1));

      // ✅ Navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(message: "Signup Success ✅"),
        ),
      );

    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication Error")),
      );
    } catch (e) {
      setState(() => isLoading = false);

      print("🔥 REALTIME DB ERROR: $e"); // 👈 debug

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
@override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/sig.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.withOpacity(0.85),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Avatar icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.5),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(Icons.person_add_outlined, color: Colors.white, size: 38),
                ),

                SizedBox(height: 20),

                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Sign up to get started",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),

                SizedBox(height: 32),

                // Glass card
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      // Name field
                      TextField(
                        controller: nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.purpleAccent, width: 1.5),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Email field
                      TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.purpleAccent, width: 1.5),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Password field
                      TextField(
                        controller: passwordController,
                        obscureText: isPasswordHidden,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordHidden
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.purpleAccent, width: 1.5),
                          ),
                        ),
                      ),

                      SizedBox(height: 28),

                      // Sign Up button
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : GestureDetector(
                              onTap: signup,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.deepPurple, Colors.purpleAccent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurple.withOpacity(0.5),
                                      blurRadius: 16,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Login redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
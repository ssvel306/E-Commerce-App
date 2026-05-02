import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signuppage.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  final String? message; // ✅ receive message

  
   const LoginPage({Key? key, this.message}) : super(key: key); // 

  @override
  
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
bool isPasswordHidden = true;
  @override
  void initState() {
    super.initState();

    // ✅ Show message from SignupPage
    if (widget.message != null) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.message!)),
        );
      });
    }
  }

// ✅ NEW login function to go back to Cart page instead of HomeScreen
void login() async {
  try {
    setState(() => isLoading = true);

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    // ✅ GO BACK to previous page (Cart page)
    Navigator.pop(context, true);

    // ✅ Optional: show success (better handled in previous page)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login Success ✅"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );

  } catch (e) {
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login Failed ❌")),
    );
  }
}
  @override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/log.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Login",
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.withOpacity(0.85), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                // Avatar icon circle
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
                  child: Icon(Icons.person_outline, color: Colors.white, size: 40),
                ),

                SizedBox(height: 20),

                Text(
                  "Welcome Back",
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
                  "Login to continue",
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

                      SizedBox(height: 10),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 8),

                      // Login button
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : GestureDetector(
                              onTap: login,
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
                                    "Login",
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

                // Sign up row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignupPage()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
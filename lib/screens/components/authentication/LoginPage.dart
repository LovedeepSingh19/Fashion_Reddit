import 'package:fashion_app/firebase/auth.dart';
import 'package:fashion_app/screens/HomePage.dart';
import 'package:fashion_app/screens/components/authentication/SignUp.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;
  var passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        image: DecorationImage(
          image: AssetImage("assets/Login Page/introduction_image.png"),
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(
          //     AppTheme.backgroundColor.withOpacity(0.5), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Fashion",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 40,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome",
          style: TextStyle(
              color: AppTheme.dark_grey,
              fontSize: 32,
              fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Please login with your information"),
        const SizedBox(height: 60),
        _buildGreyText("Email address"),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.done),
          ),
        ),
        const SizedBox(height: 40),
        _buildGreyText("Password"),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            suffixIcon: InkWell(
              child: const Icon(Icons.remove_red_eye),
              onTap: () => setState(() {
                print(!passwordVisible);
                passwordVisible = !passwordVisible;
              }),
            ),
          ),
          obscureText: passwordVisible,
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        _buildRememberForgot(),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 20),
        _buildOtherLogin(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("Remember me"),
          ],
        ),
        TextButton(
            onPressed: () {}, child: _buildGreyText("I forgot my password"))
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        debugPrint("Email : ${emailController.text}");
        debugPrint("Password : ${passwordController.text}");
        await AuthMethods()
            .loginUser(
                email: emailController.text, password: passwordController.text)
            .then((value) => {
                  if (value == 'success')
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      )
                    }
                  else
                    {print('Login failed')}
                });
        // final GoogleSignInAccount? googleUser =
        //     await GoogleSignIn(scopes: <String>["email"]).signIn();
        // final GoogleSignInAuthentication googleAuth =
        //     await googleUser!.authentication;
        // final credential = GoogleAuthProvider.credential(
        //     accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        // await FirebaseAuth.instance.signInWithCredential(credential);
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: AppTheme.chipBackground,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("LOGIN"),
    );
  }

  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGreyText(
                "Or ",
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

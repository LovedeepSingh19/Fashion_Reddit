import 'package:fashion_app/firebase/auth.dart';
import 'package:fashion_app/screens/HomePage.dart';
import 'package:fashion_app/screens/components/authentication/LoginPage.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/utils.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;
  bool rememberUser = false;
  var passwordVisible = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        phoneNumber: _phoneNumberController.text,
        file: _image!);

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

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
      child: Center(
        child: Stack(
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                    backgroundColor: Colors.black,
                  )
                : InkWell(
                    child: const CircleAvatar(
                      radius: 64,
                      backgroundImage:
                          NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                      backgroundColor: Colors.black,
                    ),
                    onTap: selectImage,
                  ),
            Positioned(
              bottom: -10,
              left: 80,
              child: IconButton(
                onPressed: selectImage,
                icon: const Icon(
                  Icons.add_a_photo,
                  color: AppTheme.lightText,
                ),
              ),
            )
          ],
        ),
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
              fontSize: 30,
              fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Please enter your details for signup"),
        const SizedBox(height: 20),
        _buildGreyText("Username"),
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.done),
          ),
        ),
        const SizedBox(height: 20),
        _buildGreyText("Email address"),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.done),
          ),
        ),
        const SizedBox(height: 20),
        _buildGreyText("Phone Number"),
        TextField(
          controller: _phoneNumberController,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.done),
          ),
        ),
        const SizedBox(height: 20),
        _buildGreyText("Password"),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            suffixIcon: InkWell(
                child: const Icon(Icons.remove_red_eye),
                onTap: () => {
                      setState(() {
                        print(!passwordVisible);
                        passwordVisible = !passwordVisible;
                      }),
                    }),
          ),
          obscureText: passwordVisible,
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        _buildSignUpButton(),
        const SizedBox(height: 20),
        _buildOtherSignUp()
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () async {
        debugPrint("Email : ${_emailController.text}");
        debugPrint("Password : ${_passwordController.text}");
        signUpUser();

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
      child: const Text("SIGNUP"),
    );
  }

  Widget _buildOtherSignUp() {
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
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: const Text(
                  "Login",
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

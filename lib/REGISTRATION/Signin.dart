import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_nest/REGISTRATION/Register.dart';
import '../Controller/signin.dart';
import '../colors.dart';

class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    final provider = Provider.of<SigninProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.c1,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                Image.asset("assets/images/sn.png", scale: 3),
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: provider.emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: AppColors.c4),
                    suffixIcon: const Icon(Icons.email),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  obscureText: provider.isobscuretext,
                  controller: provider.passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: AppColors.c4),
                    suffixIcon: IconButton(
                      icon: Icon(
                        provider.isobscuretext ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: provider.togglePasswordVisibility,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Registration(),));
                      },
                      child: Text(
                        "New User?",
                        style: TextStyle(color: AppColors.c4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.c4,
                  ),
                  onPressed: () {
                    provider.signin(context);
                  },
                  child: provider.isLoading
                      ? CircularProgressIndicator(color: AppColors.c1)
                      : const Text(
                    "SignIn",
                    style: TextStyle(color: AppColors.c1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

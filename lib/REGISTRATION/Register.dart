import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_nest/REGISTRATION/Signin.dart';
import '../Controller/registration.dart';
import '../colors.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.c1,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
          child: Column(
            children: [
              SizedBox(height: height * 0.02),
              Image.asset("assets/images/sn.png", scale: 3),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: provider.usernameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: const TextStyle(color: AppColors.c4),
                  suffixIcon: const Icon(Icons.person),
                ),
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: provider.emailController,
                decoration: InputDecoration(
                  hintText: 'Email address',
                  hintStyle: const TextStyle(color: AppColors.c4),
                  suffixIcon: const Icon(Icons.email),
                ),
              ),
              SizedBox(height: height * 0.02),
              DropdownButtonFormField<String>(
                value: provider.selectedState,
                items: provider.states.map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (newValue) {
                  provider.setSelectedState(newValue);
                },
                decoration: InputDecoration(
                  hintText: 'Location',
                  hintStyle: const TextStyle(color: AppColors.c4),
                  suffixIcon: const Icon(Icons.location_on),
                ),
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: provider.phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  hintStyle: const TextStyle(color: AppColors.c4),
                  suffixIcon: const Icon(Icons.phone),
                ),
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                obscureText: provider.isobscuretext1,
                controller: provider.passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: AppColors.c4),
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.isobscuretext1 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: provider.togglePasswordVisibility1,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                obscureText: provider.isobscuretext,
                controller: provider.confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: const TextStyle(color: AppColors.c4),
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.isobscuretext ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: provider.togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.c4,
                ),
                onPressed: () {
                  provider.register(context: context);
                },

                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: AppColors.c1),
                ),
              ),
              SizedBox(height: height * 0.03),
              TextButton(

                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Signin(),));
                },

                child: Text(
                  "Already have an Account?",
                  style: TextStyle(color: AppColors.c3),
                ),
              ),
              // if (provider.isLoading) CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}

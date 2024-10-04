import 'package:waiz/resources/views/auth_views/login.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../app/http/controllers/auth/auth_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/button.dart';
import '../../widgets/usable_loading.dart';
import '../../widgets/usable_textfield.dart';
import '../home.dart';
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Selected country
  String? _selectedCountry;

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    AuthController authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        leading:  const Padding(
          padding: EdgeInsets.only(left: 8),
         child:  InkWell(

            child: Row(
              children: [
                  Icon(Icons.arrow_back_ios_new_rounded,
                    size: 15,
                  ),
                SizedBox(width: 15,),
                Text('Back')
              ],
            ),
          ),
        ),
      ),
      body:Stack(
     children: [
      Padding(
      padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           const Column(
             // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create An Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  fontFamily: "Ariel"
                ),
                ),
                Gap(10),
                Text("Be sure to provide correct details.",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            const Gap(50),
            // Username field
            UsableTextField(
              controller: _usernameController,
              label: 'Username',
            ),
            const SizedBox(height: 16.0),
            Container(
                height: 70,
                decoration: BoxDecoration(
                  // color: Colors.white60,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyBorderColor.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
            // Country dropdown
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Country',
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(10.0),
                // ),
              ),
              value: _selectedCountry,
              items: ['Nigeria', 'Ghana'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCountry = newValue;
                });
              },
            )),
            const SizedBox(height: 16.0),

            // Email field
            UsableTextField(
              controller: _emailController,
              label: 'Email Address',
              keyboardType: TextInputType.emailAddress,
            ),
           const  SizedBox(height: 16.0),

            // Phone number field
            UsableTextField(
              controller: _phoneController,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16.0),

            // Password field
            UsableTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 32.0),

            const Gap(100),

            // Sign Up button
            primaryButton(context, color: AppColors.primaryColor, title: 'Create Account', onTap: () async {
              await authController.register(
                  username: _usernameController.text,
                  country: _selectedCountry.toString(),
                  phone: _phoneController.text,
                  email: _emailController.text, password: _passwordController.text) ? Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const LoginView(),
              )) : Get.snackbar("Error", "Signup failed. please try again",backgroundColor: Colors.red,colorText: Colors.white);

            }),
             const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Alreaddy Have an account?'
                ),
                InkWell(
                  onTap: () => {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context)=> const LoginView()))
                  },
                  child: const Text("Login"),
                )
              ],
            )
          ],
        ),
      ),
       Obx(() {
         return authController.isLoading.value
             ? const UsableLoading() : Container(); // Show loading animation
       }),
      ]
      ),

    );
  }
}

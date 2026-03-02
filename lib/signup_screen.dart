// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final Color primaryColor = const Color(0xFFEE2B5B);

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isLoading = false;

//   Future<void> _signup() async {
//     if (_passwordController.text.trim() !=
//         _confirmPasswordController.text.trim()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Passwords do not match")),
//       );
//       return;
//     }

//     if (_passwordController.text.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password must be at least 6 characters")),
//       );
//       return;
//     }

//     try {
//       setState(() => _isLoading = true);

//       UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       String uid = userCredential.user!.uid;

//       // ✅ Always save as customer
//       await FirebaseFirestore.instance.collection('users').doc(uid).set({
//         'email': _emailController.text.trim(),
//         'role': "customer",
//         'createdAt': Timestamp.now(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Account Created Successfully")),
//       );

//       Navigator.pop(context);
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message ?? "Signup Failed")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F6F6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               Text(
//                 "Create Account",
//                 style: GoogleFonts.poppins(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   hintText: "Email",
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _confirmPasswordController,
//                 obscureText: _obscureConfirmPassword,
//                 decoration: InputDecoration(
//                   hintText: "Confirm Password",
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureConfirmPassword = !_obscureConfirmPassword;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryColor,
//                   ),
//                   onPressed: _isLoading ? null : _signup,
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Sign Up"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final houseController = TextEditingController();
  final areaController = TextEditingController();
  final pinController = TextEditingController();
  final cityController = TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

       /// 🔥 1️⃣ Save User Basic Info
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fullName': fullNameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'role': "customer",
      'createdAt': Timestamp.now(),
    });

    /// 🔥 2️⃣ SAVE ADDRESS SUBCOLLECTION
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .add({
      'house': houseController.text.trim(),
      'area': areaController.text.trim(),
      'city': cityController.text.trim(),
      'pincode': pinController.text.trim(),
      'isDefault': true,
      'createdAt': Timestamp.now(),
    });


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account Created Successfully 🎉")),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "Signup Failed";

      // if (e.code == 'email-already-in-use') {
      //   message = "Email already registered";
      // } else if (e.code == 'weak-password') {
      //   message = "Password is too weak";
      // } else if (e.code == 'invalid-email') {
      //   message = "Invalid email";
      // }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.chevron_left, color: Colors.black, size: 32),
        //   onPressed: () {},
        // ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
             key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Join Trendify',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Step into the world of premium fashion.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
          
              // Profile Photo Section
              Center(
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: DashedCirclePainter(),
                      child: Container(
                        width: 130,
                        height: 130,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt,
                                color: const Color(0xFFF43F5E).withOpacity(0.6),
                                size: 36),
                            const SizedBox(height: 4),
                            const Text(
                              'ADD PHOTO',
                              style: TextStyle(
                                color: Color(0xFFF43F5E),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF43F5E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child:
                            const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
          
              const SizedBox(height: 40),
              _buildSectionHeader('Personal Information'),
              const SizedBox(height: 24),
              _buildTextField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  icon: Icons.person_outline,
                  controller: fullNameController),
              _buildTextField(
                  label: 'Email Address',
                  hint: 'john@example.com',
                  icon: Icons.mail_outline,
                  controller: emailController),
              _buildTextField(
                  label: 'Phone Number',
                  hint: '+1 234 567 890',
                  icon: Icons.phone_outlined,
                  controller: phoneController),
            
              _buildTextField(
                controller: passwordController,
                label: "Password",
                hint: "Enter password",
                isPassword: true,
                isHidden: isPasswordHidden,
                onToggle: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),
          
              _buildTextField(
                controller: confirmPasswordController,
                label: "Confirm Password",
                hint: "Re-enter password",
                isPassword: true,
                isHidden: isConfirmPasswordHidden,
                onToggle: () {
                  setState(() {
                    isConfirmPasswordHidden = !isConfirmPasswordHidden;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildSectionHeader('Primary Address'),
              const SizedBox(height: 24),
              _buildTextField(
                controller: houseController,
                label: 'House No / Flat',
                hint: 'Apartment 4B',
              ),
          
              _buildTextField(
                controller: areaController,
                label: 'Area / Street',
                hint: 'Sunset Boulevard',
              ),
          
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: pinController,
                      label: 'Pin Code',
                      hint: '110001',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: cityController,
                      label: 'City',
                      hint: 'New York',
                    ),
                  ),
                ],
              ),
          
              const SizedBox(height: 30),
          
              // Create Account Button
              Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF43F5E).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: ElevatedButton(
             onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43F5E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Account',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.arrow_forward, size: 22),
                    ],
                  ),
                ),
              ),
          
              const SizedBox(height: 32),
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                            color: Color(0xFFF43F5E),
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
          
              const SizedBox(height: 48),
              Row(
                children: [
                  const Expanded(
                      child: Divider(color: Color(0xFFEEEEEE), thickness: 1.5)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'TRENDIFY PREMIUM',
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const Expanded(
                      child: Divider(color: Color(0xFFEEEEEE), thickness: 1.5)),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF43F5E),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
            child: Divider(color: Color(0xFFF5F5F5), thickness: 1.5)),
      ],
    );
  }

  // Widget _buildTextField({required String label, required String hint, IconData? icon, bool isPassword = false,}) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 24.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 4, bottom: 8),
  //           child: Text(
  //             label,
  //             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF374151)),
  //           ),
  //         ),
  //         TextField(
  //           obscureText: isPassword,
  //           style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
  //           decoration: InputDecoration(
  //             hintText: hint,
  //             hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
  //             suffixIcon: icon != null ? Icon(icon, color: const Color(0xFF9CA3AF), size: 22) : null,
  //             contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //             filled: true,
  //             fillColor: Colors.white,
  //             enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1.5),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    bool isPassword = false,
    bool isHidden = false,
    VoidCallback? onToggle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            obscureText: isPassword ? isHidden : false,
            keyboardType: keyboardType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "$label is required";
              }
              if (label == "Password" && value.length < 6) {
                return "Minimum 6 characters required";
              }
              return null;
            },
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isHidden ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9CA3AF),
                      ),
                      onPressed: onToggle,
                    )
                  : icon != null
                      ? Icon(icon, color: const Color(0xFF9CA3AF), size: 22)
                      : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    const BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    const BorderSide(color: Color(0xFFF43F5E), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the dashed circular border
class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double dashWidth = 6;
    final double dashSpace = 6;
    double startAngle = 0;

    final paint = Paint()
      ..color = const Color(0xFFF43F5E)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    while (startAngle < 360) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle * (3.141592653589793 / 180),
        dashWidth * (3.141592653589793 / 180),
        false,
        paint,
      );
      startAngle += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

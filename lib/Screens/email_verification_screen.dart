// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:nescafe_flutter/Screens/home_screen.dart';
//
// import '../Components/roundedButton.dart';
//
// class EmailVerificationScreen extends StatefulWidget {
//   @override
//   _EmailVerificationScreenState createState() =>
//       _EmailVerificationScreenState();
// }
//
// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   bool isVerified = false;
//   bool isLoading = false;
//
//   void checkVerification() async {
//     setState(() => isLoading = true);
//     await FirebaseAuth.instance.currentUser?.reload();
//     var user = FirebaseAuth.instance.currentUser;
//
//     if (user != null && user.emailVerified) {
//       setState(() => isVerified = true);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     } else {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Email not verified yet")));
//     }
//   }
//
//   void resendEmail() async {
//     try {
//       await FirebaseAuth.instance.currentUser?.sendEmailVerification();
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Verification email resent")));
//     } catch (e) {
//       print("Resend Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff1C0F05),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Verify your email address",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 30),
//               RoundedButton(
//                 text: isLoading ? "Checking..." : "I have verified",
//                 onPressed: isLoading ? null : checkVerification,
//                 colour: Color(0xff5F4B48),
//                 textColour: Colors.white,
//               ),
//               SizedBox(height: 16),
//               TextButton(onPressed: resendEmail, child: Text("Resend Email")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'AdminNewPasswordPage.dart';

class AdminVerificationCodePage extends StatefulWidget {
  const AdminVerificationCodePage({Key? key}) : super(key: key);

  @override
  State<AdminVerificationCodePage> createState() =>
      _AdminVerificationCodePageState();
}

class _AdminVerificationCodePageState extends State<AdminVerificationCodePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
          vertical: screenHeight * 0.05,
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),

            // Logo at the top
            Image.asset(
              'assets/logo.png', // use the correct asset path
              height: screenHeight * 0.25,
              fit: BoxFit.contain,
            ),

            SizedBox(height: screenHeight * 0.04),

            // Header text
            const Text(
              "Enter Admin Verification Code",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0177DB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: "6-digit code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Code cannot be empty";
                      }
                      if (value.length != 6) {
                        return "Enter a 6-digit code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0177DB),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Navigate to New Password Page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AdminNewPasswordPage()),
                          );
                        }
                      },
                      child: const Text(
                        "Verify Admin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

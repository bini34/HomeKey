// screens/identity_verification_method_screen.dart
import 'package:flutter/material.dart';

class IdentityVerificationMethodScreen extends StatefulWidget {
  @override
  _IdentityVerificationMethodScreenState createState() =>
      _IdentityVerificationMethodScreenState();
}

class _IdentityVerificationMethodScreenState
    extends State<IdentityVerificationMethodScreen> {
  int selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Identity Verification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48), // Balance the title
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                'Choose your preferred method to identity verification',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
            SizedBox(height: 16),
            _buildMethodOption('National Identity Card', 0),
            _buildMethodOption('Passport', 1),
            _buildMethodOption('Driver License', 2),
            Spacer(),
            _buildNextButton(context),
            SizedBox(height: 16),
            _buildSkipButton(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodOption(String title, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color:
                selectedMethod == index ? Color(0xFFEF7D57) : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(_getIconForMethod(title), color: Color(0xFFEF7D57)),
          title: Text(title),
          trailing: Radio(
            value: index,
            groupValue: selectedMethod,
            activeColor: Color(0xFFEF7D57),
            onChanged: (value) {
              setState(() {
                selectedMethod = value as int;
              });
            },
          ),
          onTap: () {
            setState(() {
              selectedMethod = index;
            });
          },
        ),
      ),
    );
  }

  IconData _getIconForMethod(String method) {
    switch (method) {
      case 'National Identity Card':
        return Icons.credit_card;
      case 'Passport':
        return Icons.book;
      case 'Driver License':
        return Icons.card_membership;
      default:
        return Icons.document_scanner;
    }
  }

  Widget _buildNextButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          child: Text(
            'Next',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFEF7D57),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          child: Text(
            'Skip For Now',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.grey[300]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

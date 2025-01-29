import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportUsMenu extends StatelessWidget {
  const SupportUsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Support Us'),
        backgroundColor: Colors.purple.shade300,
      ),
      body: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/Crystallinelogo.jpg"),
          //       fit,

          //     ),
          //   ),
          // ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.white.withOpacity(0.8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About Crystalline Ceramics",
                            style: TextStyle(
                              fontSize: 24,
                              fontStyle: FontStyle.italic,
                              color: Colors.purple.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Crystalline Ceramics has been a leading name in the industry since 2018. Our commitment to quality and innovation ensures that each product meets the highest standards, supporting your construction and renovation projects with reliability and excellence.",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Discover the difference with Crystalline Ceramics, where expertise meets exceptional value.",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.phone, color: Colors.purple.shade300),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  _launchPhone("tel:+919824452987");
                                },
                                child: Text(
                                  "MOBILE NO: +91 9824452987",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.purple.shade700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.email, color: Colors.purple.shade300),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  _launchEmail("Crystallineceramics@gmail.com");
                                },
                                child: Text(
                                  "E-MAIL: Crystallineceramics@gmail.com",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.purple.shade700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "GSTNO: 24BDGPR3817L1Z9",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri.parse(phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not call $phoneNumber';
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not send email to $emailUri';
    }
  }
}

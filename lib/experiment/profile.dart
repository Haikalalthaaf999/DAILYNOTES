import 'package:dailynotes/experiment/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'User';
  String userJob = 'Unknown';
  String userEmail = 'No email';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userJob = prefs.getString('user_job') ?? 'Unknown';
      userEmail = prefs.getString('user_email') ?? 'No email';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC39BEF), 
      appBar: AppBar(
        title: Text(
          '',
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Color(0xff804CF6), 
      ),
      drawer: const DrawerBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/eva.jpg'),
                      fit: BoxFit.cover,
                      onError:
                          (exception, stackTrace) =>
                              const AssetImage('assets/images/fallback.jpg'),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 125,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(
                          0xffC39BEF,
                        ), // Border foto profil (ungu muda)
                        width: 4.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: const AssetImage(
                        'assets/images/pro.jpg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 45),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Teks putih untuk kontras
                            ),
                          ),
                          Text(
                            userJob,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Color(0xffFFFEFE), 
                            ),
                          ),
                          Text(
                            userEmail,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Color(0xffFFFEFE), 
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                              0xffC6E774,
                            ), // Tombol (hijau neon)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit,
                                color: Color(0xff4A2C5A),
                                size: 16,
                              ), // Ungu tua
                              SizedBox(width: 4),
                              Text(
                                'Edit profile',
                                style: TextStyle(
                                  color: Color(0xff4A2C5A),
                                ), // Ungu tua
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                            0xffC6E774,
                          ), // Tombol (hijau neon)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.more_horiz,
                              color: Color(0xff4A2C5A), // Ungu tua
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xffF5C024), 
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Nama saya Haikal, saat ini saya sedang belajar menjadi mobile programmer. Saya mempunyai hobi mendengarkan lagu, saya juga mempunyai hobi bermain game. Saya suka berolahraga, terutama lari dan renang.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(0xff4A2C5A),
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

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
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 25,
            color: Color(0xffFCECDD)
            ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff00809D),
      ),
      drawer: DrawerBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Cover dengan penanganan error
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cover.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Foto Profil
                  Positioned(
                    left: 16,
                    bottom: -3,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage('assets/images/kocheng.jpg'),
                    ),
                  ),
                ],
              ),
            ),
            // Padding setelah cover
            Padding(
              padding: EdgeInsets.all(16).copyWith(top: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama dan Pekerjaan
                  Text(
                    userName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    userJob,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  // Statistik (Postingan dan Followers)
                  Divider(),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xffF2C078),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Nama Saya Haikal, saat ini saya sedang belajar menjadi mobile programer. "
                      "Saya mempunyai hobi mendengarkan lagu, saya juga mempunyai hobi bermain game. "
                      "Saya suka berolahraga, terutama lari dan renang.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

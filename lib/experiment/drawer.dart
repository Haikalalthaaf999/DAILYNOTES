// lib/experiment/drawer.dart
import 'package:dailynotes/experiment/login.dart';
// import 'package:dailynotes/experiment/model/note.dart';
import 'package:dailynotes/experiment/note_screen.dart';
import 'package:dailynotes/experiment/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerBar extends StatelessWidget {
  const DrawerBar({super.key});

  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('user_name') ?? 'User';
    final userJob = prefs.getString('user_job') ?? 'Unknown';
    final userEmail = prefs.getString('user_email') ?? 'No email';
    print(
      'Retrieved user data - name: $userName, job: $userJob, email: $userEmail',
    );
    return {'name': userName, 'job': userJob, 'email': userEmail};
  }
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Drawer(child: Center(child: Text('Error loading profile')));
        }

        final userData = snapshot.data!;
        return Drawer(
          child: Container(
            color: const Color(0xffF3A26D),
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF00809D),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(35),
                        child: const CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage(
                            'assets/images/kocheng.jpg',
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userData['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userData['job']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotesScreen()),
                    ); 
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text(
                    'Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfileScreen())); 
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Color(0xffFFE6C7)),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Color(0xffFFE6C7)),
                  ),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear(); // Hapus semua data pengguna
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

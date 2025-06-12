import 'package:dailynotes/experiment/drawer.dart';
import 'package:dailynotes/experiment/edit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dailynotes/experiment/database/db_helper.dart';
import 'package:dailynotes/experiment/model/note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // Daftar untuk menyimpan catatan pengguna.
  List<Note> notes = [];
  // ID pengguna default, digunakan untuk mengambil catatan spesifik pengguna
  int userId = 1;
  // Controller untuk menangani input teks di dialog catatan
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil _loadUserAndNotes saat widget diinisialisasi untuk memuat ID pengguna dan catatan
    _loadUserAndNotes();
  }

  // Fungsi untuk memuat ID pengguna dari SharedPreferences dan mengambil catatan pengguna
  Future<void> _loadUserAndNotes() async {
    // Ambil instance SharedPreferences untuk mengakses data pengguna yang tersimpan
    final prefs = await SharedPreferences.getInstance();
    // Ambil ID pengguna dari SharedPreferences, gunakan -1 jika tidak ditemukan
    userId = prefs.getInt('user_id') ?? -1;
    // Muat catatan pengguna dari database
    await _loadNotes();
  }

  // Fungsi untuk mengambil catatan dari database dan memperbarui state
  Future<void> _loadNotes() async {
    // Ambil catatan untuk pengguna saat ini dari database menggunakan DBHelper
    final data = await DBHelper().getUserNotes(userId);
    // Perbarui state dengan catatan yang diambil, memicu pembaruan UI
    setState(() => notes = data);
  }

  // Fungsi untuk menampilkan dialog untuk menambah atau mengedit catatan
  void _showNoteDialog({Note? note}) {
    // Jika mengedit catatan yang sudah ada, isi controller dengan data catatan
    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
    } else {
      // Jika menambah catatan baru, kosongkan controller
      titleController.clear();
      contentController.clear();
    }

    // Tampilkan AlertDialog untuk menambah atau mengedit catatan
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            // Atur judul dialog berdasarkan apakah menambah atau mengedit
            title: Text(note == null ? 'Tambah Catatan' : 'Edit Catatan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Kolom teks untuk memasukkan judul catatan
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                // Kolom teks untuk memasukkan isi catatan
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Isi'),
                ),
              ],
            ),
            actions: [
              // Tombol batal untuk menutup dialog tanpa menyimpan
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              // Tombol simpan untuk menyimpan atau memperbarui catatan di database
              ElevatedButton(
                onPressed: () async {
                  // Ambil teks yang sudah di-trim dari controller
                  final title = titleController.text.trim();
                  final content = contentController.text.trim();
                  // Jika judul atau isi kosong, jangan lakukan apa-apa
                  if (title.isEmpty || content.isEmpty) return;

                  // Jika menambah catatan baru, masukkan ke database
                  if (note == null) {
                    await DBHelper().insertNote(
                      Note(userId: userId, title: title, content: content),
                    );
                  } else {
                    // Jika mengedit, perbarui catatan yang ada di database
                    await DBHelper().updateNote(
                      Note(
                        id: note.id,
                        userId: userId,
                        title: title,
                        content: content,
                      ),
                    );
                  }

                  // Tutup dialog jika widget masih aktif
                  if (mounted) Navigator.pop(context);
                  // Muat ulang daftar catatan
                  _loadNotes();
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  // Fungsi untuk menghapus catatan dari database
  void _deleteNote(int id) async {
    // Hapus catatan dengan ID tertentu menggunakan DBHelper
    await DBHelper().deleteNote(id);
    // Muat ulang daftar catatan setelah penghapusan
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catatan Harian',
          style: TextStyle(color: Color(0xffFCECDD)),
        ),
        backgroundColor: Color(0xff00809D),
      ),
      drawer: DrawerBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          // Jumlah item di grid sesuai dengan jumlah catatan
          itemCount: notes.length,
          // Tata letak grid dengan 2 kolom, jarak, dan rasio aspek
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          // Bangun setiap item grid (kartu catatan)
          itemBuilder: (_, index) {
            final note = notes[index];
            // Daftar warna untuk kartu catatan, digunakan secara bergilir
            final colors = [
              Color(0xffFFF7D1),
              Color(0xffFFECC8),
              Color(0xffFFD09B),
              Color(0xffFFB0B0),
              Color(0xffD1D8BE),
              Color(0xffEEEFE0),
            ];
            // Tentukan warna kartu berdasarkan indeks
            final color = colors[index % colors.length];

            // GestureDetector untuk menangani ketukan pada kartu catatan
            return GestureDetector(
              // Ketuk untuk membuka dialog edit catatan
              onTap: () => _showNoteDialog(note: note),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Tampilkan isi catatan, dibatasi 5 baris
                    Expanded(
                      child: Text(
                        note.content,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Baris untuk tombol edit dan hapus
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tombol edit untuk navigasi ke EditNoteScreen
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // Navigasi ke EditNoteScreen dan kirim catatan
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditNoteScreen(note: note),
                                ),
                              ).then((value) {
                                // Jika layar edit mengembalikan true, muat ulang catatan
                                if (value == true) _loadNotes();
                              });
                            },
                          ),
                          // Tombol hapus untuk menghapus catatan
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteNote(note.id!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // Tombol aksi mengambang untuk menambah catatan baru
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

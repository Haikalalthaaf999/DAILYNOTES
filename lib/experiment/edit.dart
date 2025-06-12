import 'package:dailynotes/experiment/database/db_helper.dart';
import 'package:dailynotes/experiment/model/note.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditNoteScreen extends StatefulWidget {
  // Properti untuk menyimpan data catatan yang akan diedit
  final Note note;
  // Konstruktor dengan parameter note yang wajib diisi
  const EditNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  //  untuk mengelola input teks judul dan isi catatan
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data awal dari catatan yang bakal diedit
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
   //Biar kgk bengkak tuh penyimpanan
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bangun UI utama untuk layar edit catatan
    return Scaffold(
      // AppBar dengan judul dan gaya kustom
      appBar: AppBar(
        title: const Text(
          'Edit Note',
          style: TextStyle(color: Color(0xffFCECDD)),
        ),
        centerTitle: true, // Judul diposisikan di tengah
        backgroundColor: Color(0xff00809D), // Warna latar AppBar
      ),
      // Body dengan SingleChildScrollView agar konten bisa digulir
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0), // Jarak 20 piksel di semua sisi
        child: Card(
          elevation: 4, // Efek bayangan pada kartu
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Sudut kartu membulat
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Jarak dalam kartu 20 piksel
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Elemen memenuhi lebar
              children: [
                // Kolom teks untuk mengedit judul
                TextField(
                  controller: _titleController,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Title', // Label untuk judul
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Sudut membulat
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Jarak vertikal 20 piksel
                // Kolom teks untuk mengedit isi catatan
                TextField(
                  controller: _contentController,
                  style: GoogleFonts.poppins(fontSize: 16),
                  maxLines: 8, // Maksimum 8 baris untuk isi
                  decoration: InputDecoration(
                    labelText: 'Content', // Label untuk isi
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Jarak vertikal 30 piksel
                // Tombol untuk menyimpan perubahan
                ElevatedButton.icon(
                  onPressed: _saveNote, // Panggil fungsi _saveNote saat ditekan
                  icon: const Icon(Icons.save, color: Color(0xffFCECDD)),
                  label: const Text(
                    'Save',
                    style: TextStyle(color: Color(0xffFCECDD)),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ), // Padding tombol
                    backgroundColor: Color(0xffFF7601), // Warna latar tombol
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Sudut membulat
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menyimpan perubahan catatan
  void _saveNote() async {
    // Validasi: pastikan judul dan isi tidak kosong
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      // Tampilkan pesan error jika ada kolom kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title and content cannot be empty'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Buat objek Note baru dengan data yang diperbarui
    final updatedNote = Note(
      id: widget.note.id, // Gunakan ID catatan yang ada
      userId: widget.note.userId, // Gunakan userId yang sama
      title: _titleController.text.trim(), // Judul yang diperbarui
      content: _contentController.text.trim(), // Isi yang diperbarui
    );

    // Perbarui catatan di database menggunakan DBHelper
    await DBHelper().updateNote(updatedNote);

    // Kembali ke layar sebelumnya dengan indikator bahwa update berhasil
    Navigator.pop(context, true);
  }
}

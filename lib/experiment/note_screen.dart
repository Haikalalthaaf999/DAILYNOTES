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
  // Daftar untuk menyimpan semua catatan (sebelum difilter)
  List<Note> allNotes = [];
  // Daftar untuk menyimpan catatan yang ditampilkan (setelah difilter)
  List<Note> notes = [];
  // ID pengguna default, digunakan untuk mengambil catatan spesifik pengguna
  int userId = 1;
  // Controller untuk menangani input teks di dialog catatan
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil _loadUserAndNotes saat widget diinisialisasi
    _loadUserAndNotes();
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihancurkan
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // Fungsi untuk memuat ID pengguna dari SharedPreferences dan mengambil catatan pengguna
  Future<void> _loadUserAndNotes() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id') ?? -1;
    await _loadNotes();
  }

  // Fungsi untuk mengambil catatan dari database dan memperbarui state
  Future<void> _loadNotes() async {
    final data = await DBHelper().getUserNotes(userId);
    setState(() {
      allNotes = data; // Simpan semua catatan
      notes = List.from(allNotes); // Inisialisasi notes dengan semua catatan
    });
  }

  // Fungsi untuk menampilkan dialog untuk menambah atau mengedit catatan
  void _showNoteDialog({Note? note}) {
    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
    } else {
      titleController.clear();
      contentController.clear();
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Color(0xffA976C3),
            title: Text(
              note == null ? 'Tambah Catatan' : 'Edit Catatan',
              style: TextStyle(color: Color(0xff5CCB55)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                    labelStyle: TextStyle(color: Color(0xff5CCB55)),
                  ),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Isi',
                    labelStyle: TextStyle(color: Color(0xff5CCB55)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Color(0xffF5C024)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffF5C024),
                ),
                onPressed: () async {
                  final title = titleController.text.trim();
                  final content = contentController.text.trim();
                  if (title.isEmpty || content.isEmpty) return;

                  if (note == null) {
                    await DBHelper().insertNote(
                      Note(userId: userId, title: title, content: content),
                    );
                  } else {
                    await DBHelper().updateNote(
                      Note(
                        id: note.id,
                        userId: userId,
                        title: title,
                        content: content,
                      ),
                    );
                  }

                  if (mounted) Navigator.pop(context);
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
    await DBHelper().deleteNote(id);
    _loadNotes();
  }

  // Custom SearchDelegate untuk pencarian catatan
  void _startSearch() {
    showSearch(
      context: context,
      delegate: NoteSearchDelegate(allNotes, _loadNotes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catatan Harian',
          style: TextStyle(color: Color(0xffFCECDD)),
        ),
        backgroundColor: Color(0xff804CF6),
        // Tambahkan ikon pencarian di actions
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xffFCECDD)),
            onPressed: _startSearch,
          ),
        ],
      ),
      drawer: DrawerBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: notes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (_, index) {
            final note = notes[index];
            final colors = [
              Color(0xffFFF7D1),
              Color(0xffFFECC8),
              Color(0xffFFD09B),
              Color(0xffFFB0B0),
              Color(0xffD1D8BE),
              Color(0xffEEEFE0),
            ];
            final color = colors[index % colors.length];

            return GestureDetector(
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
                    Expanded(
                      child: Text(
                        note.content,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditNoteScreen(note: note),
                                ),
                              ).then((value) {
                                if (value == true) _loadNotes();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi Penghapusan'),
                                    content: const Text(
                                      'Apakah Anda yakin ingin menghapus?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _deleteNote(note.id!);
                                        },
                                        child: const Text('Ya'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff5F2A62),
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add, color: Color(0xff5CCB55)),
      ),
    );
  }
}

// Custom SearchDelegate untuk pencarian catatan
class NoteSearchDelegate extends SearchDelegate<String> {
  final List<Note> allNotes;
  final Future<void> Function() reloadNotes;

  NoteSearchDelegate(this.allNotes, this.reloadNotes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        allNotes.where((note) {
          final title = note.title.toLowerCase();
          final content = note.content.toLowerCase();
          return title.contains(query.toLowerCase()) ||
              content.contains(query.toLowerCase());
        }).toList();

    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        allNotes.where((note) {
          final title = note.title.toLowerCase();
          final content = note.content.toLowerCase();
          return title.contains(query.toLowerCase()) ||
              content.contains(query.toLowerCase());
        }).toList();

    return _buildSearchResults(suggestions);
  }

  Widget _buildSearchResults(List<Note> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(
            note.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            close(context, '');
            // Navigasi ke EditNoteScreen untuk edit setelah pencarian
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditNoteScreen(note: note),
              ),
            ).then((value) {
              if (value == true) reloadNotes();
            });
          },
        );
      },
    );
  }
}

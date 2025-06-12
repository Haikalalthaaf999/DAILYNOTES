// import 'package:dailynotes/login.dart';
// import 'package:dailynotes/model/note_model.dart';
// import 'package:flutter/material.dart';
// import 'package:dailynotes/database/dbnotes.dart';
// import 'package:intl/intl.dart'; // Tambahkan untuk DateFormat

// class NoteScreen extends StatefulWidget {
//   final int userId;

//   const NoteScreen({super.key, required this.userId});

//   @override
//   State<NoteScreen> createState() => _NoteScreenState();
// }

// class _NoteScreenState extends State<NoteScreen> {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController contentController = TextEditingController();
//   List<Note> notes = [];
//   final DbNotes dbNotes = DbNotes(); // Digunakan untuk konsistensi

//   @override
//   void initState() {
//     super.initState();
//     _refreshNotes();
//   }

//   Future<void> _refreshNotes() async {
//     final notes =
//         await DbNotes.getAllNote(); // Pastikan getAllNote() mengembalikan List<Note>
//     setState(() {
//       this.notes = notes;
//     });
//   }

//   Future<void> tambah() async {
//     if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
//       await DbNotes.insertNote(
//         Note(
//           userId: widget.userId.toString(),
//           title: titleController.text,
//           content: contentController.text,
//           date: DateTime.now(),
//         ),
//       );
//       _refreshNotes();
//       titleController.clear();
//       contentController.clear();
//     }
//   }

//   Future<void> edit(int id) async {
//     final note = Note(
//       id: id,
//       userId: widget.userId.toString(),
//       title: titleController.text,
//       content: contentController.text,
//       date: DateTime.now(),
//     );
//     await DbNotes.updateNote(note);
//     _refreshNotes(); // Refresh setelah edit
//   }

//   Future<void> hapus(int id) async {
//     await DbNotes.deleteNote(id);
//     _refreshNotes();
//   }

//   void _showNoteDialog({Note? note}) {
//     // Ganti Map menjadi Note
//     if (note != null) {
//       titleController.text = note.title;
//       contentController.text = note.content;
//     } else {
//       titleController.clear();
//       contentController.clear();
//     }
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Text(note == null ? 'Add Note' : 'Edit Note'),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: titleController,
//                     decoration: const InputDecoration(labelText: 'Title'),
//                   ),
//                   TextField(
//                     controller: contentController,
//                     decoration: const InputDecoration(labelText: 'Content'),
//                     maxLines: 4,
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (note == null) {
//                     await tambah();
//                   } else {
//                     await edit(note.id!); // Pastikan id tidak null
//                   }
//                   Navigator.pop(context);
//                 },
//                 child: Text(note == null ? 'Add' : 'Update'),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Notes'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               // Pastikan LoginScreen sudah didefinisikan
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginScreenApp()),
//               );
//             },
//           ),
//         ],
//       ),
//       body:
//           notes.isEmpty
//               ? const Center(child: Text('No notes yet. Add one!'))
//               : ListView.builder(
//                 padding: const EdgeInsets.all(8.0),
//                 itemCount: notes.length,
//                 itemBuilder: (context, index) {
//                   final note = notes[index];
//                   return Card(
//                     child: ListTile(
//                       title: Text(
//                         note.title,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(note.content),
//                           const SizedBox(height: 4),
//                           Text(
//                             DateFormat.yMMMd().format(note.date),
//                             style: TextStyle(color: Colors.grey.shade600),
//                           ),
//                         ],
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () => _showNoteDialog(note: note),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () => hapus(note.id!),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showNoteDialog(),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

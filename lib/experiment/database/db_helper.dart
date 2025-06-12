import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dailynotes/experiment/model/user.dart';
import 'package:dailynotes/experiment/model/note.dart';

class DBHelper {
  // Membuat instance singleton untuk DBHelper agar hanya ada satu instance database
  static final DBHelper _instance = DBHelper._internal();

  // Factory constructor untuk mengembalikan instance singleton
  factory DBHelper() => _instance;

  // Konstruktor privat untuk mencegah pembuatan instance baru dari luar
  DBHelper._internal();

  // Variabel untuk menyimpan instance database
  static Database? _db;

  // Getter untuk mendapatkan instance database, menginisialisasi jika belum ada
  Future<Database> get db async {
    // Jika _db belum diinisialisasi, panggil _initDB untuk membuatnya
    _db ??= await _initDB();
    // Kembalikan instance database yang sudah diinisialisasi
    return _db!;
  }

  // Fungsi untuk menginisialisasi database
  Future<Database> _initDB() async {
    // path untuk file database menggunakan getDatabasesPath dan join
    final path = join(await getDatabasesPath(), 'daily_notes.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // tabel 'users' untuk menyimpan data pengguna
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          );
        ''');

        //  tabel 'notes' untuk menyimpan data catatan
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            title TEXT,
            content TEXT
          );
        ''');
      },
    );
  }

  // Fungsi untuk mendaftarkan pengguna baru
  Future<int> registerUser(User user) async {
    // Dapatkan instance database
    final dbClient = await db;
    // Masukkan data pengguna ke tabel 'users' dan kembalikan ID yang dihasilkan
    return await dbClient.insert('users', user.toMap());
  }

  // Fungsi untuk login pengguna
  Future<User?> loginUser(String username, String password) async {
    // Dapatkan instance database
    final dbClient = await db;
    // Query tabel 'users' untuk mencari pengguna dengan username dan password yang cocok
    final result = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    // Jika ditemukan hasil, kembalikan objek User dari data pertama
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    // Jika tidak ditemukan, maka null
    return null;
  }

  // Fungsi untuk menambahkan catatan baru
  Future<int> insertNote(Note note) async {
    // Dapatkan instance database
    final dbClient = await db;
    // Masukkan data catatan ke tabel 'notes' dan kembalikan ID yang dihasilkan
    return await dbClient.insert('notes', note.toMap());
  }

  // Fungsi untuk mengambil daftar catatan berdasarkan ID pengguna
  Future<List<Note>> getUserNotes(int userId) async {
    // Dapatkan instance database
    final dbClient = await db;
    // Query tabel 'notes' untuk catatan dengan user_id tertentu, urutkan berdasarkan ID secara menurun
    final result = await dbClient.query(
      'notes',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    // Ubah hasil query menjadi daftar objek Note
    return result.map((e) => Note.fromMap(e)).toList();
  }

  // Fungsi untuk menghapus catatan berdasarkan ID
  Future<int> deleteNote(int id) async {
    // Dapatkan instance database
    final dbClient = await db;
    // Hapus catatan dari tabel 'notes' berdasarkan ID 
    return await dbClient.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk memperbarui catatan
  Future<int> updateNote(Note note) async {
    // Dapatkan instance database
    final dbClient = await db;
    // Perbarui data catatan di tabel 'notes' berdasarkan ID dan kembalikan jumlah baris yang diperbarui
    return await dbClient.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}

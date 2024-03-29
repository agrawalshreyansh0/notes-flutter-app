import 'dart:convert';
import 'dart:developer';

import '../models/note.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://notes-api-4a3c.onrender.com/notes";

  static Future<void> addNote(Note note) async {
    Uri requestUri = Uri.parse("$_baseUrl/add");
    var response = await http.post(requestUri, body: note.toMap());
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<void> deleteNote(Note note) async {
    Uri requestUri = Uri.parse("$_baseUrl/delete/${note.id}");
    var response = await http.delete(requestUri);
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<List<Note>> fetchNotes(String userid) async {
    Uri requestUri = Uri.parse("$_baseUrl/$userid");
    var response = await http.get(requestUri);
    var decoded = jsonDecode(response.body);
    List<Note> notes = [];
    for (var noteMap in decoded) {
      Note newNote = Note.fromMap(noteMap);
      notes.add(newNote);
    }
    return notes;
  }
}

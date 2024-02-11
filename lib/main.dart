import 'package:flutter/material.dart';

void main() {
  runApp(MyNoteApp());
}

class MyNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyNoteHomePage(),
    );
  }
}

class MyNoteHomePage extends StatefulWidget {
  @override
  _MyNoteHomePageState createState() => _MyNoteHomePageState();
}

class _MyNoteHomePageState extends State<MyNoteHomePage> {
  int _currentIndex = 0;
  List<String> notes = [];

  TextEditingController _noteController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Oculta el teclado al cambiar de pestaña
      FocusScope.of(context).unfocus();
    });
  }

  void _saveNote() {
    String note = _noteController.text;
    if (note.isNotEmpty) {
      setState(() {
        notes.add(note);
        _noteController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas App'),
      ),
      body: _currentIndex == 0 ? _buildNoteInput() : _buildNoteList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Nueva Nota',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista de Notas',
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    return GestureDetector(
      // Agrega un GestureDetector para detectar toques fuera del teclado
      onTap: () {
        FocusScope.of(context).unfocus(); // Oculta el teclado al tocar fuera
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Escribe tu nota aquí',
              ),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Guardar Nota'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _navigateToNoteDetail(context, notes[index]);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _truncateText(notes[index]),
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _truncateText(String text) {
    const maxLength = 30;
    return text.length <= maxLength
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  void _navigateToNoteDetail(BuildContext context, String note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(note: note),
      ),
    );
  }
}

class NoteDetailPage extends StatelessWidget {
  final String note;

  NoteDetailPage({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de la Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(note),
      ),
    );
  }
}

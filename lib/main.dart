import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:notas/pages/detalhes_nota.dart';
import 'package:notas/nota.dart';
import 'package:notas/pages/nova_nota.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Notas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Minhas Notas'),
      routes: {"/nova_nota": (context) => NovaNota()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var notas = getNotes();
  Uri urlNotas = Uri.parse("http://localhost:8080/");

  int page = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Nota>>(
          future: notas,
          builder: (context,list){
            if(list.hasData) {
              return buildNotes(list.data!);
            } else {
              return const Text("Sem notas para exibir.");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> addNote(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  addNote(BuildContext context) async {
    final Nota? nota = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NovaNota()),
    );
    if(nota != null){
      var body = jsonEncode( {
          'titulo': nota.titulo,
          'texto': nota.texto
        });
      await http.post(
        urlNotas, 
        body: body,
        headers: {
          "Accept": "application/json",
          "content-type":"application/json"
        }
      );
    }
    refreshList();
  }

  Widget buildNotes(List<Nota> notas) => ListView.builder(
    itemCount: notas.length,
    itemBuilder: (context, index){
      final nota = notas[index];
      return ListTile(
              title: Text(nota.titulo),
              subtitle: Text(
                  nota.texto,
                  maxLines: 1,
                ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.blue),
                onPressed: (){
                  deleteNote(nota);
                  refreshList();
                },
              ),
              onTap: (){
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesNota(notaLocal: nota,)
                )
              );
              refreshList();
              },
            );
    }
  );

  static Future<List<Nota>> getNotes() async {
    final response = await http.get(Uri.parse("http://localhost:8080/"));
    final body = json.decode(utf8.decode(response.bodyBytes));
    return body.map<Nota>(Nota.fromJson).toList();
  }
  deleteNote(Nota nota) async {
    await http.delete(Uri.parse("http://localhost:8080/${nota.id}"));
  }

  void refreshList() {
    setState(() {
      notas=getNotes();
    });
  } 
}

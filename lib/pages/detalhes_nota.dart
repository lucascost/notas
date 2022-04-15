import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../nota.dart';
import 'nova_nota.dart';

class DetalhesNota extends StatefulWidget {
  DetalhesNota({ Key? key, required this.notaLocal }) : super(key: key);
    Nota notaLocal;

  @override
  State<DetalhesNota> createState() => _DetalhesNotaState();
}

class _DetalhesNotaState extends State<DetalhesNota> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text(
              "Editar",
              style: TextStyle(
                color: Colors.white
                ),
              ),
            onPressed: ()=> update(context),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.notaLocal.titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.notaLocal.texto,
              textAlign: TextAlign.start,
            )
          ],
        ),
      ),
    );
  }

  update(BuildContext context) async {
    final Nota? notaNova = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NovaNota(nota: widget.notaLocal),
      )
    );
    if(notaNova != null){
      var body = jsonEncode( {
          'id': widget.notaLocal.id,
          'titulo': notaNova.titulo,
          'texto': notaNova.texto
        });
      var response = await http.put(
        Uri.parse("http://localhost:8080/${widget.notaLocal.id}"), 
        body: body,
        headers: {
          "Accept": "application/json",
          "content-type":"application/json"
        }
      );
      setState(() {
        widget.notaLocal= notaNova;
      });
    }
  }
}
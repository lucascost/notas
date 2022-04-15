import 'package:flutter/material.dart';
import 'package:notas/nota.dart';

class NovaNota extends StatelessWidget {
  NovaNota({ Key? key, this.nota}) : super(key: key){
    if(nota!=null){
      tituloNota.text = nota!.titulo; 
      textoNota.text = nota!.texto;
    }
  }
  
  final Nota? nota;
  final tituloNota = TextEditingController();
  final textoNota = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova nota"),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Titulo",
              ),
              controller: tituloNota,
            ),
            Expanded(
              child: TextFormField(
                controller: textoNota,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Digite algo...",
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Adicionar'),
              onPressed: (){
                var nota = Nota(
                  titulo: tituloNota.text, 
                  texto: textoNota.text
                );
                Navigator.pop(context, nota);
              },
            )
          ],
        ),
      )
    );
  }
}
class Nota{
  final String? id;
  final String titulo;
  final String texto;

  const Nota({
    required this.titulo, 
    required this.texto,this.id
  });

  static Nota fromJson(json) => Nota(
    id: json['id'],
    titulo: json['titulo'], 
    texto: json['texto']
    );
}
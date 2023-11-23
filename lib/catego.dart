import 'package:dam_u3_practica2/detalles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'serviciosremotos.dart';

class DetallesCat extends StatefulWidget {
  final String categoria;

  const DetallesCat({Key? key, required this.categoria}) : super(key: key);

  @override
  State<DetallesCat> createState() => _DetallesCatState();
}

class _DetallesCatState extends State<DetallesCat> {
  late Future<List<QueryDocumentSnapshot>> recetasFuturas;

  @override
  void initState() {
    super.initState();
    recetasFuturas = DB.obtenerRecetasPorCategoria(widget.categoria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white, // Añade color al AppBar
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: recetasFuturas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay recetas para esta categoría.'));
          }

          var recetas = snapshot.data!;

          return ListView.separated(
            itemCount: recetas.length,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey), // Separadores para cada item
            itemBuilder: (context, index) {
              var receta = recetas[index].data() as Map<String, dynamic>;
              var recetaId = recetas[index].id;

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      8.0), // Esquinas redondeadas para la imagen
                  child: Image.network(
                    receta['foto'],
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  receta['nombreReceta'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                subtitle: Text(
                  'Categoría: ${receta['categoria']}',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetallesReceta(recetaId: recetaId),
                    ),
                  );
                },
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0), // Espaciado interno para cada ListTile
              );
            },
          );
        },
      ),
      backgroundColor:
          Colors.grey[200], // Color de fondo para la pantalla completa
    );
  }
}

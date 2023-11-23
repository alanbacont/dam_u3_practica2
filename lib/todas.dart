import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'serviciosremotos.dart'; // Asegúrate de importar serviciosremotos.dart

class todasRec extends StatefulWidget {
  const todasRec({super.key});

  @override
  State<todasRec> createState() => _todasRecState();
}

class _todasRecState extends State<todasRec> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todas las Recetas'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: DB.obtenerRecetas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay recetas disponibles'));
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot<Map<String, dynamic>> document) {
              Map<String, dynamic> receta = document.data()!;
              String recetaId = document.id;

              return ListTile(
                title: Text(receta['nombreReceta']),
                subtitle: Text(receta['categoria']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Aquí implementas la lógica para eliminar la receta
                    _eliminarReceta(recetaId);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _eliminarReceta(String recetaId) async {
    try {
      await DB.eliminar(recetaId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receta eliminada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la receta')),
      );
    }
  }
}

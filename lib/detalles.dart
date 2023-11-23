import 'package:dam_u3_practica2/editar.dart';
import 'package:dam_u3_practica2/serviciosremotos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetallesReceta extends StatefulWidget {
  final String recetaId;

  const DetallesReceta({
    Key? key,
    required this.recetaId,
  }) : super(key: key);

  @override
  State<DetallesReceta> createState() => _DetallesRecetaState();
}

class _DetallesRecetaState extends State<DetallesReceta> {
  late DocumentSnapshot recetaData;
  bool isLoading = true;
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    loadRecetaData();
  }

  Future<void> loadRecetaData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var snapshot = await DB.obtenerDetallesReceta(widget.recetaId);
      var calificaciones =
          snapshot.data()?['calificaciones'] as List<dynamic>? ?? [];

      setState(() {
        recetaData = snapshot;
        _rating = DB.calcularCalificacionPromedio(
            calificaciones);
        isLoading = false; 
      });
    } catch (e) {
      setState(() {
        isLoading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Cargando...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recetaData['nombreReceta']),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditarReceta(recetaId: widget.recetaId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              recetaData['foto'],
              fit: BoxFit.cover,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                    'Ingredientes',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Card(
                    elevation: 4.0,
                    child: ListTile(
                      leading: const Icon(Icons.food_bank),
                      title: const Text('Ingredientes'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<String>.from(recetaData['ingredientes'])
                            .map((ingrediente) => Text('- $ingrediente'))
                            .toList(),
                      ),
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Pasos de Preparación',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Card(
                    elevation: 4.0,
                    child: ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('Pasos de Preparación'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            List<String>.from(recetaData['pasosPreparacion'])
                                .map((paso) => Text('- $paso'))
                                .toList(),
                      ),
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Tiempo de Preparación: ${recetaData['tiempoPreparacion']} minutos',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Divider(),
                  Text(
                    'Categoría: ${recetaData['categoria']}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Divider(),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                      // Lógica para actualizar la calificación en Firestore
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

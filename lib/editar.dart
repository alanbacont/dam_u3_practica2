import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'serviciosremotos.dart';

class EditarReceta extends StatefulWidget {
  final String recetaId;

  const EditarReceta({Key? key, required this.recetaId}) : super(key: key);

  @override
  State<EditarReceta> createState() => _EditarRecetaState();
}

class _EditarRecetaState extends State<EditarReceta> {
  late DocumentSnapshot<Map<String, dynamic>> recetaData;
  bool isLoading = true;
  double _rating = 0;
  final _formKey = GlobalKey<FormState>();
  // Define los controladores para los campos de texto
  late TextEditingController _nombreController;
  late TextEditingController _ingredientesController;
  late TextEditingController _pasosController;
  late TextEditingController _tiempoController;
  late TextEditingController _categoriaController;

  @override
  void initState() {
    super.initState();
    _cargarDatosReceta();
  }

  Future<void> _cargarDatosReceta() async {
    try {
      var snapshot = await DB.obtenerDetallesReceta(widget.recetaId);
      setState(() {
        recetaData = snapshot;
        isLoading = false;
        _nombreController =
            TextEditingController(text: recetaData.data()?['nombreReceta']);
        _ingredientesController = TextEditingController(
            text: recetaData.data()?['ingredientes'].join(', '));
        _pasosController = TextEditingController(
            text: recetaData.data()?['pasosPreparacion'].join(', '));
        _tiempoController = TextEditingController(
            text: recetaData.data()?['tiempoPreparacion'].toString());
        _categoriaController =
            TextEditingController(text: recetaData.data()?['categoria']);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ingredientesController.dispose();
    _pasosController.dispose();
    _tiempoController.dispose();
    _categoriaController.dispose();
    super.dispose();
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
        title: const Text('Editar Receta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Lógica para guardar los cambios en la receta
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nombreController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de la receta'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre para la receta';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoriaController,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una categoría';
                    }
                    return null;
                  },
                ),
                // Agregar campos para los ingredientes
                TextFormField(
                  controller: _ingredientesController,
                  decoration: const InputDecoration(labelText: 'Ingredientes'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese los ingredientes';
                    }
                    return null;
                  },
                ),
                // Agregar campos para los pasos de preparación
                TextFormField(
                  controller: _pasosController,
                  decoration:
                      const InputDecoration(labelText: 'Pasos de preparación'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese los pasos de preparación';
                    }
                    return null;
                  },
                ),
                // Agregar campo para el tiempo de preparación
                TextFormField(
                  controller: _tiempoController,
                  decoration: const InputDecoration(
                      labelText: 'Tiempo de preparación (minutos)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el tiempo de preparación';
                    }
                    return null;
                  },
                ),
                // Widget para calificaciones
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calificación:',
                          style: Theme.of(context).textTheme.headlineMedium),
                      Slider(
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: _rating.round().toString(),
                        value: _rating,
                        onChanged: (newRating) {
                          setState(() => _rating = newRating);
                        },
                      ),
                    ],
                  ),
                ),
                // Botón para guardar los cambios
                ElevatedButton(
                  onPressed: () {
                    // Verifica si el formulario es válido
                    if (_formKey.currentState!.validate()) {
                      DB.actualizarReceta(
                          recetaData.id, recetaData as Map<String, dynamic>);
                    }
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

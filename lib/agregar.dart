import 'package:flutter/material.dart';
import 'serviciosremotos.dart';

class AddReceta extends StatefulWidget {
  final VoidCallback onRecetaAdded;

  const AddReceta({super.key, required this.onRecetaAdded});

  @override
  State<AddReceta> createState() => _AddRecetaState();
}

class _AddRecetaState extends State<AddReceta> {
  final _formKey = GlobalKey<FormState>();
  String _nombreReceta = '';
  List<String> _ingredientes = [''];
  List<String> _pasosPreparacion = [''];
  int _tiempoPreparacion = 0;
  String _categoria = '';
  String _urlImagen = '';

  void _addNewField(List<String> items, String hint) {
    items.add('');
    setState(() {});
  }

  void _saveReceta() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      final recetaMap = {
        'nombreReceta': _nombreReceta,
        'ingredientes': _ingredientes
            .where((ingrediente) => ingrediente.isNotEmpty)
            .toList(),
        'pasosPreparacion':
            _pasosPreparacion.where((paso) => paso.isNotEmpty).toList(),
        'tiempoPreparacion': _tiempoPreparacion,
        'categoria': _categoria,
        'foto': _urlImagen,
      };

      try {
        await DB.insertar(recetaMap);
        widget.onRecetaAdded(); // Llama al callback
        Navigator.pop(context);
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Receta"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nombre de la Receta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre de la receta';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nombreReceta = value!;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ..._ingredientes.map((ingrediente) {
                return TextFormField(
                  decoration: const InputDecoration(labelText: 'Ingrediente'),
                  validator: (value) {
                    if (_ingredientes.first == ingrediente &&
                        (value == null || value.isEmpty)) {
                      return 'Por favor ingresa al menos un ingrediente';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      _ingredientes[_ingredientes.indexOf(ingrediente)] = value;
                    }
                  },
                );
              }).toList(),
              ElevatedButton(
                child: const Text('Agregar Ingrediente'),
                onPressed: () => _addNewField(_ingredientes, 'Ingrediente'),
              ),
              ..._pasosPreparacion.map((paso) {
                return TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Paso de Preparación'),
                  validator: (value) {
                    if (_pasosPreparacion.first == paso &&
                        (value == null || value.isEmpty)) {
                      return 'Por favor ingresa al menos un paso de preparación';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      _pasosPreparacion[_pasosPreparacion.indexOf(paso)] =
                          value;
                    }
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                );
              }).toList(),
              ElevatedButton(
                child: const Text('Agregar Paso de Preparación'),
                onPressed: () =>
                    _addNewField(_pasosPreparacion, 'Paso de Preparación'),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Tiempo de Preparación (minutos)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el tiempo de preparación';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tiempoPreparacion = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una categoría';
                  }
                  return null;
                },
                onSaved: (value) {
                  _categoria = value!;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'URL de la Imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la URL de la imagen';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urlImagen = value!;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveReceta,
                child: const Text('Guardar Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

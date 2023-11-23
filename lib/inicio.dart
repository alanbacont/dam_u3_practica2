import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u3_practica2/agregar.dart';
import 'package:dam_u3_practica2/busq.dart';
import 'package:dam_u3_practica2/catego.dart';
import 'package:dam_u3_practica2/detalles.dart';
import 'package:dam_u3_practica2/serviciosremotos.dart';
import 'package:dam_u3_practica2/todas.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;
  List<QueryDocumentSnapshot> _recetasDestacadas = [];
  Set<String> _categorias = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    _recetasDestacadas = await DB.obtenerRecetasDestacadas();
    _categorias = await DB.obtenerCategorias();
    setState(() {});
  }

  void _onRecetaAdded() {
    _cargarDatos();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gastronote',
          style: TextStyle(fontSize: 30),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 6.0),
          child: Image.asset('assets/images/icono.png'),
        ),
      ),
      body: dinamico(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddReceta(onRecetaAdded: _onRecetaAdded)),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget dinamico() {
    switch (_selectedIndex) {
      case 0:
        {
          if (_recetasDestacadas.isEmpty || _categorias.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Recetas Destacadas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SizedBox(
                    height: 240, // Altura para el contenedor de imágenes
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _recetasDestacadas.length,
                      itemBuilder: (context, index) {
                        var receta = _recetasDestacadas[index].data()
                            as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DetallesReceta(
                                          recetaId:
                                              _recetasDestacadas[index].id),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                      child: Image.network(
                                        receta['foto'],
                                        fit: BoxFit.fill,
                                        height: 176,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        receta['nombreReceta'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        'Categoría: ${receta['categoria']}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Categorías',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Número de columnas
                    crossAxisSpacing: 10, // Espacio horizontal entre tarjetas
                    mainAxisSpacing: 10, // Espacio vertical entre tarjetas
                    childAspectRatio: 4 /
                        1, // Proporción de las tarjetas para que sea más ancha que alta
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      String categoria = _categorias.elementAt(index);
                      return InkWell(
                        onTap: () {
                          // Aquí es donde manejas la navegación
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetallesCat(categoria: categoria),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.indigo[100],
                          child: Center(
                            child: Text(
                              categoria,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount:
                        _categorias.length, // Número de categorías únicas
                  ),
                ),
              ),
            ],
          );
        }
      case 1:
        {
          return Busqueda();
        }
      case 2:
      {
        return todasRec();
      }
      case 3:
        {
          return const Center(
            child: Text("Alan Martin Barocio Contreras"),
          );
        }
      default:
        {
          return Center();
        }
    }
  }
}

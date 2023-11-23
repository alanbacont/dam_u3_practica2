import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Busqueda extends StatefulWidget {
  const Busqueda({Key? key}) : super(key: key);

  @override
  _BusquedaState createState() => _BusquedaState();
}

class _BusquedaState extends State<Busqueda> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allRecetas = [];
  List<Map<String, dynamic>> _filteredRecetas = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchRecetas();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecetas() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('receta').get();
    setState(() {
      _allRecetas = querySnapshot.docs.map((doc) => doc.data()).toList();
      _filteredRecetas = _allRecetas;
    });
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredRecetas = _allRecetas;
      });
    } else {
      setState(() {
        _filteredRecetas = _allRecetas.where((receta) {
          return receta['nombreReceta']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              receta['categoria']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Recetas'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 5.0,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: _filteredRecetas.length,
        itemBuilder: (context, index) {
          final receta = _filteredRecetas[index];
          return Card(
            elevation: 4.0,
            child: Column(
              children: [
                Image.network(
                  receta['foto'],
                  fit: BoxFit.cover,
                  height: 100,
                ),
                ListTile(
                  title: Text(receta['nombreReceta']),
                  subtitle: Text('Categoria: ${receta['categoria']}'),
                  trailing: Icon(Icons.food_bank),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

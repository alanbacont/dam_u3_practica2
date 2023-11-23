import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseRemota = FirebaseFirestore.instance;

class DB {
  static Stream<QuerySnapshot<Map<String, dynamic>>> obtenerRecetas() {
    return baseRemota.collection('receta').snapshots();
  }

  static Future<List<QueryDocumentSnapshot>> obtenerRecetasDestacadas() async {
    var querySnapshot = await baseRemota.collection("receta").get();
    return querySnapshot.docs;
  }

  static Future<Set<String>> obtenerCategorias() async {
    var querySnapshot = await baseRemota.collection("receta").get();
    return querySnapshot.docs.map((doc) => doc['categoria'] as String).toSet();
  }

  static Future insertar(Map<String, dynamic> receta) async {
    return await baseRemota.collection("receta").add(receta);
  }

  static Future<void> actualizarReceta(String recetaId, Map<String, dynamic> datosActualizados) async {
    await baseRemota.collection('receta').doc(recetaId).update(datosActualizados);
  }

  static Future eliminar(String id) async {
    return await baseRemota.collection("receta").doc(id).delete();
  }

  static Future<List<QueryDocumentSnapshot>> obtenerRecetasPorCategoria(
      String categoria) async {
    var querySnapshot = await baseRemota
        .collection('receta')
        .where('categoria', isEqualTo: categoria)
        .get();
    return querySnapshot.docs;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> obtenerDetallesReceta(
      String recetaId) async {
    return FirebaseFirestore.instance.collection('receta').doc(recetaId).get();
  }

  static double calcularCalificacionPromedio(List<dynamic> calificaciones) {
    if (calificaciones.isEmpty) return 0;

    var sum = calificaciones.map((c) => c as num).reduce((a, b) => a + b);
    return sum / calificaciones.length;
  }
}

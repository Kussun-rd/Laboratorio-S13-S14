import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/trabajador.dart';

class TrabajadorProvider with ChangeNotifier {
  List<Trabajador> _trabajadores = [];

  List<Trabajador> get trabajadores => _trabajadores;

  late Box<Trabajador> _trabajadorBox;

  Future<void> init() async {
    _trabajadorBox = await Hive.openBox<Trabajador>('trabajadores');
    _trabajadores = _trabajadorBox.values.toList();
    notifyListeners();
  }

  void agregarTrabajador(Trabajador t) async {
    await _trabajadorBox.add(t);
    _trabajadores = _trabajadorBox.values.toList();
    notifyListeners();
  }

  void actualizarTrabajador(int index, Trabajador t) async {
    await _trabajadorBox.putAt(index, t);
    _trabajadores = _trabajadorBox.values.toList();
    notifyListeners();
  }

  void eliminarTrabajador(int index) async {
    await _trabajadorBox.deleteAt(index);
    _trabajadores = _trabajadorBox.values.toList();
    notifyListeners();
  }

  Trabajador getTrabajador(int index) {
    return _trabajadores[index];
  }
}

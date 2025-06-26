import 'dart:convert';
import 'dart:html' as html;

import 'package:csv/csv.dart';
import '../models/trabajador.dart';

class Exporter {
  static void exportCSV(List<Trabajador> trabajadores) {
    final headers = ['Nombres', 'Apellidos', 'FechaNacimiento', 'Sueldo'];

    final rows = trabajadores.map((t) {
      return [
        t.nombres,
        t.apellidos,
        t.fechaNacimiento.toIso8601String(),
        t.sueldo.toStringAsFixed(2),
      ];
    }).toList();

    final csvData = const ListToCsvConverter().convert([headers, ...rows]);

    final blob = html.Blob([csvData], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'trabajadores.csv')
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/trabajador_provider.dart';
import 'trabajador_form.dart';

class TrabajadorList extends StatelessWidget {
  const TrabajadorList({super.key});

  void _editarTrabajador(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        content: TrabajadorForm(index: index),
      ),
    );
  }

  void _confirmarEliminacion(BuildContext context, int index) {
    final provider = Provider.of<TrabajadorProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar este trabajador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              provider.eliminarTrabajador(index);
              Navigator.of(ctx).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trabajador eliminado correctamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.delete),
            label: const Text('Eliminar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrabajadorProvider>(context);
    final trabajadores = provider.trabajadores;

    if (trabajadores.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('No hay trabajadores registrados.',
              style: TextStyle(fontSize: 18)),
        ),
      );
    }

return Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 800),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                MaterialStateColor.resolveWith((_) => Colors.indigo.shade50),
            columnSpacing: 32,
            horizontalMargin: 16,
            columns: const [
              DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              DataColumn(label: Text('Apellidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              DataColumn(label: Text('Nacimiento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              DataColumn(label: Text('Sueldo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            ],
            rows: List.generate(provider.trabajadores.length, (index) {
              final t = provider.trabajadores[index];
              return DataRow(cells: [
                DataCell(Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: t.imagePath != null
                          ? NetworkImage(t.imagePath!)
                          : null,
                      child: t.imagePath == null
                          ? const Icon(Icons.person, size: 18)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(t.nombres, style: const TextStyle(fontSize: 15)),
                  ],
                )),
                DataCell(Text(t.apellidos, style: const TextStyle(fontSize: 15))),
                DataCell(Text(DateFormat('dd/MM/yyyy').format(t.fechaNacimiento))),
                DataCell(Text(
                  '\$${t.sueldo.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                )),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      tooltip: 'Editar',
                      onPressed: () => _editarTrabajador(context, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar',
                      onPressed: () => _confirmarEliminacion(context, index),
                    ),
                  ],
                )),
              ]);
            }),
          ),
        ),
      ),
    ),
  ),
);
}
}

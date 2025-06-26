import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trabajador_provider.dart';
import '../widgets/trabajador_form.dart';
import '../widgets/trabajador_list.dart';
import '../utils/exporter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _mostrarFormulario(BuildContext context, {int? index}) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    if (isSmallScreen) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (_) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: TrabajadorForm(index: index),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          content: TrabajadorForm(index: index),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrabajadorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Trabajadores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Exportar CSV',
            onPressed: () {
              final trabajadores = provider.trabajadores;
              if (trabajadores.isNotEmpty) {
                Exporter.exportCSV(trabajadores);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No hay datos para exportar'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: TrabajadorList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

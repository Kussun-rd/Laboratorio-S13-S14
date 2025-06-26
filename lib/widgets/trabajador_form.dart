import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import '../models/trabajador.dart';
import '../providers/trabajador_provider.dart';

class TrabajadorForm extends StatefulWidget {
  final int? index;

  const TrabajadorForm({super.key, this.index});

  @override
  State<TrabajadorForm> createState() => _TrabajadorFormState();
}

class _TrabajadorFormState extends State<TrabajadorForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _sueldoCtrl = TextEditingController();
  DateTime? _fechaNacimiento;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      final trabajador =
          context.read<TrabajadorProvider>().getTrabajador(widget.index!);
      _nombresCtrl.text = trabajador.nombres;
      _apellidosCtrl.text = trabajador.apellidos;
      _sueldoCtrl.text = trabajador.sueldo.toString();
      _fechaNacimiento = trabajador.fechaNacimiento;
      _imageBase64 = trabajador.imagePath;
    }
  }

  @override
  void dispose() {
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _sueldoCtrl.dispose();
    super.dispose();
  }

  void _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      setState(() {
        _fechaNacimiento = fecha;
      });
    }
  }

  void _seleccionarImagen() {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageBase64 = reader.result as String?;
        });
      });
    });
  }

  void _guardar() {
    if (_formKey.currentState!.validate() && _fechaNacimiento != null) {
      final nuevo = Trabajador(
        nombres: _nombresCtrl.text.trim(),
        apellidos: _apellidosCtrl.text.trim(),
        fechaNacimiento: _fechaNacimiento!,
        sueldo: double.parse(_sueldoCtrl.text),
        imagePath: _imageBase64,
      );

      final provider = context.read<TrabajadorProvider>();
      final esNuevo = widget.index == null;

      if (esNuevo) {
        provider.agregarTrabajador(nuevo);
      } else {
        provider.actualizarTrabajador(widget.index!, nuevo);
      }

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(esNuevo
              ? 'Trabajador registrado correctamente'
              : 'Trabajador actualizado'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.index == null ? 'Nuevo Trabajador' : 'Editar Trabajador',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundImage: _imageBase64 != null
                    ? NetworkImage(_imageBase64!)
                    : null,
                child: _imageBase64 == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              TextButton.icon(
                onPressed: _seleccionarImagen,
                icon: const Icon(Icons.image),
                label: const Text('Seleccionar imagen'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nombresCtrl,
                decoration: const InputDecoration(labelText: 'Nombres'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Ingrese nombres' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _apellidosCtrl,
                decoration: const InputDecoration(labelText: 'Apellidos'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Ingrese apellidos' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _sueldoCtrl,
                decoration: const InputDecoration(labelText: 'Sueldo'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Ingrese sueldo';
                  final n = double.tryParse(val);
                  return n == null || n < 0
                      ? 'Ingrese un valor válido'
                      : null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaNacimiento == null
                          ? 'Fecha de nacimiento no seleccionada'
                          : 'Nacimiento: ${DateFormat('dd/MM/yyyy').format(_fechaNacimiento!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _seleccionarFecha,
                    child: const Text('Seleccionar Fecha'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

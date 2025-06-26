import 'package:hive/hive.dart';

part 'trabajador.g.dart';

@HiveType(typeId: 0)
class Trabajador extends HiveObject {
  @HiveField(0)
  String nombres;

  @HiveField(1)
  String apellidos;

  @HiveField(2)
  DateTime fechaNacimiento;

  @HiveField(3)
  double sueldo;

  @HiveField(4)
  String? imagePath; 

  Trabajador({
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.sueldo,
    this.imagePath,
  });
}

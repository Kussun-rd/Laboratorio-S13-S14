# 🧑‍💼 CRUD de Trabajadores en Flutter Web

Este proyecto es una aplicación **CRUD (Crear, Leer, Actualizar, Eliminar)** desarrollada con **Flutter Web**, diseñada para gestionar trabajadores de forma local, visual y responsiva.

---

## 🚀 Características principales

- ✅ Crear, editar y eliminar trabajadores  
- ✅ Guardado persistente en navegador con [Hive](https://pub.dev/packages/hive)  
- ✅ Selección de imagen de perfil para cada trabajador  
- ✅ Interfaz moderna y profesional basada en Material 3  
- ✅ Exportación a archivo `.csv` (Excel compatible)  
- ✅ Adaptado para pantallas pequeñas y móviles  
- ✅ Confirmaciones al eliminar y notificaciones visuales (Snackbars)

---

## 🧱 Tecnologías utilizadas

- ✅ **Flutter 3+**
- ✅ **Flutter Web**
- ✅ **Hive** (base de datos local para web y escritorio)
- ✅ **Provider** (gestión de estado)
- ✅ **CSV** para exportación de datos
- ✅ `dart:html` para selección de imágenes

---

## 📁 Estructura del proyecto

lib/
├── models/ # Modelo Trabajador (Hive)
├── providers/ # Provider para lógica CRUD
├── widgets/ # Formulario, tabla y componentes UI
├── pages/ # Página principal
├── utils/ # Exportador de CSV
└── main.dart # Configuración principal

---

## 📦 Cómo ejecutar el proyecto
1. Clona el repositorio:
   ```bash
   git clone https://github.com/Kussun-rd/Laboratorio-S13-S14.git
   cd Laboratorio-S13-S14
2. Instala las dependencias:
   ```bash
   flutter pub get
3. Genera los adaptadores de Hive::
   ```bash
   dart run build_runner build --delete-conflicting-outputs
4. Ejecuta la aplicación en el navegador:
   ```bash
   flutter run -d chrome

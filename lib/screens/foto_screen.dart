import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class RegistrarProyecto extends StatefulWidget {
  const RegistrarProyecto({super.key});

  @override
  State<RegistrarProyecto> createState() => _RegistrarProyectoState();
}

class _RegistrarProyectoState extends State<RegistrarProyecto> {
  Uint8List? fotoBytes; // Variable para almacenar la foto seleccionada
  final _formKey = GlobalKey<FormState>();

  // Método para abrir la cámara y tomar una foto
  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      try {
        final bytes = await pickedFile.readAsBytes();

        // Redimensionar la imagen antes de almacenarla
        final image = img.decodeImage(bytes);
        if (image == null) {
          throw Exception('Error al decodificar la imagen');
        }

        // Redimensionar la imagen a una resolución más baja
        final resizedImage = img.copyResize(image, width: 300);

        // Comprimir la imagen ajustando la calidad de compresión
        final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

        setState(() {
          fotoBytes = Uint8List.fromList(compressedBytes);
        });
      } catch (e) {
        print('Error al procesar la imagen: $e');
        // Manejar el error aquí
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Tomar foto',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _tomarFoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar Foto'),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange),
                ),
              ),
              // Visualización de la foto seleccionada
              if (fotoBytes != null)
                Image.memory(
                  fotoBytes!,
                  height: 500,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

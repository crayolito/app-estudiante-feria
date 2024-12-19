import 'dart:convert';
import 'dart:io';

import 'package:app_feria2024/services/media-handler.service.dart';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MediaHandlerServiceImpl implements MediaHandlerService {
  final ImagePickerPlatform imagePickerImplementation =
      ImagePickerPlatform.instance;
  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  // Implementación del nuevo método para convertir a base64
  @override
  Future<String?> imageToBase64(String filePath) async {
    try {
      // Leer el archivo
      final File file = File(filePath);
      if (!await file.exists()) {
        throw Exception('El archivo no existe');
      }

      // Decodificar la imagen
      final bytes = await file.readAsBytes();
      var image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('No se pudo decodificar la imagen');
      }

      // Redimensionar más agresivamente
      const maxWidth = 600.0; // Reducido de 800 a 600
      const maxHeight = 600.0; // Reducido de 800 a 600

      double ratioX = maxWidth / image.width;
      double ratioY = maxHeight / image.height;
      double ratio = ratioX < ratioY ? ratioX : ratioY;

      int newWidth = (image.width * ratio).round();
      int newHeight = (image.height * ratio).round();

      // Redimensionar la imagen siempre, no solo si excede el máximo
      image = img.copyResize(image,
          width: newWidth,
          height: newHeight,
          interpolation: img.Interpolation.linear);

      // Primera pasada de compresión
      List<int> compressedBytes =
          img.encodeJpg(image, quality: 60 // Reducido de 85 a 60
              );

      // Convertir a base64
      String base64String = base64Encode(compressedBytes);
      int finalSize = base64String.length;
      print('Tamaño inicial en KB: ${finalSize / 1024}');

      // Si aún es muy grande, reducir más
      if (finalSize > 500000) {
        // Reducido de 1MB a 500KB
        // Segunda pasada con más compresión
        compressedBytes = img.encodeJpg(image, quality: 40 // Muy agresivo
            );
        base64String = base64Encode(compressedBytes);
        finalSize = base64String.length;
        print(
            'Tamaño después de segunda compresión en KB: ${finalSize / 1024}');
      }

      // Si aún sigue siendo muy grande, última pasada
      if (finalSize > 300000) {
        // 300KB límite final
        // Reducir dimensiones aún más
        image = img.copyResize(image,
            width: (newWidth * 0.7).round(), // Reducir 30% más
            height: (newHeight * 0.7).round(),
            interpolation: img.Interpolation.linear);

        compressedBytes =
            img.encodeJpg(image, quality: 30 // Extremadamente agresivo
                );
        base64String = base64Encode(compressedBytes);
        finalSize = base64String.length;
        print(
            'Tamaño final después de compresión extrema en KB: ${finalSize / 1024}');
      }

      // Verificación final
      if (finalSize > 250000) {
        // Si aún es mayor a 250KB
        throw Exception(
            'La imagen es demasiado grande incluso después de la compresión');
      }

      return 'data:image/jpeg;base64,$base64String';
    } catch (e) {
      print('Error al procesar la imagen: $e');
      return null;
    }
  }

  // READ : METODOS PARA IMAGENES
  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo == null) return null;
    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (photo == null) return null;
    return photo.path;
  }

  @override
  Future<String?> uploadImage(String filePath) async {
    final Dio dio = Dio();
    String url = 'https://api.cloudinary.com/v1_1/da9xsfose/image/upload';
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'upload_preset': 'fqw7ooma',
    });

    try {
      var response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        // Aquí puedes extraer la URL de la imagen de la respuesta
        // Por ejemplo: return response.data['secure_url'];
        return response.data['secure_url'].toString();
      } else {
        throw Exception(
            "Error al subir la imagen, código de estado: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al subir la imagen: $e");
    }
  }

  // READ : METODOS PARA AUDIO/VOZ

  @override
  void dispose() {
    _speech.cancel();
  }

  @override
  Future<bool> initSpeechService() async {
    if (_isInitialized) return true;

    // Solicitar permiso de micrófono
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Permiso de micrófono denegado');
    }

    // Inicializar el servicio
    _isInitialized = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );

    return _isInitialized;
  }

  @override
  // TODO: implement isAvailable
  bool get isAvailable => throw UnimplementedError();

  @override
  bool isListening() {
    return _speech.isListening;
  }

  @override
  Future<void> startListening(
      {required Function(String text) onResult, String? localeId}) async {
    if (!_isInitialized) {
      await initSpeechService();
    }

    if (!_speech.isListening) {
      await _speech.listen(
        onResult: (result) {
          final recognizedWords = result.recognizedWords;
          onResult(recognizedWords);
        },
        localeId: localeId ?? 'es_ES',
        cancelOnError: true,
        partialResults: true,
      );
    }
  }

  @override
  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}

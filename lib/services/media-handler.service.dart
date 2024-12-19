// Actualización de la interfaz abstracta
abstract class MediaHandlerService {
  // Métodos existentes para imágenes
  Future<String?> takePhoto();
  Future<String?> selectPhoto();
  Future<String?> uploadImage(String filePath);

  // Nuevo método para convertir a base64
  Future<String?> imageToBase64(String filePath);

  // Métodos existentes para audio/voz
  Future<bool> initSpeechService();
  Future<void> startListening({
    required Function(String text) onResult,
    String? localeId,
  });
  Future<void> stopListening();
  bool isListening();
  bool get isAvailable;
  void dispose();
}

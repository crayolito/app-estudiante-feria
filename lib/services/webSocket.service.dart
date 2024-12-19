import 'dart:async';
import 'dart:convert';
import 'dart:io';

class WebSocketService {
  static WebSocketService? _instance;
  WebSocket? _socket;
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  static const int MAX_RECONNECT_ATTEMPTS = 3;
  static const Duration RECONNECT_DELAY = Duration(seconds: 5);

  final _connectionStateController = StreamController<bool>.broadcast();
  Stream<bool> get connectionState => _connectionStateController.stream;

  WebSocketService._internal() {
    print('Iniciando WebSocketService...');
    conectarSocket();
  }

  factory WebSocketService() {
    _instance ??= WebSocketService._internal();
    return _instance!;
  }

  Future<void> conectarSocket() async {
    if (_isConnecting) {
      print('Ya hay un intento de conexión en proceso...');
      return;
    }

    _isConnecting = true;
    print('Iniciando intento de conexión #${_reconnectAttempts + 1}...');

    try {
      // Limpieza del socket anterior si existe
      if (_socket != null) {
        print('Cerrando socket anterior...');
        await _socket!.close().timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            print('Timeout al cerrar socket anterior');
            _socket = null;
          },
        );
        _socket = null;
      }

      print('Intentando conectar a ws://192.168.137.1:3000...');
      // READ : CAMBIAR AQUI MAÑANA PARA EL USO DE LA IP DEL SERVIDOR
      _socket = await WebSocket.connect('ws://192.168.1.101:3000')
          .timeout(const Duration(seconds: 3))
          .catchError((error) {
        print('Error durante la conexión: $error');
        throw error;
      });

      print('¡Conexión establecida exitosamente!');
      _isConnecting = false;
      _reconnectAttempts = 0;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      _connectionStateController.add(true);

      // Configurar stream listener
      _socket!.listen(
        (data) {
          print('Mensaje recibido: $data');
        },
        onDone: () {
          print('Conexión cerrada normalmente');
          _handleDisconnection();
        },
        onError: (error) {
          print('Error en la conexión: $error');
          _handleDisconnection();
        },
        cancelOnError: true,
      );
    } on TimeoutException {
      print('Timeout al intentar conectar');
      _handleDisconnection();
    } catch (e) {
      print('Error durante la conexión: $e');
      _handleDisconnection();
    }
  }

  void _handleDisconnection() {
    _isConnecting = false;
    _socket = null;
    _connectionStateController.add(false);

    // Incrementar contador de intentos
    _reconnectAttempts++;

    if (_reconnectAttempts <= MAX_RECONNECT_ATTEMPTS) {
      print(
          'Iniciando reconexión, intento $_reconnectAttempts de $MAX_RECONNECT_ATTEMPTS');
      _iniciarReconexion();
    } else {
      print(
          'Máximo número de intentos alcanzado. Deteniendo reconexión automática.');
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      // Reiniciar contador después de un tiempo más largo
      Timer(const Duration(seconds: 30), () {
        print('Reiniciando contador de intentos...');
        _reconnectAttempts = 0;
        conectarSocket();
      });
    }
  }

  void _iniciarReconexion() {
    _reconnectTimer?.cancel();

    print(
        'Programando próximo intento de reconexión en ${RECONNECT_DELAY.inSeconds} segundos...');
    _reconnectTimer = Timer(RECONNECT_DELAY, () {
      if (!_isConnecting &&
          (_socket == null || _socket!.readyState != WebSocket.open)) {
        conectarSocket();
      }
    });
  }

  Future<void> reconectarManualmente() async {
    print('Iniciando reconexión manual...');
    _reconnectAttempts = 0;
    _reconnectTimer?.cancel();
    await conectarSocket();
  }

  void enviarMensaje(String texto) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      final mensaje = {
        'tipo': 'mensaje-chat-general',
        'data': {
          'texto': texto,
          'fecha': DateTime.now().toIso8601String(),
        }
      };
      _socket!.add(jsonEncode(mensaje));
      print('Mensaje enviado: $texto');
    } else {
      print('No se pudo enviar el mensaje: socket no conectado');
    }
  }

  void dispose() {
    print('Disposing WebSocketService...');
    _reconnectTimer?.cancel();
    _socket?.close();
    _connectionStateController.close();
  }

  bool get isConnected =>
      _socket != null && _socket!.readyState == WebSocket.open;
}

import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:app_feria2024/features/home/presentation/widgets/botonPrincipales.widget.dart';
import 'package:app_feria2024/features/home/presentation/widgets/manosServoMotor.widget.dart';
import 'package:app_feria2024/services/webSocket.service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PanelControl extends StatefulWidget {
  const PanelControl({super.key});

  @override
  State<PanelControl> createState() => _PanelControlState();
}

class _PanelControlState extends State<PanelControl> {
  String estadoActualMotor = '';
  double servoIzquierdo = 90;
  double servoDerecho = 90;
  bool ojosActivos = false;
  bool iaActiva = false;
  bool saludoActivo = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  int lastServoStep =
      4; // Para rastrear el último paso de 20 grados (90/20 = 4.5)

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        saludoActivo = false;
      });
    });
  }

  void updateServos(double newValue) {
    final webSocketService = WebSocketService();
    // Calculamos el paso actual (newValue/20 redondeado)
    int currentStep = (newValue / 20).round();

    // Si el paso ha cambiado, enviamos el comando correspondiente
    if (currentStep > lastServoStep) {
      webSocketService.enviarMensaje('subirServo');
      print("Subir servo");
    } else if (currentStep < lastServoStep) {
      webSocketService.enviarMensaje('bajarServo');
      print("Bajar servo");
    }

    lastServoStep = currentStep;

    setState(() {
      servoIzquierdo = newValue;
      servoDerecho = newValue;
    });
  }

  // Función para manejar los cambios de dirección
  void manejarDireccion(String nuevaDireccion) {
    final webSocketService = WebSocketService();

    // Si hay un movimiento activo, primero lo detenemos
    if (estadoActualMotor != '') {
      switch (estadoActualMotor) {
        case 'motor-adelante':
          webSocketService.enviarMensaje('motor-dadelante');
          break;
        case 'motor-atras':
          webSocketService.enviarMensaje('motor-datras');
          break;
        case 'motor-aderecha':
          webSocketService.enviarMensaje('motor-dderecha');
          break;
        case 'motor-aizquierda':
          webSocketService.enviarMensaje('motor-dizquierda');
          break;
      }
    }

    // Actualizamos el nuevo estado y enviamos el nuevo comando
    estadoActualMotor = nuevaDireccion;
    webSocketService.enviarMensaje(nuevaDireccion);
  }

  // Función para detener el movimiento actual
  void detenerMovimiento() {
    final webSocketService = WebSocketService();

    switch (estadoActualMotor) {
      case 'motor-adelante':
        webSocketService.enviarMensaje('motor-dadelante');
        break;
      case 'motor-atras':
        webSocketService.enviarMensaje('motor-datras');
        break;
      case 'motor-aderecha':
        webSocketService.enviarMensaje('motor-dderecha');
        break;
      case 'motor-aizquierda':
        webSocketService.enviarMensaje('motor-dizquierda');
        break;
    }
    estadoActualMotor = '';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final webSocketService = WebSocketService();
    return Container(
      width: size.width * 0.92,
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.width * 0.02),
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      decoration: BoxDecoration(
        color: kTerciaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(size.width * 0.03),
        border: Border.all(color: kPrimaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // READ : TITULO DEL PANEL
          Text(
            'Panel de Control',
            style: GoogleFonts.kanit(
              color: kPrimaryColor,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.01),

          // READ : Botones Direccionales en forma de cruz
          Container(
            padding: EdgeInsets.all(size.width * 0.02),
            decoration: BoxDecoration(
              color: kTerciaryColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(size.width * 0.03),
              border: Border.all(
                color: kPrimaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Botón Arriba
                _BotonDireccional(
                  icono: FontAwesomeIcons.arrowUp,
                  onPresionado: () => manejarDireccion('motor-adelante'),
                  onLiberado: detenerMovimiento,
                  size: size,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BotonDireccional(
                      icono: FontAwesomeIcons.arrowLeft,
                      onPresionado: () => manejarDireccion('motor-aizquierda'),
                      onLiberado: detenerMovimiento,
                      size: size,
                    ),
                    SizedBox(width: size.width * 0.15),
                    _BotonDireccional(
                      icono: FontAwesomeIcons.arrowRight,
                      onPresionado: () => manejarDireccion('motor-aderecha'),
                      onLiberado: detenerMovimiento,
                      size: size,
                    ),
                  ],
                ),
                _BotonDireccional(
                  icono: FontAwesomeIcons.arrowDown,
                  onPresionado: () => manejarDireccion('motor-atras'),
                  onLiberado: detenerMovimiento,
                  size: size,
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),

          // READ: Botones Principales (IA, Ojos, Saludo)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BotonPrincipal(
                icono: FontAwesomeIcons.brain,
                texto: "IA",
                activo: iaActiva,
                onTap: () {
                  context.push("/walle");
                },
                size: size,
              ),
              BotonPrincipal(
                icono: FontAwesomeIcons.eye,
                texto: "Ojos",
                activo: ojosActivos,
                onTap: () {
                  if (!ojosActivos) {
                    webSocketService.enviarMensaje('led-on');
                  } else {
                    webSocketService.enviarMensaje('led-off');
                  }
                  setState(() {
                    ojosActivos = !ojosActivos;
                  });
                },
                size: size,
              ),
              BotonPrincipal(
                icono: FontAwesomeIcons.robot,
                texto: "Saludo",
                activo: saludoActivo,
                onTap: () async {
                  setState(() {
                    saludoActivo = true;
                  });
                  await audioPlayer.play(AssetSource('sonidoWalle.mp3'));
                },
                size: size,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),

          // READ : Control de Brazos
          Row(
            children: [
              Expanded(
                child: ControlServo(
                  titulo: "Brazo Izquierdo",
                  valor: servoIzquierdo,
                  onChanged: (value) => updateServos(value),
                  size: size,
                  icono: FontAwesomeIcons.handBackFist,
                  espejado: true,
                  minValue: 90,
                  maxValue: 180,
                ),
              ),
              SizedBox(width: size.width * 0.04),
              Expanded(
                child: ControlServo(
                  titulo: "Brazo Derecho",
                  valor: servoDerecho,
                  onChanged: (value) => updateServos(value),
                  size: size,
                  icono: FontAwesomeIcons.handBackFist,
                  espejado: false,
                  minValue: 90,
                  maxValue: 180,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BotonDireccional extends StatelessWidget {
  final IconData icono;
  final VoidCallback onPresionado;
  final VoidCallback onLiberado;
  final Size size;

  const _BotonDireccional({
    required this.icono,
    required this.onPresionado,
    required this.onLiberado,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPresionado(),
      onTapUp: (_) => onLiberado(),
      onTapCancel: () => onLiberado(),
      child: Container(
        width: size.width * 0.15,
        height: size.width * 0.15,
        margin: EdgeInsets.all(size.width * 0.02),
        decoration: BoxDecoration(
          color: kTerciaryColor,
          borderRadius: BorderRadius.circular(size.width * 0.03),
          border: Border.all(color: kPrimaryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kPrimaryColor.withOpacity(0.2),
              kPrimaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: Icon(
          icono,
          color: kPrimaryColor,
          size: size.width * 0.08,
        ),
      ),
    );
  }
}

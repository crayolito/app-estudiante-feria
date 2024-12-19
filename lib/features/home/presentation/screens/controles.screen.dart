// screens/controles_screen.dart
import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:app_feria2024/features/home/presentation/widgets/animaciones.widget.dart';
import 'package:app_feria2024/features/home/presentation/widgets/panelControl.widget.dart';
import 'package:app_feria2024/features/home/presentation/widgets/panelEstadisticas.widget.dart';
import 'package:app_feria2024/features/home/presentation/widgets/tituloAndEstado.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ControlesScreen extends StatefulWidget {
  const ControlesScreen({super.key});

  @override
  State<ControlesScreen> createState() => _ControlesScreenState();
}

class _ControlesScreenState extends State<ControlesScreen>
    with TickerProviderStateMixin {
  bool statusLed = false;
  final Map<String, Map<String, dynamic>> estadisticas = {
    'Tiempo activo': {
      'value': '02:45:30',
      'icon': FontAwesomeIcons.clock,
      'color': const Color(0xFF64FFDA)
    },
    'Batería': {
      'value': '85%',
      'icon': FontAwesomeIcons.batteryThreeQuarters,
      'color': const Color(0xFF69F0AE)
    },
    'Temperatura': {
      'value': '28°C',
      'icon': FontAwesomeIcons.temperatureHalf,
      'color': const Color(0xFFFF4081)
    },
    'Señal Wifi': {
      'value': '-67 dBm',
      'icon': FontAwesomeIcons.wifi,
      'color': const Color(0xFF448AFF)
    },
  };

  late BackgroundController backgroundController;

  @override
  void initState() {
    super.initState();
    backgroundController = BackgroundController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kTerciaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // READ : ANIMACIONES  DE FONDO
          AnimatedBackgroundEffect(controller: backgroundController),
          // Contenido principal
          SingleChildScrollView(
            // Añadido para evitar overflow
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
              child: Column(
                children: [
                  // READ : TITULO DE ESTADO
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: const TituloAndEstado(),
                  ),
                  // READ : PANEL DE CONTROL DEL WALLE
                  const PanelControl(),
                  SizedBox(height: size.height * 0.02),
                  // READ : ESTADISTICAS DEL WALLE
                  PanelEstadisticas(
                    statistics: estadisticas,
                    controller: backgroundController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    backgroundController.dispose();
    super.dispose();
  }
}

import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PanelMultimedia extends StatefulWidget {
  const PanelMultimedia({super.key});

  @override
  State<PanelMultimedia> createState() => _PanelMultimediaState();
}

class _PanelMultimediaState extends State<PanelMultimedia> {
  bool isLocalControl = true;

  @override
  Widget build(BuildContext context) {
    final tamano = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(tamano.width * 0.04),
      decoration: BoxDecoration(
        color: kTerciaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(tamano.width * 0.03),
        border: Border.all(color: kSecondaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: kSecondaryColor.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Toggle Switch
          Container(
            padding: EdgeInsets.all(tamano.width * 0.01),
            decoration: BoxDecoration(
              color: kTerciaryColor,
              borderRadius: BorderRadius.circular(tamano.width * 0.04),
              border: Border.all(
                color: kPrimaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Botón Control Local
                Expanded(
                  child: _ToggleButton(
                    text: "Control Local",
                    isSelected: isLocalControl,
                    onTap: () => setState(() => isLocalControl = true),
                    icon: FontAwesomeIcons.mobile,
                  ),
                ),
                // Botón Control WALL-E
                Expanded(
                  child: _ToggleButton(
                    text: "Control WALL-E",
                    isSelected: !isLocalControl,
                    onTap: () => setState(() => isLocalControl = false),
                    icon: FontAwesomeIcons.robot,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: tamano.height * 0.02),

          // Controles condicionales
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: isLocalControl ? _LocalControls() : _WallEControls(),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  const _ToggleButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tamano = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: tamano.width * 0.02,
          horizontal: tamano.width * 0.02,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(tamano.width * 0.03),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: tamano.width * 0.04,
              color: isSelected ? kPrimaryColor : kCuartoColor.withOpacity(0.5),
            ),
            SizedBox(width: tamano.width * 0.01),
            Text(
              text,
              style: GoogleFonts.kanit(
                color:
                    isSelected ? kPrimaryColor : kCuartoColor.withOpacity(0.5),
                fontSize: tamano.width * 0.03,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalControls extends StatelessWidget {
  const _LocalControls();

  @override
  Widget build(BuildContext context) {
    final tamano = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _BotonMultimedia(
          icono: FontAwesomeIcons.camera,
          texto: "Cámara",
          color: kPrimaryColor,
          tamano: tamano,
        ),
        _BotonMultimedia(
          icono: FontAwesomeIcons.image,
          texto: "Galería",
          color: kPrimaryColor,
          tamano: tamano,
        ),
        _BotonMultimedia(
          icono: FontAwesomeIcons.microphone,
          texto: "Audio",
          color: kPrimaryColor,
          tamano: tamano,
        ),
      ],
    );
  }
}

class _WallEControls extends StatelessWidget {
  const _WallEControls();

  @override
  Widget build(BuildContext context) {
    final tamano = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _BotonMultimedia(
          icono: FontAwesomeIcons.cameraRetro,
          texto: "Capturar",
          color: kSecondaryColor,
          tamano: tamano,
        ),
        _BotonMultimedia(
          icono: FontAwesomeIcons.video,
          texto: "Streaming",
          color: kSecondaryColor,
          tamano: tamano,
        ),
      ],
    );
  }
}

// Actualización del _BotonMultimedia para hacerlo más compacto
class _BotonMultimedia extends StatelessWidget {
  final IconData icono;
  final String texto;
  final Color color;
  final Size tamano;

  const _BotonMultimedia({
    required this.icono,
    required this.texto,
    required this.color,
    required this.tamano,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano.width * 0.25, // Ancho fijo proporcional
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(tamano.width * 0.03),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(tamano.width * 0.03),
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: tamano.width * 0.02,
                  spreadRadius: tamano.width * 0.005,
                ),
              ],
            ),
            child: Icon(
              icono,
              color: color,
              size: tamano.width * 0.055,
            ),
          ),
          SizedBox(height: tamano.height * 0.008),
          Text(
            texto,
            style: GoogleFonts.kanit(
              color: kCuartoColor,
              fontSize: tamano.width * 0.028,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ControlServo extends StatelessWidget {
  final String titulo;
  final double valor;
  final ValueChanged<double> onChanged;
  final Size size;
  final IconData icono;
  final bool espejado;
  final double minValue;
  final double maxValue;

  const ControlServo({
    required this.titulo,
    required this.valor,
    required this.onChanged,
    required this.size,
    required this.icono,
    required this.espejado,
    this.minValue = 90,
    this.maxValue = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scaleX: espejado ? -1 : 1,
                child: Icon(
                  icono,
                  color: kPrimaryColor,
                  size: size.width * 0.05,
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Text(
                titulo,
                style: GoogleFonts.kanit(
                  color: kPrimaryColor,
                  fontSize: size.width * 0.035,
                ),
              ),
            ],
          ),
          Text(
            '${valor.toStringAsFixed(0)}°',
            style: GoogleFonts.kanit(
              color: kPrimaryColor,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: kPrimaryColor,
              inactiveTrackColor: kPrimaryColor.withOpacity(0.3),
              thumbColor: kPrimaryColor,
              overlayColor: kPrimaryColor.withOpacity(0.2),
            ),
            child: Slider(
              value: valor,
              min: minValue,
              max: maxValue,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

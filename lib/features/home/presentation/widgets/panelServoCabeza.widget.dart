import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PanelServo extends StatelessWidget {
  final double valorServo;
  final ValueChanged<double> onChanged;
  final Size tamano;

  const PanelServo({
    super.key,
    required this.valorServo,
    required this.onChanged,
    required this.tamano,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(tamano.width * 0.04),
      decoration: BoxDecoration(
        color: kTerciaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(tamano.width * 0.03),
        border: Border.all(color: kPrimaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.robot,
                    color: kPrimaryColor,
                    size: tamano.width * 0.05,
                  ),
                  SizedBox(width: tamano.width * 0.035),
                  Text(
                    "Control de Cabeza del Robot",
                    style: GoogleFonts.kanit(
                      color: kCuartoColor,
                      fontSize: tamano.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(tamano.width * 0.03),
                ),
                child: Text(
                  "${valorServo.toInt()}°",
                  style: GoogleFonts.kanit(
                    color: kPrimaryColor,
                    fontSize: tamano.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: tamano.height * 0.02),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.anglesLeft,
                color: kPrimaryColor,
                size: tamano.width * 0.04,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: kPrimaryColor,
                    inactiveTrackColor: kPrimaryColor.withOpacity(0.2),
                    thumbColor: kPrimaryColor,
                    overlayColor: kPrimaryColor.withOpacity(0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: valorServo,
                    min: 0,
                    max: 180,
                    onChanged: onChanged,
                  ),
                ),
              ),
              Icon(
                FontAwesomeIcons.anglesRight,
                color: kPrimaryColor,
                size: tamano.width * 0.04,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

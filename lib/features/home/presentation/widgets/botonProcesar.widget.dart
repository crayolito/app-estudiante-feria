import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonProcesar extends StatelessWidget {
  const BotonProcesar({super.key});

  @override
  Widget build(BuildContext context) {
    final tamano = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: tamano.height * 0.01),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {/* Lógica de procesamiento */},
          borderRadius: BorderRadius.circular(tamano.width * 0.3),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: tamano.width * 0.1,
              vertical: tamano.width * 0.04,
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(tamano.width * 0.3),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryColor,
                  kPrimaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.microchip,
                  color: kTerciaryColor,
                  size: tamano.width * 0.06,
                ),
                SizedBox(width: tamano.width * 0.03),
                Text(
                  "PROCESAR",
                  style: GoogleFonts.kanit(
                    color: kTerciaryColor,
                    fontSize: tamano.width * 0.05,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

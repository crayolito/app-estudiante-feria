import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class IndicadoresEstado extends StatelessWidget {
  const IndicadoresEstado({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kTerciaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(size.width * 0.03),
        border: Border.all(color: kSecondaryColor, width: 1),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IndicadorEstado(
            texto: "Batería",
            valor: "85%",
            icono: FontAwesomeIcons.batteryThreeQuarters,
            color: Colors.green,
          ),
          SizedBox(height: 10),
          _IndicadorEstado(
            texto: "Señal",
            valor: "Fuerte",
            icono: FontAwesomeIcons.wifi,
            color: kPrimaryColor,
          ),
          SizedBox(height: 10),
          _IndicadorEstado(
            texto: "Temperatura",
            valor: "28°C",
            icono: FontAwesomeIcons.temperatureHalf,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _IndicadorEstado extends StatelessWidget {
  final String texto;
  final String valor;
  final IconData icono;
  final Color color;

  const _IndicadorEstado({
    required this.texto,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icono,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          "$texto: $valor",
          style: GoogleFonts.kanit(
            color: kCuartoColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

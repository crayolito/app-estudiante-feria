import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonesParteIngerior extends StatelessWidget {
  final VoidCallback onTapReset;
  final VoidCallback onTapProcesar;
  final VoidCallback onTapVolver;
  final VoidCallback onTapIA;

  const BotonesParteIngerior({
    required this.onTapReset,
    required this.onTapProcesar,
    required this.onTapVolver,
    required this.onTapIA,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: kTerciaryColor,
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: FontAwesomeIcons.rotateLeft,
            text: '',
            onTap: onTapReset,
            size: size,
          ),
          // LOGIC : Añadido para el botón de IA
          _buildActionButton(
            icon: FontAwesomeIcons.file,
            text: '',
            onTap: onTapIA,
            size: size,
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.chevronLeft,
            text: '',
            onTap: onTapVolver,
            size: size,
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.play,
            text: 'Procesar',
            onTap: onTapProcesar,
            size: size,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Size size,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.width * 0.02,
        ),
        decoration: BoxDecoration(
          color: isPrimary ? kPrimaryColor : kTerciaryColor,
          borderRadius: BorderRadius.circular(size.width * 0.03),
          border: Border.all(
            color: kPrimaryColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isPrimary ? kTerciaryColor : kPrimaryColor,
              size: size.width * 0.045,
            ),
            if (text.isEmpty)
              Container()
            else ...[
              SizedBox(width: size.width * 0.02),
              Text(
                text,
                style: GoogleFonts.kanit(
                  color: isPrimary ? kTerciaryColor : kPrimaryColor,
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

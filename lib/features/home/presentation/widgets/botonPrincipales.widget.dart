import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonPrincipal extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool activo;
  final VoidCallback onTap;
  final Size size;

  const BotonPrincipal({
    required this.icono,
    required this.texto,
    required this.activo,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.25,
        padding: EdgeInsets.symmetric(
          vertical: size.width * 0.03,
          horizontal: size.width * 0.02,
        ),
        decoration: BoxDecoration(
          color: activo ? kPrimaryColor.withOpacity(0.2) : kTerciaryColor,
          borderRadius: BorderRadius.circular(size.width * 0.03),
          border: Border.all(
            color: activo ? kPrimaryColor : kPrimaryColor.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: activo
                  ? kPrimaryColor.withOpacity(0.3)
                  : kPrimaryColor.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: activo ? 2 : 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              color: activo ? kPrimaryColor : kPrimaryColor.withOpacity(0.7),
              size: size.width * 0.08,
            ),
            SizedBox(height: size.width * 0.02),
            Text(
              texto,
              style: GoogleFonts.kanit(
                color: activo ? kPrimaryColor : kPrimaryColor.withOpacity(0.7),
                fontSize: size.width * 0.04,
                fontWeight: activo ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

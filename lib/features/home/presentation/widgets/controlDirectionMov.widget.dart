import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PanelControl extends StatelessWidget {
  const PanelControl({super.key});

  @override
  Widget build(BuildContext context) {
    final tamano = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tamano.width * 0.05,
        vertical: tamano.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: kTerciaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(tamano.width * 0.03),
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
          // LOGIC : Boton de Dirección Arriba
          _BotonDireccion(
            icono: FontAwesomeIcons.arrowUp,
            color: kPrimaryColor,
            tamano: tamano,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGIC : Boton de Dirección Izquierda
              _BotonDireccion(
                icono: FontAwesomeIcons.arrowLeft,
                color: kPrimaryColor,
                tamano: tamano,
              ),
              SizedBox(width: tamano.width * 0.15),
              // LOGIC : Boton de Dirección Derecha
              _BotonDireccion(
                icono: FontAwesomeIcons.arrowRight,
                color: kPrimaryColor,
                tamano: tamano,
              ),
            ],
          ),
          // LOGIC : Boton de Dirección Abajo
          _BotonDireccion(
            icono: FontAwesomeIcons.arrowDown,
            color: kPrimaryColor,
            tamano: tamano,
          ),
        ],
      ),
    );
  }
}

class _BotonDireccion extends StatelessWidget {
  final IconData icono;
  final Color color;
  final Size tamano;

  const _BotonDireccion({
    required this.icono,
    required this.color,
    required this.tamano,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(tamano.width * 0.02),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTapDown: (_) {/* Lógica de presionar */},
          onTapUp: (_) {/* Lógica de soltar */},
          onTapCancel: () {/* Lógica de cancelar */},
          borderRadius: BorderRadius.circular(tamano.width * 0.03),
          child: Container(
            padding: EdgeInsets.all(tamano.width * 0.05),
            decoration: BoxDecoration(
              color: kTerciaryColor,
              borderRadius: BorderRadius.circular(tamano.width * 0.03),
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
              ),
            ),
            child: Icon(
              icono,
              color: color,
              size: tamano.width * 0.08,
            ),
          ),
        ),
      ),
    );
  }
}

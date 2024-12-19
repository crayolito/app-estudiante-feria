import 'package:animate_do/animate_do.dart';
import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:app_feria2024/services/webSocket.service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TituloAndEstado extends StatelessWidget {
  const TituloAndEstado({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tamano = MediaQuery.of(context).size;

    return FadeInDown(
      child: Container(
        padding: EdgeInsets.all(tamano.width * 0.03),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WALL·E Student",
                  style: GoogleFonts.kanit(
                    color: kPrimaryColor,
                    fontSize: tamano.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "ESP32 Wifi Bluetooth v1.0",
                  style: GoogleFonts.kanit(
                    color: kSecondaryColor,
                    fontSize: tamano.width * 0.03,
                  ),
                ),
              ],
            ),
            const EstadoConexion(),
          ],
        ),
      ),
    );
  }
}

class EstadoConexion extends StatelessWidget {
  const EstadoConexion({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final webSocketService = WebSocketService();

    return StreamBuilder<bool>(
      stream: webSocketService.connectionState,
      initialData: webSocketService.isConnected,
      builder: (context, snapshot) {
        final conectado = snapshot.data ?? false;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.width * 0.02,
          ),
          decoration: BoxDecoration(
            color: conectado
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(size.width * 0.3),
            border: Border.all(
              color: conectado ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size.width * 0.03,
                height: size.width * 0.02,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: conectado ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Text(
                conectado ? "Conectado" : "Desconectado",
                style: GoogleFonts.kanit(
                  color: conectado ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

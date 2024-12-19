import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final SpeechToText _speechToText = SpeechToText();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializePermissions();
    Future.delayed(const Duration(seconds: 5), () {
      context.push("/controles");
    });
  }

  Future<void> _initializePermissions() async {
    await _requestBasicPermissions();
    await _initSpeechToText();
    await _requestCameraPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      child: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kTerciaryColor.withOpacity(0.8),
                kTerciaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo con animación suave
                FadeInDown(
                  duration: const Duration(seconds: 2),
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            kPrimaryColor,
                            kPrimaryColor.withOpacity(0.95),
                            Colors.white.withOpacity(0.9),
                            kPrimaryColor.withOpacity(0.95),
                            kPrimaryColor,
                          ],
                          // Ajustamos los stops para una transición más suave y completa
                          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                          tileMode:
                              TileMode.clamp, // Esto ayuda a evitar cortes
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.1,
                          vertical: size.width * 0.05,
                        ),
                        child: Icon(
                          Icons.school,
                          size: size.width * 0.4,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Texto principal con efecto de aparición
                FadeIn(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(seconds: 2),
                  child: Column(
                    children: [
                      Text(
                        "TECHTUTOR",
                        style: GoogleFonts.kanit(
                          fontSize: size.width * 0.12,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          letterSpacing: 5,
                          shadows: [
                            Shadow(
                              color: kPrimaryColor.withOpacity(0.5),
                              offset: const Offset(0, 4),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.width * 0.02),

                      // Línea decorativa
                      Container(
                        width: size.width * 0.3,
                        height: 3,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              kPrimaryColor.withOpacity(0),
                              kPrimaryColor,
                              kPrimaryColor.withOpacity(0),
                            ],
                          ),
                        ),
                      ),

                      // Subtítulo con efecto de aparición
                      FadeIn(
                        delay: const Duration(seconds: 1),
                        child: Text(
                          "Innovación y Tecnología",
                          style: GoogleFonts.kanit(
                            fontSize: size.width * 0.04,
                            color: kSecondaryColor,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Indicador de carga con los colores de marca
                FadeInUp(
                  delay: const Duration(milliseconds: 1500),
                  child: SizedBox(
                    width: size.width * 0.4,
                    child: LinearProgressIndicator(
                      backgroundColor: kSecondaryColor.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      minHeight: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initSpeechToText() async {
    try {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        await _speechToText.initialize(
          onStatus: (status) => debugPrint('Speech status: $status'),
          onError: (error) => debugPrint('Speech error: $error'),
        );
      }
    } catch (e) {
      debugPrint('Error inicializando speech to text: $e');
    }
  }

  Future<void> _requestCameraPermissions() async {
    try {
      await Permission.camera.request();
    } catch (e) {
      debugPrint('Error solicitando permisos de cámara: $e');
    }
  }

  Future<void> _requestBasicPermissions() async {
    try {
      // Solicitar permisos de almacenamiento
      await Permission.storage.request();
      // Solicitar permisos de galería
      if (Platform.isIOS) {
        await Permission.photos.request();
      }
    } catch (e) {
      debugPrint('Error solicitando permisos básicos: $e');
    }
  }
}

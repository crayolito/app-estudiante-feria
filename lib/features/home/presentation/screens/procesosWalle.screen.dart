import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:app_feria2024/config/dialog.config.dart';
import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:app_feria2024/features/home/presentation/widgets/animacionesWalle.widget.dart';
import 'package:app_feria2024/features/home/presentation/widgets/botonesParteInferior.widget.dart';
import 'package:app_feria2024/features/home/presentation/widgets/respuestasIA.widget.dart';
import 'package:app_feria2024/services/backend.service.dart';
import 'package:app_feria2024/services/media-handler-impl.service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcesosWalleScreen extends StatefulWidget {
  const ProcesosWalleScreen({super.key});

  @override
  State<ProcesosWalleScreen> createState() => _ProcesosWalleScreenState();
}

class _ProcesosWalleScreenState extends State<ProcesosWalleScreen>
    with TickerProviderStateMixin {
  bool esControlTelefono = true;
  bool tenemosImagen = false;
  String selectedProcess = '';
  String? imagePath;
  String? base64Image;
  final textController = TextEditingController();
  late AnimationController _backgroundController;
  final _mediaHandler = MediaHandlerServiceImpl();
  Map<String, dynamic>? respuestaIA;
  String? streamingUrl;
  bool isStreaming = false;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  void resetProcess() {
    setState(() {
      selectedProcess = '';
      textController.clear();
      tenemosImagen = false;
      imagePath = null;
      base64Image = null;
      respuestaIA = null;
      isStreaming = false; // Agregado para manejar el streaming
      streamingUrl = null; // Agregado para manejar el streaming
    });
  }

  Future<void> handleImageCapture(bool fromCamera) async {
    try {
      String? path;
      if (fromCamera) {
        path = await _mediaHandler.takePhoto();
      } else {
        path = await _mediaHandler.selectPhoto();
      }

      if (path != null) {
        String? base64 = await _mediaHandler.imageToBase64(path);
        if (base64 != null) {
          if (base64.length > 250000) {
            DialogService.showErrorSnackBar(
                message:
                    'La imagen es demasiado grande, por favor seleccione una más pequeña',
                context: context);
            return;
          }
          setState(() {
            imagePath = path;
            base64Image = base64;
            tenemosImagen = true;
            selectedProcess = fromCamera ? 'Foto' : 'Galería';
          });
          DialogService.showSuccessSnackBar(
              'Imagen cargada correctamente', context);
        }
      }
    } catch (e) {
      DialogService.showErrorSnackBar(
          message: 'Error al procesar la imagen', context: context);
    }
  }

  Future<void> handleAudioCapture() async {
    try {
      await _mediaHandler.initSpeechService();
      await _mediaHandler.startListening(
        onResult: (text) {
          setState(() {
            textController.text = text;
          });
        },
      );
      DialogService.showSuccessSnackBar('Escuchando...', context);
    } catch (e) {
      DialogService.showErrorSnackBar(
          message: 'Error al iniciar el reconocimiento de voz',
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kTerciaryColor,
      appBar: AppBar(
        backgroundColor: kTerciaryColor,
        title: FadeIn(
          child: Text(
            'Procesos Walle IA',
            style: GoogleFonts.kanit(
              color: kPrimaryColor,
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AnimatedBackgroundWalle(controller: _backgroundController),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: Column(
                      children: [
                        FadeInDown(
                          child: _buildModeSelector(size),
                        ),
                        SizedBox(height: size.height * 0.03),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: _buildVisualizationArea(size),
                        ),
                        SizedBox(height: size.height * 0.03),
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: _buildProblemInput(size),
                        ),
                        SizedBox(height: size.height * 0.03),
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: _buildProcessOptions(size),
                        ),
                        SizedBox(height: size.height * 0.03),
                      ],
                    ),
                  ),
                ),
                BotonesParteIngerior(
                  onTapReset: resetProcess,
                  // LOGIC : Verificar el tipo de entrada y procesar
                  onTapProcesar: () {
                    if (!tenemosImagen && textController.text.isEmpty) {
                      DialogService.showErrorSnackBar(
                        message:
                            'Por favor, inserte una imagen o texto para procesar',
                        context: context,
                      );
                      return;
                    }
                    procesarRespuesta();
                  },
                  onTapVolver: () => Navigator.pop(context),
                  // LOGIC : Creacion showDialog para mostrar RespuestaIA
                  onTapIA: () {
                    showDialog(
                      context: context,
                      builder: (context) => RespuestaIADialog(
                        esRespuestaImagen: tenemosImagen,
                        respuestaData: respuestaIA,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> procesarRespuesta() async {
    final _backendService = BackendService();

    try {
      DialogService.showLoadingDialog(
        context: context,
        message: tenemosImagen ? 'Procesando imagen...' : 'Procesando texto...',
      );

      final response = tenemosImagen && base64Image != null
          ? await _backendService.solveHomework(base64Image!)
          : await _backendService.solveText(textController.text);

      Navigator.of(context).pop(); // Cerrar diálogo de carga

      if (response.success) {
        setState(() {
          respuestaIA = response.data;
        });
        DialogService.showSuccessSnackBar(
          'Proceso completado exitosamente. Presione el botón IA para ver la respuesta',
          context,
        );
      } else {
        DialogService.showErrorSnackBar(
          message: response.message,
          context: context,
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Cerrar diálogo de carga
      DialogService.showErrorSnackBar(
        message: 'Error inesperado: $e',
        context: context,
      );
    }
  }

  Widget _buildModeSelector(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.02),
      decoration: BoxDecoration(
        color: kTerciaryColor,
        borderRadius: BorderRadius.circular(size.width * 0.03),
        border: Border.all(color: kPrimaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildModeButton(
            "Control Teléfono",
            FontAwesomeIcons.mobile,
            esControlTelefono,
            () => setState(() => esControlTelefono = true),
            size,
          ),
          _buildModeButton(
            "Control Walle",
            FontAwesomeIcons.robot,
            !esControlTelefono,
            () => setState(() => esControlTelefono = false),
            size,
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    String text,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    Size size,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(size.width * 0.03),
          decoration: BoxDecoration(
            color: isSelected
                ? kPrimaryColor.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(size.width * 0.03),
            border: Border.all(
              color: isSelected ? kPrimaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? kPrimaryColor : kSecondaryColor,
                size: size.width * 0.05,
              ),
              SizedBox(width: size.width * 0.02),
              Text(
                text,
                style: GoogleFonts.kanit(
                  color: isSelected ? kPrimaryColor : kSecondaryColor,
                  fontSize: size.width * 0.035,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisualizationArea(Size size) {
    return Container(
      height: size.width,
      width: size.width,
      decoration: BoxDecoration(
        color: kTerciaryColor,
        borderRadius: BorderRadius.circular(size.width * 0.03),
        border: Border.all(color: kPrimaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (tenemosImagen && imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(size.width * 0.03),
              child: Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
              ),
            )
          else if (isStreaming && streamingUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(size.width * 0.03),
              child: Image.network(
                streamingUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.exclamationTriangle,
                          color: kPrimaryColor,
                          size: size.width * 0.1,
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'Error al cargar el stream',
                          style: GoogleFonts.kanit(
                            color: kPrimaryColor,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.microchip,
                        color: kPrimaryColor.withOpacity(0.1),
                        size: size.width * 0.3,
                      ),
                      Icon(
                        FontAwesomeIcons.brain,
                        color: kPrimaryColor.withOpacity(0.3),
                        size: size.width * 0.2,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'Escoja un proceso\na realizar',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kanit(
                      color: kPrimaryColor,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProblemInput(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: kTerciaryColor,
        borderRadius: BorderRadius.circular(size.width * 0.03),
        border: Border.all(color: kPrimaryColor.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        style: GoogleFonts.kanit(color: kCuartoColor),
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Escriba su problema, se lo realizamos',
          hintStyle: GoogleFonts.kanit(
            color: kSecondaryColor.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(size.width * 0.04),
        ),
      ),
    );
  }

  Widget _buildProcessOptions(Size size) {
    final options = esControlTelefono
        ? [
            {'icon': FontAwesomeIcons.camera, 'name': 'Foto'},
            {'icon': FontAwesomeIcons.images, 'name': 'Galería'},
            {'icon': FontAwesomeIcons.microphone, 'name': 'Audio'},
          ]
        : [
            {'icon': FontAwesomeIcons.camera, 'name': 'Foto'},
            {'icon': FontAwesomeIcons.video, 'name': 'Streaming'},
          ];

    return Wrap(
      spacing: size.width * 0.04,
      runSpacing: size.width * 0.04,
      alignment: WrapAlignment.center,
      children: options.map((option) {
        final name = option['name']! as String;
        return GestureDetector(
          onTap: () async {
            if (esControlTelefono) {
              if (name == 'Foto') {
                await handleImageCapture(true);
              } else if (name == 'Galería') {
                await handleImageCapture(false);
              } else if (name == 'Audio') {
                await handleAudioCapture();
              }
              setState(() => selectedProcess = name);
            } else {
              if (name == 'Streaming') {
                // READ : CAMBIAR AQUI MAÑANA PARA EL USO DE LA IP DEL SERVIDOR
                setState(() {
                  isStreaming = true;
                  streamingUrl =
                      'http://192.168.137.29/stream'; // Reemplazar con la IP de tu ESP32-CAM
                  selectedProcess = name;
                });
              }
            }
          },
          child: Container(
            width: size.width * 0.25,
            padding: EdgeInsets.symmetric(
              vertical: size.width * 0.03,
              horizontal: size.width * 0.03,
            ),
            decoration: BoxDecoration(
              color: kTerciaryColor,
              borderRadius: BorderRadius.circular(size.width * 0.03),
              border: Border.all(color: kPrimaryColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  option['icon'] as IconData,
                  color: kPrimaryColor,
                  size: size.width * 0.06,
                ),
                SizedBox(height: size.width * 0.02),
                Text(
                  name,
                  style: GoogleFonts.kanit(
                    color: kPrimaryColor,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    textController.dispose();
    _mediaHandler.dispose();
    isStreaming = false;
    streamingUrl = null;
    super.dispose();
  }
}

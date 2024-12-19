import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RespuestaIADialog extends StatelessWidget {
  final bool esRespuestaImagen;
  final Map<String, dynamic>? respuestaData;

  const RespuestaIADialog({
    super.key,
    required this.esRespuestaImagen,
    this.respuestaData,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (respuestaData == null) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Container(
            padding: EdgeInsets.all(size.width * 0.04),
            constraints: BoxConstraints(
              maxWidth: size.width * 0.9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(size.width * 0.05),
              border: Border.all(
                color: const Color(0xFF00FF94),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.circleExclamation,
                  color: const Color(0xFF00FF94),
                  size: size.width * 0.15,
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'Empecemos un proceso',
                  style: GoogleFonts.kanit(
                    color: const Color(0xFF00FF94),
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Inserte un texto o imagen para procesar',
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: size.width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.02),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF94).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                      border: Border.all(
                        color: const Color(0xFF00FF94),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Entendido',
                      style: GoogleFonts.kanit(
                        color: const Color(0xFF00FF94),
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: size.height * 0.8,
            maxWidth: size.width * 0.9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(size.width * 0.05),
            border: Border.all(
              color: const Color(0xFF00FF94),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FF94).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(size),
              _buildContent(size),
              _buildFooter(size, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF00FF94).withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.robot,
            color: const Color(0xFF00FF94),
            size: size.width * 0.06,
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Text(
              'Respuesta de Walle IA',
              style: GoogleFonts.kanit(
                color: const Color(0xFF00FF94),
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FadeIn(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.width * 0.01,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF00FF94).withOpacity(0.1),
                borderRadius: BorderRadius.circular(size.width * 0.02),
                border: Border.all(
                  color: const Color(0xFF00FF94),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.brain,
                    color: const Color(0xFF00FF94),
                    size: size.width * 0.035,
                  ),
                  SizedBox(width: size.width * 0.02),
                  Text(
                    '${((respuestaData?['confidence'] ?? 0) * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.kanit(
                      color: const Color(0xFF00FF94),
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Size size) {
    if (esRespuestaImagen) {
      return _buildImageResponse(size);
    }
    return _buildTextResponse(size);
  }

  Widget _buildImageResponse(Size size) {
    final solution = respuestaData?['solution'] ?? '';
    final steps = respuestaData?['steps'] as List<dynamic>? ?? [];
    final confidence = respuestaData?['confidence']?.toString() ?? '0';
    // El answer puede ser Map o List
    final answerData = respuestaData?['answer'];

    return Flexible(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solución:',
              style: GoogleFonts.kanit(
                color: const Color(0xFF00FF94),
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              solution,
              style: GoogleFonts.kanit(
                color: Colors.white,
                fontSize: size.width * 0.04,
              ),
            ),
            if (steps.isNotEmpty) ...[
              SizedBox(height: size.height * 0.03),
              Text(
                'Pasos:',
                style: GoogleFonts.kanit(
                  color: const Color(0xFF00FF94),
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              ...steps.map((step) {
                return Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.01),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        FontAwesomeIcons.chevronRight,
                        color: const Color(0xFF00FF94),
                        size: size.width * 0.04,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: Text(
                          step.toString(),
                          style: GoogleFonts.kanit(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
            if (answerData != null) ...[
              SizedBox(height: size.height * 0.03),
              Text(
                'Respuestas:',
                style: GoogleFonts.kanit(
                  color: const Color(0xFF00FF94),
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              ..._buildAnswersList(answerData, size),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnswersList(dynamic answerData, Size size) {
    try {
      if (answerData is Map<String, dynamic>) {
        // Si es un mapa, usamos las entries
        return answerData.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.chevronRight,
                  color: const Color(0xFF00FF94),
                  size: size.width * 0.04,
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: Text(
                    '${entry.key}) ${entry.value}',
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList();
      } else if (answerData is List) {
        // Si es una lista, usamos índices numéricos
        return answerData.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.chevronRight,
                  color: const Color(0xFF00FF94),
                  size: size.width * 0.04,
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: Text(
                    '${entry.key + 1}) ${entry.value}',
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList();
      }

      // Si no es ni Map ni List, retornamos lista vacía
      return [];
    } catch (e) {
      print('Error al procesar respuestas: $e');
      return [];
    }
  }

  Widget _buildTextResponse(Size size) {
    final explanation = respuestaData?['explanation'] ?? '';
    final answer = respuestaData?['answer'] ?? '';
    final references = respuestaData?['references'] as List<dynamic>? ?? [];
    final confidence = respuestaData?['confidence']?.toString() ?? '0';

    return Flexible(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (explanation.isNotEmpty) ...[
              Text(
                'Explicación:',
                style: GoogleFonts.kanit(
                  color: const Color(0xFF00FF94),
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                explanation,
                style: GoogleFonts.kanit(
                  color: Colors.white,
                  fontSize: size.width * 0.04,
                ),
              ),
            ],
            if (answer.isNotEmpty) ...[
              SizedBox(height: size.height * 0.03),
              Text(
                'Respuesta:',
                style: GoogleFonts.kanit(
                  color: const Color(0xFF00FF94),
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                answer,
                style: GoogleFonts.kanit(
                  color: Colors.white,
                  fontSize: size.width * 0.04,
                ),
              ),
            ],
            if (references.isNotEmpty) ...[
              SizedBox(height: size.height * 0.03),
              Text(
                'Referencias:',
                style: GoogleFonts.kanit(
                  color: const Color(0xFF00FF94),
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              ...references.map((reference) {
                return Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.01),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.link,
                        color: const Color(0xFF00FF94),
                        size: size.width * 0.04,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: Text(
                          reference.toString(),
                          style: GoogleFonts.kanit(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(Size size, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF00FF94).withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildFooterButton(
            size,
            'Copiar',
            FontAwesomeIcons.copy,
            () {},
          ),
          SizedBox(width: size.width * 0.03),
          _buildFooterButton(
            size,
            'Cerrar',
            FontAwesomeIcons.xmark,
            () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton(
    Size size,
    String text,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.width * 0.02,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF00FF94).withOpacity(0.1),
          borderRadius: BorderRadius.circular(size.width * 0.02),
          border: Border.all(
            color: const Color(0xFF00FF94),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFF00FF94),
              size: size.width * 0.04,
            ),
            SizedBox(width: size.width * 0.02),
            Text(
              text,
              style: GoogleFonts.kanit(
                color: const Color(0xFF00FF94),
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

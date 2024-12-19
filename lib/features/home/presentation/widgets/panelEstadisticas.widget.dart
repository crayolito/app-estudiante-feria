import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:app_feria2024/features/home/presentation/widgets/animaciones.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PanelEstadisticas extends StatelessWidget {
  final Map<String, Map<String, dynamic>> statistics;
  final BackgroundController controller;

  const PanelEstadisticas({
    super.key,
    required this.statistics,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: kTerciaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(size.width * 0.03),
        border: Border.all(
          color: kPrimaryColor.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kTerciaryColor.withOpacity(0.9),
            kTerciaryColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          _buildHeader(size),
          const Divider(color: kPrimaryColor, thickness: 0.5, height: 0),
          _buildStatisticsList(size),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.chartLine,
            color: kPrimaryColor,
            size: size.width * 0.06,
          ),
          SizedBox(width: size.width * 0.03),
          Text(
            'Estadísticas del Sistema',
            style: GoogleFonts.kanit(
              color: kPrimaryColor,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsList(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      child: AnimatedBuilder(
        animation: controller.glowController,
        builder: (context, child) {
          return Column(
            children: statistics.entries.map((entry) {
              return _StatisticItem(
                title: entry.key,
                value: entry.value['value'],
                icon: entry.value['icon'],
                color: entry.value['color'],
                glowValue: controller.glowController.value,
                size: size,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _StatisticItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double glowValue;
  final Size size;

  const _StatisticItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.glowValue,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: kTerciaryColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(size.width * 0.03),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1 * glowValue),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(size.width * 0.02),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(size.width * 0.03),
            ),
            child: Icon(
              icon,
              color: color,
              size: size.width * 0.05,
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.kanit(
                color: kSecondaryColor,
                fontSize: size.width * 0.035,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.kanit(
              color: color,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

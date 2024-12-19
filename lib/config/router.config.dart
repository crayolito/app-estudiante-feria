import 'package:app_feria2024/features/home/presentation/screens/controles.screen.dart';
import 'package:app_feria2024/features/home/presentation/screens/home.screen.dart';
import 'package:app_feria2024/features/home/presentation/screens/procesosWalle.screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
  GoRoute(
      path: '/walle', builder: (context, state) => const ProcesosWalleScreen()),
  GoRoute(
      path: '/controles', builder: (context, state) => const ControlesScreen()),
]);

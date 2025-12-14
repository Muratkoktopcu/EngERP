import 'package:go_router/go_router.dart';

import '../../features/stock/pages/StockManagementPage.dart';
import '../../features/reservation/pages/ReservationPage.dart';
import '../../features/sales_confirmation/pages/SalesConfirmationPage.dart';
import '../../features/cancel/pages/CancelPage.dart';
import '../navigation/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: "/stock",

  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),

      routes: [
        GoRoute(
          path: '/stock',
          name: 'stock',
          builder: (context, state) => const StokYonetimiPage(),
        ),
        GoRoute(
          path: '/reservation',
          name: 'reservation',
          builder: (context, state) => const ReservationPage(),
        ),
        GoRoute(
          path: '/sales',
          name: 'sales',
          builder: (context, state) => const SalesConfirmationPage(),
        ),
        GoRoute(
          path: '/cancel',
          name: 'cancel',
          builder: (context, state) => const CancelPage(),
        ),
      ],
    ),
  ],
);

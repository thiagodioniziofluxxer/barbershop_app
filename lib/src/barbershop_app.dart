import 'package:asyncstate/asyncstate.dart';
import 'package:barbershop/src/core/ui/barbershop_theme.dart';
import 'package:barbershop/src/features/auth/login/login_page.dart';
import 'package:barbershop/src/features/auth/register/barbershop/barbershop_register_page.dart';
import 'package:barbershop/src/features/auth/register/user/user_register_page.dart';
import 'package:barbershop/src/features/employee/register/employee_register_page.dart';
import 'package:barbershop/src/features/employee/schedule/schedule_employee_page.dart';
import 'package:barbershop/src/features/home/adm/home_adm_page.dart';
import 'package:barbershop/src/features/home/employee/home_employee_page.dart';
import 'package:barbershop/src/features/schedule/schedule_page.dart';
import 'package:barbershop/src/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/ui/barbershop_nav_global_key.dart';
import 'core/ui/widgets/barbershop_loader.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
        customLoader: const BarbershopLoader(),
        builder: (asynctNavigatorObserver) {
          return MaterialApp(
            title: 'Barbershop',
            theme: BarbershopTheme.themeData,
            navigatorObservers: [asynctNavigatorObserver],
            navigatorKey: BarbershopNavGlobalKey.instance.navigatorKey,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', 'BR'),
            ],
            locale: const Locale('pt', 'BR'),
            routes: {
              '/': (_) => const SplashPage(),
              '/auth/login': (_) => const LoginPage(),
              '/auth/register/user': (_) => const UserRegisterPage(),
              '/auth/register/barbershop': (_) =>
                  const BarbershopRegisterPage(),
              '/home/adm': (_) => const HomeAdmPage(),
              '/home/employee': (_) => const HomeEmployeePage(),
              '/employee/register': (_) => const EmployeeRegisterPage(),
              '/employee/schedule': (_) => const ScheduleEmployeePage(),
              '/schedule': (_) => const SchedulePage(),
            },
          );
        });
  }
}

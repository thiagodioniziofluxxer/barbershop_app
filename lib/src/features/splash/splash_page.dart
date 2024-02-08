import 'dart:developer';

import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/features/splash/splash_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/login/login_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  var _scale = 10.0;
  var _animationOpacityLogo = 0.0;
  double get _logoAnimationWidth => 100 * _scale;
  double get _logoAnimationHeight => 120 * _scale;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animationOpacityLogo = 1.0;
        _scale = 1.0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashVmProvider, (_, state) {
      state.whenOrNull(
        error: (error, stackTrace) {
          log('Erro ao Validar', error: error, stackTrace: stackTrace);
          Messages.showErrorMessage('Erro ao Validar o login', context);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/auth/login', (route) => false);
        },
        data: (data) {
          switch (data) {
            case SplashState.loggedADM:
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home/adm', (route) => false);
            case SplashState.loggedEmployee:
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home/employee', (route) => false);
            case _:
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/auth/login', (route) => false);
          }
        },
      );
    });

    return Scaffold(
        backgroundColor: Colors.black,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background_image_chair.jpg'),
                fit: BoxFit.cover,
                opacity: 0.2),
          ),
          child: Center(
            child: AnimatedOpacity(
              onEnd: () {
                Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                      settings: const RouteSettings(name: '/auth/login'),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const LoginPage();
                      },
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                    (route) => false);
              },
              duration: const Duration(seconds: 1),
              curve: Curves.easeIn,
              opacity: _animationOpacityLogo,
              child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  width: _logoAnimationWidth,
                  height: _logoAnimationHeight,
                  curve: Curves.linearToEaseOut,
                  child: Image.asset(
                    'assets/images/imgLogo.png',
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ));
  }
}

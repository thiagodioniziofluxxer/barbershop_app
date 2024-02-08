import 'package:barbershop/src/core/ui/contants.dart';
import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/features/auth/login/login_state.dart';
import 'package:barbershop/src/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    emailEC.text = 'thiago.o.dionizio@gmail.com';
    passwordEC.text = '12341234';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LoginVm(:login) = ref.watch(loginVmProvider.notifier);
    ref.listen(loginVmProvider, (_, next) {
      switch (next) {
        case LoginState(status: LoginStateStatus.initial):
          break;
        case LoginState(status: LoginStateStatus.error, :final errorMessage?):
          Messages.showErrorMessage(errorMessage, context);
          break;
        case LoginState(status: LoginStateStatus.error):
          Messages.showErrorMessage("Erro ao realizar login", context);
          break;
        case LoginState(status: LoginStateStatus.admLogin):
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/adm', (route) => false);
          break;
        case LoginState(status: LoginStateStatus.employeeLogin):
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/employee', (route) => false);
          break;
      }
      if (next.status == LoginStateStatus.error) {
        Messages.showErrorMessage(next.errorMessage!, context);
      }
    });

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Form(
            key: formKey,
            child: DecoratedBox(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImageConstants.background),
                      fit: BoxFit.cover,
                      opacity: 0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                          hasScrollBody: false,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Text('bear', style: TextStyle(color: Colors.white)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(ImageConstants.imageLogo,
                                      width: 100, height: 120),
                                  const SizedBox(height: 24),
                                  TextFormField(
                                    onTapOutside: (_) => context.unfocus(),
                                    validator: Validatorless.multiple([
                                      Validatorless.required(
                                          'E-mail obrigatório'),
                                      Validatorless.email('E-mail inválido')
                                    ]),
                                    controller: emailEC,
                                    decoration: const InputDecoration(
                                        label: Text('E-mail'),
                                        hintText: 'E-mail',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        labelStyle:
                                            TextStyle(color: Colors.black)),
                                  ),
                                  const SizedBox(height: 24),
                                  TextFormField(
                                    onTapOutside: (_) => context.unfocus(),
                                    controller: passwordEC,
                                    validator: Validatorless.multiple([
                                      Validatorless.required(
                                          'Senha obrigatória'),
                                      Validatorless.min(6, 'Senha muito curta')
                                    ]),
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        label: Text('Senha'),
                                        hintText: 'Senha',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        labelStyle:
                                            TextStyle(color: Colors.black)),
                                  ),
                                  const SizedBox(height: 24),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Esqueceu sua senha?',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Constants.brow)),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        switch (
                                            formKey.currentState?.validate()) {
                                          case true:
                                            login(
                                                emailEC.text, passwordEC.text);
                                            break;
                                          case (false || null):
                                            Messages.showErrorMessage(
                                                'campos inválidos', context);
                                            return;
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(56),
                                      ),
                                      child: const Text('Entrar')),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                '/auth/register/barbershop');
                                          },
                                          child: const Text('Minha baerber',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/auth/register/user');
                                      },
                                      child: const Text('Criar uma conta',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    )),
                              ),
                            ],
                          ))
                    ],
                  ),
                )),
          )),
    );
  }
}

import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:barbershop/src/core/ui/widgets/weekdays_panel.dart';
import 'package:barbershop/src/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:barbershop/src/features/auth/register/barbershop/barbertshop_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class BarbershopRegisterPage extends ConsumerStatefulWidget {
  const BarbershopRegisterPage({super.key});

  @override
  ConsumerState<BarbershopRegisterPage> createState() =>
      _BarbershopRegisterPageState();
}

class _BarbershopRegisterPageState
    extends ConsumerState<BarbershopRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameEC.text = 'Barbearia do Zé';
    emailEC.text = 'ze@barber.com.br';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final barbershopRegisterVm =
        ref.watch(barbertshopRegisterVmProvider.notifier);

    ref.listen(barbertshopRegisterVmProvider, (_, state) {
      switch (state.status) {
        case BarbershopRegisterStatus.success:
          Messages.showSuccessMessage('Estabelecimento cadastrado', context);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/adm', (route) => false);
          break;
        case BarbershopRegisterStatus.error:
          Messages.showErrorMessage(
              'Erro ao cadastrar estabelecimento', context);
          break;
        default:
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar estababelecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: nameEC,
                  onTapOutside: (_) => context.unfocus(),
                  validator: Validatorless.required('Nome é obrigatório'),
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: emailEC,
                  onTapOutside: (_) => context.unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido')
                  ]),
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                WeekdaysPanel(
                  onDayPressed: (value) =>
                      {barbershopRegisterVm.addOrRemoveOpenDays(value)},
                ),
                const SizedBox(
                  height: 24,
                ),
                HoursPanel(
                  startTime: 6,
                  endTime: 20,
                  onHourPressed: (value) =>
                      {barbershopRegisterVm.addOrRemoveOpenHours(value)},
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: () {
                    switch (formKey.currentState?.validate()) {
                      case null || false:
                        Messages.showErrorMessage('Dados inválidos', context);
                        break;
                      case true:
                        barbershopRegisterVm.register(
                          name: nameEC.text,
                          email: emailEC.text,
                        );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text('CADASTRAR MEU ESTABELECIMENTO'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/core/ui/barbershop_icons.dart';
import 'package:barbershop/src/core/ui/contants.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/features/home/adm/home_adm_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  final bool hideFilter;
  const HomeHeader({super.key, this.hideFilter = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barbershop = ref.watch(getMyBarbershopProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        color: Colors.black,
        image: DecorationImage(
            image: AssetImage(ImageConstants.background),
            fit: BoxFit.cover,
            opacity: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          barbershop.maybeWhen(
            data: (barbershopData) {
              return Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xffbdbdbd),
                    child: SizedBox.shrink(),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Text(
                      barbershopData.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Expanded(
                    child: Text(
                      'Editar',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Constants.brow,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(homeAdmVmProvider.notifier).loggout();
                    },
                    icon: const Icon(
                      BarbershopIcons.exit,
                      color: Constants.brow,
                    ),
                  ),
                ],
              );
            },
            orElse: () => const BarbershopLoader(),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Bem vindo',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Agende um cliente',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 40),
          ),
          Offstage(
            offstage: hideFilter,
            child: const SizedBox(
              height: 24,
            ),
          ),
          Offstage(
            offstage: hideFilter,
            child: TextFormField(
              decoration: const InputDecoration(
                label: Text('Buscar colaborador'),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 24.0),
                  child: Icon(
                    BarbershopIcons.search,
                    color: Colors.grey,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

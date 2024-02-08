// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:barbershop/src/core/ui/barbershop_icons.dart';
import 'package:barbershop/src/core/ui/contants.dart';
import 'package:barbershop/src/model/user_model.dart';

class HomeEmploeeTile extends StatelessWidget {
  final UserModel employee;

  final bool imageNetwork = false;
  const HomeEmploeeTile({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 200,
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Constants.grey)),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: switch (imageNetwork) {
              true => const NetworkImage('url'),
              false => const AssetImage(ImageConstants.avatar)
            } as ImageProvider)),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/schedule', arguments: employee);
                        },
                        child: const Text('Agendar')),
                    OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/employee/schedule',
                              arguments: employee);
                        },
                        child: const Text('Ver Agenda')),
                    const Icon(
                      BarbershopIcons.penEdit,
                      size: 16,
                      color: Constants.brow,
                    ),
                    const Icon(
                      BarbershopIcons.trash,
                      size: 16,
                      color: Constants.red,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

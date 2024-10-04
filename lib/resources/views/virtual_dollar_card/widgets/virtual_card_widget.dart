import 'package:waiz/app/Models/user/User.dart';
import 'package:waiz/app/http/controllers/virtual_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

Widget virtualCard({required BuildContext context, bool viewDetails = false,required VirtualDollarCardController virtualDollarCardController}) => Container(
      // height: 200,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/card_bg.png'),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/logo.png',
              height: 35,
                  width: 35,
              ),
              Image.asset('assets/images/visa.png'),
            ],
          ),
          const Gap(30),
          Text(
            viewDetails ? virtualDollarCardController.cardNumber : '****  ****  ****  ****',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.white,
                ),
          ),
          const Gap(10),
          Row(
            children: [
              Image.asset('assets/images/card_part.png'),
            ],
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card holder name',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                  ),
                  const Gap(10),
                  Text(
                      viewDetails ? virtualDollarCardController.fullName : '****',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expiry date',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                  ),
                  const Gap(10),
                  Text(
                      viewDetails ? virtualDollarCardController.expiringDate : '****',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

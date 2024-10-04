import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';
import 'confirm_flight.dart';

class FlightReservation extends StatefulWidget {
  const FlightReservation({super.key});

  @override
  State<FlightReservation> createState() => _FlightReservationState();
}

class _FlightReservationState extends State<FlightReservation>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  bool roundtrip = true;
  int number = 0;
  int selectedIndex = 0;

  modNumber([bool add = true]) {
    if (mounted) {
      setState(() {
        if (add) {
          number++;
        } else {
          number--;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flightTypes = [
      {
        'svg': 'economy',
        'title': 'Economy',
      },
      {
        'svg': 'star',
        'title': 'First Class',
      },
      {
        'svg': 'premium',
        'title': 'Premium',
      },
      {
        'svg': 'business',
        'title': 'Business',
      }
    ];

    return Scaffold(
      extendBody: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(MediaQuery.of(context).padding.top + 24),
              InkWell(
                onTap: Navigator.of(context).pop,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back),
                    const Gap(24),
                    Text(
                      'Flight Reservation',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(18),
              ListenableBuilder(
                  listenable: _tabCtrl,
                  builder: (_, __) {
                    return Row(
                      // indicatorPadding: const EdgeInsets.symmetric(vertical: 8),
                      // controller: _tabCtrl,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _tabCtrl.animateTo(0);
                            },
                            child: Column(
                              children: [
                                Text(
                                  'Domestic',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: _tabCtrl.index == 0
                                            ? AppColors.primaryColor
                                            : const Color(0xFFB8B8B8),
                                      ),
                                ),
                                const Gap(2),
                                Divider(
                                  color: _tabCtrl.index == 0
                                      ? AppColors.primaryColor
                                      : const Color(0xFFB8B8B8),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _tabCtrl.animateTo(1);
                            },
                            child: Column(
                              children: [
                                Text(
                                  'International',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: _tabCtrl.index == 1
                                            ? AppColors.primaryColor
                                            : const Color(0xFFB8B8B8),
                                      ),
                                ),
                                const Gap(2),
                                Divider(
                                  color: _tabCtrl.index == 1
                                      ? AppColors.primaryColor
                                      : const Color(0xFFB8B8B8),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              const Gap(34),
              CustomTextfield(
                hintText: 'Departure',
                // trailingSvg: 'dropdown',
                readOnly: true,
                color: const Color(0xFFEEEEF0),
                showBorder: false,
                callback: () async {
                  await showflightSheet(context);
                },
              ),
              const Gap(17),
              CustomTextfield(
                hintText: 'Destination',
                // trailingSvg: 'dropdown',
                color: const Color(0xFFEEEEF0),
                readOnly: true,
                showBorder: false,
                callback: () async {
                  await showflightSheet(context, false);
                },
              ),
              const Gap(30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: .9,
                    color: AppColors.primaryColor,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(3000),
                          );
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          hintStyle:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 14,
                                  ),
                          border: InputBorder.none,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SvgPicture.asset(
                              'assets/svgs/date.svg',
                              height: 4,
                              width: 4,
                            ),
                          ),
                          hintText: 'Departure',
                        ),
                      ),
                    ),
                    const Gap(2),
                    Container(
                      height: 45,
                      width: 1,
                      color: AppColors.primaryColor,
                    ),
                    const Gap(2),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(3000),
                          );
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          hintStyle:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 14,
                                  ),
                          border: InputBorder.none,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SvgPicture.asset(
                              'assets/svgs/date.svg',
                              height: 4,
                              width: 4,
                            ),
                          ),
                          hintText: 'Destination',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(29),
              Row(
                children: [
                  primaryButton(
                    context,
                    title: 'Round Trip',
                    width: 160 * MediaQuery.of(context).textScaler.scale(1),
                    isOutlined: !roundtrip,
                    onTap: () {
                      setState(() {
                        roundtrip = true;
                      });
                    },
                  ),
                  const Spacer(),
                  primaryButton(
                    context,
                    title: 'One way Ticket',
                    width: 160 * MediaQuery.of(context).textScaler.scale(1),
                    isOutlined: roundtrip,
                    onTap: () {
                      setState(() {
                        roundtrip = false;
                      });
                    },
                  ),
                ],
              ),
              const Gap(29),
              passengerRow(
                context,
                title: 'Adults',
                val: number,
                onTap: modNumber,
              ),
              const Gap(17),
              passengerRow(
                context,
                title: 'Children',
                val: number,
                onTap: modNumber,
              ),
              const Gap(17),
              passengerRow(
                context,
                title: 'Infants',
                val: number,
                onTap: modNumber,
              ),
              const Gap(28),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Wrap(
                  runSpacing: 28,
                  spacing: 28,
                  children: List.generate(4, (index) {
                    return flightType(
                      context,
                      svg: flightTypes[index]['svg'] ?? '',
                      title: flightTypes[index]['title'] ?? '',
                      selected: false,
                    );
                  }),
                ),
              ),
              const Gap(46),
              primaryButton(context, title: 'Next', onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ConfirmFlight(),
                ));
              }),
              //
              Gap(MediaQuery.of(context).padding.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }
}

Widget flightType(
  BuildContext context, {
  required String svg,
  required String title,
  bool selected = false,
}) =>
    Column(
      children: [
        SvgPicture.asset(
          'assets/svgs/$svg.svg',
          colorFilter: ColorFilter.mode(
            selected ? const Color(0xFF9D9B9B) : AppColors.primaryColor,
            BlendMode.srcIn,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color:
                    selected ? const Color(0xFF9D9B9B) : AppColors.primaryColor,
              ),
        ),
      ],
    );

Widget passengerRow(
  BuildContext context, {
  required String title,
  int? val,
  required Function([bool]) onTap,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFEEEEF0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  onTap(false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const Gap(22),
              Text(
                '${val ?? '0'}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 21,
                    ),
              ),
              const Gap(22),
              InkWell(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.primaryColor,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );

Widget departureWidget(BuildContext context,
        {required String title, required String subtitle, Color? color}) =>
    Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color ?? const Color(0xFF0B76B2))),
          padding: const EdgeInsets.all(13),
          child: SvgPicture.asset(
            'assets/svgs/plane.svg',
            colorFilter: ColorFilter.mode(
              color ?? const Color(0xFFFF8684),
              BlendMode.srcIn,
            ),
          ),
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: const Color(0xFF9D9B9B),
                  ),
            ),
          ],
        ),
        const SizedBox(),
      ],
    );

Future showflightSheet(BuildContext context, [bool departure = true]) =>
    showModalBottomSheet(
      context: context,
      builder: (_) => IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Gap(40),
              InkWell(
                onTap: Navigator.of(context).pop,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/svgs/cancel_circle.svg'),
                    Text(
                      'Select ${departure ? 'Departure' : 'Destination'}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
              const Gap(30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      departureWidget(context,
                          title: 'Asaba International Airport',
                          subtitle: 'ABB. Asaba '),
                      const Gap(16),
                      const Divider(
                        color: AppColors.greyBorderColor,
                      ),
                      const Gap(16),
                      departureWidget(context,
                          title: 'Anambra International Cargo airport',
                          subtitle: 'ANA. Anambra State '),
                      const Gap(16),
                      const Divider(
                        color: AppColors.greyBorderColor,
                      ),
                      const Gap(16),
                      departureWidget(context,
                          title: 'Abuja IntL', subtitle: 'ABV.Abuja'),
                      const Gap(16),
                      const Divider(
                        color: AppColors.greyBorderColor,
                      ),
                      const Gap(16),
                      departureWidget(context,
                          title: 'Akure ', subtitle: 'AKR. Akure'),
                      const Gap(36),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

import 'package:waiz/resources/views/home/hotel_booking/search_hotel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/button.dart';
import 'book_hotel_now.dart';

class SingleHotelView extends StatefulWidget {
  const SingleHotelView({super.key});

  @override
  State<SingleHotelView> createState() => _SingleHotelViewState();
}

class _SingleHotelViewState extends State<SingleHotelView> {
  bool readMore = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(MediaQuery.of(context).padding.top + 24),
              Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: Image.asset(
                      'assets/images/hotel_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  InkWell(
                    onTap: Navigator.of(context).pop,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.arrow_back),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/svgs/heart.svg',
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Gap(24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        chip(context, title: 'Free Wifi', svg: 'wifi'),
                        const Gap(8),
                        chip(context, title: 'Free Breakfast', svg: 'coffee'),
                        const Gap(8),
                        chip(context, title: '5.0', svg: 'rating'),
                      ],
                    ),
                    const Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AN Palace Hotel',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/euro.svg',
                              height: 20,
                              width: 20,
                            ),
                            const Gap(2),
                            Text(
                              '200,7 ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                            ),
                            Text(
                              '/night',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: const Color(0xFF878787),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(24),
                    locationWidget(context, loc: 'Pimple  Gurav, Pune.'),
                    const Gap(24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: const Color(0xFF101010),
                          ),
                    ),
                    const Gap(12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          readMore = !readMore;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hotel Saudagar, Pune: See traveller reviews, 2 user photos and best deals for ... enjoy stay here, you will find great bars and restaurants near the hotel.',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: const Color(0xFF878787),
                                ),
                          ),
                          if (!readMore)
                            Text(
                              'Read More...',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: const Color(0xFF003130),
                                  ),
                            )
                        ],
                      ),
                    ),
                    const Gap(24),
                    const Divider(
                      color: Color(0xFFEDEDED),
                    ),
                    const Gap(24),
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.primaryColor,
                          ),
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        Image.asset('assets/images/preview1.png'),
                        const Gap(24),
                        Image.asset('assets/images/preview2.png'),
                      ],
                    ),
                    const Gap(33),
                    primaryButton(context, title: 'Book Now', onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const BookHotelNow(),
                      ));
                    }),
                  ],
                ),
              ),
              //

              Gap(MediaQuery.of(context).padding.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }
}

Widget chip(
  BuildContext context, {
  required String title,
  required String svg,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xB2F5F5FF),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/svgs/$svg.svg'),
          const Gap(8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );

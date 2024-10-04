import 'package:waiz/resources/views/home/hotel_booking/search_hotel_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/custom_textfield.dart';


class SearchHotel extends StatelessWidget {
  const SearchHotel({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = [
      'Pimple Gurav',
      'Baner',
      'Aundh',
      'UK',
      'Akurdi',
      'American',
      'London',
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(MediaQuery.of(context).padding.top + 24),

              const CustomTextfield(
                hintText: 'Search for country, Hotel',
                svgPrefix: 'arrow_back',
                trailingSvg: 'filter',
              ),
              const Gap(16),
              Row(
                children: [
                  SvgPicture.asset('assets/svgs/search_nearby.svg'),
                  const Gap(15),
                  Text(
                    'Search  nearby   ADNs',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.primaryColor,
                        ),
                  )
                ],
              ),
              const Gap(30),
              Text(
                'Continue your search',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(0xFF3E3E3E),
                    ),
              ),
              const Gap(30),
              locationWidget(context, loc: 'Pune'),
              const Gap(30),
              Text(
                'Frequently  searched  in Pune',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(0xFF3E3E3E),
                    ),
              ),
              const Gap(24),
              locationWidget(context, loc: 'All of Pune'),
              const Gap(24),
              const Divider(
                color: Color(0xFFEDEDED),
              ),
              const Gap(30),
              Wrap(
                spacing: 24,
                direction: Axis.vertical,
                children: List.generate(
                  locations.length,
                  (index) => locationWidget(
                    context,
                    loc: locations[index],
                  ),
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

Widget locationWidget(
  BuildContext context, {
  required String loc,
}) =>
    InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const SearchHotelResults(),
        ));
      },
      child: Row(
        children: [
          SvgPicture.asset('assets/svgs/location.svg'),
          const Gap(23),
          Text(
            loc,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: const Color(0xFF3E3E3E),
                ),
          ),
        ],
      ),
    );

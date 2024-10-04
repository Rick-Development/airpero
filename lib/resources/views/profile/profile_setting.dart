import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../app/Models/user/User.dart';
import '../../utils/app_colors.dart';
import '../../utils/button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/profile_image_picker.dart';

class ProfileSettingView extends StatelessWidget {
  const ProfileSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    User user =  User();
    print(user.getUserDetails());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Gap(MediaQuery.of(context).padding.top + 24),
            InkWell(
              onTap: Navigator.of(context).pop,
              splashColor: Colors.transparent,
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const Gap(24),
                  Text(
                    'Profile Setting',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
            const Gap(38),
            ProfileImagePicker(),
            const Gap(20),
            Text(
              user.username.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
            ),
            const Gap(30),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                 CustomTextfield(
                  hintText: user.fullName,
                   trailingSvg: 'check',
                ),
                CustomTextfield(
                  ctrl: TextEditingController(
                      text: "+${user.mobile}"),
                  trailingSvg: 'check',
                ),
                CustomTextfield(
                  ctrl: TextEditingController(text: User().email),
                  trailingSvg: 'check',
                ),
                 CustomTextfield(
                  hintText: '${user.address}',
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Male',
                    suffixIcon: SvgPicture.asset(
                      'assets/icons/dropdown.svg',
                      width: 16,
                      height: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(38),
                        borderSide: BorderSide(
                          color: AppColors.textGreyColor.withOpacity(.2),
                        ),
                    ),
                  ),
                  value: 'Male', // Default value
                  items: ['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto'
                      ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle value change
                    print(newValue);
                  },
                ),

              ],
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: primaryButton(
                    context,
                    title: 'Cancel',
                    isOutlined: true,
                    onTap: Navigator.of(context).pop,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: primaryButton(
                    context,
                    title: 'Save',
                    onTap: Navigator.of(context).pop,
                  ),
                ),
              ],
            ),
            Gap(MediaQuery.of(context).padding.bottom + 36),
          ],
        ),
      ),
    );
  }
}

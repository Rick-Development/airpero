import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class CardRequestConfirmScreen extends StatelessWidget {
  final String id;
  const CardRequestConfirmScreen({super.key, this.id = ""});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<CardController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "${_.title} Card Request",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              children: [
                if (_.dynamicFormList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Text(
                      "No data found",
                      style: context.t.bodyLarge,
                    ),
                  ),
                if (_.dynamicFormList.isNotEmpty) ...[
                  VSpace(50.h),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _.dynamicFormList.length,
                      itemBuilder: (context, i) {
                        var data = _.dynamicFormList[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${data.fieldLevel}",
                                  style: context.t.displayMedium?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.textFieldHintColor
                                          : AppColors.paragraphColor)),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerRight,
                                child: Text("${data.placeholder}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.t.displayMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    )),
                              )),
                            ],
                          ),
                        );
                      }),
                  VSpace(15.h),
                  AppButton(
                    isLoading: _.isBlocking ? true : false,
                    text: storedLanguage['Confirm'] ?? "Confirm",
                    onTap: () async {
                      await _.cardOrderConfirm(id: id, context: context);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}

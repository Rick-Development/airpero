import '../../../utils/app_constants.dart';

class OnBordingData {
  String imagePath;
  String title;
  String description;

  OnBordingData(
      {required this.imagePath,
      required this.title,
      required this.description});
}

List<OnBordingData> onBordingDataList = [
  OnBordingData(
      imagePath: "$rootImageDir/onbording_1.png",
      title: "Welcome to Waiz\nbank App!",
      description:
          "Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_2.png",
      title: "Easy Method for Tracking\nyour Finances",
      description:
          "Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_3.png",
      title: "Secure and Safe\nTransaction",
      description:
          "Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry."),
];

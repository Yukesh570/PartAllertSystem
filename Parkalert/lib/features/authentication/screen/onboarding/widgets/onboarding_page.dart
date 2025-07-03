import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });
  final String image, title, subTitle;

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    // Delay rendering image by 1 frame to fix dark mode cold-start issue
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Center(
        child: Column(
          children: [
            if (_isReady)
              Image.asset(
                widget.image,
                width: MediaQuery.of(context).size.height * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
              ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              widget.subTitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/navItems/alert/ringers.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  // void loadAndSetRingers() async {
  //   List<RingerData> savedRingers = await loadRingers();
  //   setState(() {
  //     ringersListdemo = savedRingers
  //         .map((data) => Ringers(ringerData: data))
  //         .toList();
  //     ringersList = savedRingers
  //         .map((data) => Ringers(ringerData: data))
  //         .toList();
  //   });
  //   print("ringersListactivity: $ringersListdemo");
  // }
  Widget build(BuildContext context) {
    print("aactivtyyyyyyyyy $ringersList");
    print("ringersListactivity: $ringersListdemo");

    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    return PageWrapper(
      routeName: '/activity',
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: dark ? Colors.black : Colors.white, // 👈 Add this

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          title: Text(
            loc.activity,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu, color: dark ? Colors.white : Colors.black),
            ),
          ),
        ),
        drawer: const navButton(),
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ), // smaller padding

                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "All activities & locations",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    Container(
                      height: 230, // 👈 set the height to your desired value
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.alert3,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // center horizontally
                        mainAxisAlignment:
                            MainAxisAlignment.start, // align to top
                        children: [
                          Text(
                            "All activities",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 230, // 👈 set the height to your desired value
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.alert2,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // center horizontally
                        mainAxisAlignment:
                            MainAxisAlignment.center, // align to top
                        children: [
                          Text(
                            " All location",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Expanded(
                            child: Transform.translate(
                              offset: const Offset(
                                0,
                                -10,
                              ), // 👈 shift upward by 10 pixels

                              child: Transform.scale(
                                scale: 1.8,

                                child: Image.asset(
                                  "assets/logos/location.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // other children here...
          ],
        ),
      ),
    );
  }
}

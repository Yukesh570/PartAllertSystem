import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/navItems/main_controller.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class navButton extends StatelessWidget {
  const navButton({super.key});
  TextStyle menuTextStyle({
    required bool isDark,
    required String isSelected,
    required String routeName,
  }) {
    return TextStyle(
      fontSize: 18,
      color: isSelected == routeName
          ? Colors.blueAccent
          : (isDark ? Colors.white : TColors.dark.withOpacity(0.87)),
      fontWeight: isSelected == routeName ? FontWeight.bold : FontWeight.w500,
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerCtrl = Get.put(DrawerControllerX());
    final MainController controller = Get.put(MainController());

    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? TColors.dark : Colors.white,
      child: ListView(
        padding: const EdgeInsets.only(top: 30, bottom: 20),
        children: [
          Obx(() {
            final isSelected = drawerCtrl.currentRoute.value;

            return Column(
              children: [
                _buildListTile(
                  icon: Icons.notifications_active_outlined,
                  label: loc.alerts,
                  style: menuTextStyle(
                    isDark: isDark,
                    isSelected: isSelected,
                    routeName: '/alerts',
                  ),
                  isDark: isDark,
                  onTap: () => _navigation(
                    context: context,
                    targetRoute: '/alerts',
                    onNavigate: controller.alertPage,
                    currentRoute: isSelected,
                  ),
                  // onTap: () {
                  //   if (isSelected != "/alerts") {
                  //     Navigator.pop(context);
                  //     Future.delayed(Duration(milliseconds: 180), () {
                  //       controller.alertPage();
                  //     });
                  //   } else {
                  //     Navigator.pop(context);
                  //   }
                  // },
                ),
                _buildListTile(
                  icon: Icons.location_on_outlined,
                  label: loc.freezones,
                  style: menuTextStyle(
                    isDark: isDark,
                    isSelected: isSelected,
                    routeName: '/freezone',
                  ),
                  isDark: isDark,
                  onTap: () => _navigation(
                    context: context,
                    targetRoute: '/freezone',
                    onNavigate: controller.freezone,
                    currentRoute: isSelected,
                  ),
                  // onTap: () {
                  //   if (isSelected != "/freezone") {
                  //     Navigator.pop(context);
                  //     Future.delayed(Duration(milliseconds: 180), () {
                  //       controller.freezone();
                  //     });
                  //   } else {
                  //     Navigator.pop(context);
                  //   }
                  // },
                ),
                _buildListTile(
                  icon: Icons.timeline_outlined,
                  label: loc.activity,
                  style: menuTextStyle(
                    isDark: isDark,
                    isSelected: isSelected,
                    routeName: '/activity',
                  ),
                  isDark: isDark,
                  onTap: () => _navigation(
                    context: context,
                    targetRoute: '/activity',
                    onNavigate: controller.activityPage,
                    currentRoute: isSelected,
                  ),
                  // onTap: () {
                  //   if (isSelected != "/activity") {
                  //     Navigator.pop(context);
                  //     Future.delayed(Duration(milliseconds: 180), () {
                  //       controller.activityPage();
                  //     });
                  //   } else {
                  //     Navigator.pop(context);
                  //   }
                  // },
                ),

                const Divider(height: 20, thickness: 1),

                _buildListTile(
                  icon: Icons.info_outline,
                  label: loc.yourInformation,
                  style: menuTextStyle(
                    isDark: isDark,
                    isSelected: isSelected,
                    routeName: '/yourinfo',
                  ),
                  isDark: isDark,
                  onTap: () => _navigation(
                    context: context,
                    targetRoute: '/yourinfo',
                    onNavigate: controller.yourinfo,
                    currentRoute: isSelected,
                  ),
                  // onTap: () {
                  //   if (isSelected != "/yourinfo") {
                  //     Navigator.pop(context);
                  //     Future.delayed(Duration(milliseconds: 180), () {
                  //       controller.yourinfo();
                  //     });
                  //   } else {
                  //     Navigator.pop(context);
                  //   }
                  // },
                ),
                _buildListTile(
                  icon: Icons.help_outline,
                  label: loc.howParkAlertWorks,
                  style: menuTextStyle(
                    isDark: isDark,
                    isSelected: isSelected,
                    routeName: '/working',
                  ),
                  isDark: isDark,
                  onTap: () => _navigation(
                    context: context,
                    targetRoute: '/working',
                    onNavigate: controller.working,
                    currentRoute: isSelected,
                  ),
                  // onTap: () {
                  //   if (isSelected != "/working") {
                  //     Navigator.pop(context);
                  //     Future.delayed(Duration(milliseconds: 180), () {
                  //       controller.working();
                  //     });
                  //   } else {
                  //     Navigator.pop(context);
                  //   }
                  // },
                ),
                _buildListTile(
                  icon: Icons.question_answer_outlined,
                  label: loc.frequentlyAskedQuestions,
                  style: menuTextStyle(
                    isDark: isDark,
                    isSelected: isSelected,
                    routeName: '/questions',
                  ),
                  isDark: isDark,
                  onTap: () => _navigation(
                    context: context,
                    targetRoute: '/questions',
                    onNavigate: controller.question,
                    currentRoute: isSelected,
                  ),
                  // onTap: () {
                  //   if (isSelected != "/questions") {
                  //     Navigator.pop(context);
                  //     Future.delayed(Duration(milliseconds: 180), () {
                  //       controller.question();
                  //     });
                  //   } else {
                  //     Navigator.pop(context);
                  //   }
                  // },
                ),

                const Divider(height: 20, thickness: 1),

                _buildListTile(
                  icon: Icons.description_outlined,
                  label: loc.termsAndConditions,
                  style: menuTextStyle(
                    isDark: isDark,
                    isSelected: isSelected,
                    routeName: '/terms',
                  ),
                  isDark: isDark,
                  onTap: () => _navigation(
                    context: context,
                    targetRoute: '/terms',
                    onNavigate: controller.termsandconditions,
                    currentRoute: isSelected,
                  ),
                  // onTap: () {
                  //   if (isSelected != "/terms") {
                  //     Navigator.pop(context);
                  //     Future.delayed(Duration(milliseconds: 180), () {
                  //       controller.termsandconditions();
                  //     });
                  //   } else {
                  //     Navigator.pop(context);
                  //   }
                  // },
                ),
                _buildListTile(
                  icon: Icons.lock_outline,
                  label: loc.privacyPolicyMenu,
                  style: menuTextStyle(
                    isDark: isDark,
                    isSelected: isSelected,
                    routeName: '/privacy',
                  ),
                  isDark: isDark,
                  onTap: () => _navigation(
                    context: context,
                    targetRoute: '/privacy',
                    onNavigate: controller.privacyPage,
                    currentRoute: isSelected,
                  ),
                  // onTap: () {
                  //   if (isSelected != "/privacy") {
                  //     Navigator.pop(context);
                  //     Future.delayed(Duration(milliseconds: 180), () {
                  //       controller.privacyPage();
                  //     });
                  //   } else {
                  //     Navigator.pop(context);
                  //   }
                  // },
                ),

                const Divider(height: 20, thickness: 1),

                _buildListTile(
                  icon: Icons.exit_to_app,
                  label: 'Exit ParkAlert',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark
                        ? Colors.white
                        : TColors.dark.withOpacity(0.87),
                  ),
                  isDark: isDark,

                  onTap: () => Navigator.pop(context),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _navigation({
    required BuildContext context,
    required String targetRoute,
    required VoidCallback onNavigate,
    required String currentRoute,
  }) {
    if (currentRoute != targetRoute) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 200), () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          onNavigate();
        });
      });
    }
  }

  Widget _buildListTile({
    required IconData icon,
    required String label,
    required TextStyle style,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white : TColors.dark),
      title: Text(label, style: style),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: isDark ? Colors.white12 : Colors.black12,
      onTap: onTap,
    );
  }
}

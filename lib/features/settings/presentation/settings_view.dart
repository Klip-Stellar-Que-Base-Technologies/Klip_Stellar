import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klip/core/services/auth_service.dart';
import 'package:klip/core/stellar/stellar_provider.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/gen/colors.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/klip_app_bar.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleExportSeed() async {
      final authService = ref.read(authServiceProvider);
      final authenticated = await authService.authenticate(
        localizedReason: 'Authenticate to view secret seed',
      );

      if (!authenticated) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication required to view secret seed'),
            ),
          );
        }
        return;
      }

      final keypairAsync = ref.read(walletKeypairProvider);
      final keypair = keypairAsync.asData?.value;
      final secretSeed = keypair?.secretSeed ?? 'No secret seed found';

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: ColorName.backgroundDark,
          title: Text("Secret Seed", style: AppTextStyle.b16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Keep your secret seed secure! Anyone with this key can control your funds.",
                style: AppTextStyle.r12.copyWith(color: Colors.redAccent),
              ),
              SizedBox(height: 12.h),
              SelectableText(
                secretSeed,
                style: AppTextStyle.m14.copyWith(color: Colors.amber),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: secretSeed));
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Secret seed copied to clipboard')),
                );
              },
              child: const Text("Copy"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: klipsAppBar(
        appBarStyle: AppBarStyle.type_2,
        typeLabel: "Settings",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            spacing: 22,
            children: [
              // ~ Wallet Management
              settingSection(
                label: "Wallet Management",
                children: [
                  // ~ Backup / Export Secret Seed (auth guarded)
                  Container(
                    margin: const EdgeInsets.only(top: 13),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: ColorName.greenBackground.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      onTap: handleExportSeed,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      leading: tileIcon(
                        Assets.svgIcons.privacySettingsIcon.svg(),
                      ),
                      title: Text("Backup / Export Secret Seed", style: AppTextStyle.m14),
                      subtitle: Text("Requires biometric authentication", style: AppTextStyle.l12),
                      trailing: Assets.svgIcons.caretDownIcon.svg(),
                    ),
                  ),

                  // ~ Connect Wallet
                  Container(
                    margin: const EdgeInsets.only(top: 13),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: ColorName.greenBackground.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      leading: tileIcon(
                        Assets.svgIcons.walletSettingsIcon.svg(),
                      ),
                      title: Text("Connect wallet", style: AppTextStyle.m14),
                      trailing: Assets.svgIcons.caretDownIcon.svg(),
                    ),
                  ),

                  // ~ Disconnect Wallet
                  Container(
                    margin: const EdgeInsets.only(top: 13),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: ColorName.greenBackground.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      leading: tileIcon(
                        Assets.svgIcons.disconnectSettingsIcon.svg(),
                      ),
                      title: Text("Disconnect wallet", style: AppTextStyle.m14),
                      trailing: Assets.svgIcons.caretDownIcon.svg(),
                    ),
                  ),
                ],
              ),

              // ~ Notification
              settingSection(
                label: "Notification",
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 13),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: ColorName.greenBackground.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      leading: tileIcon(
                        Assets.svgIcons.notificationSettingsIcon.svg(),
                      ),
                      title: Text(
                        "Withdrawal to wallet",
                        style: AppTextStyle.m14,
                      ),
                      subtitle: Text(
                        "Receive transaction and account update",
                        style: AppTextStyle.l12,
                      ),
                      trailing: Switch(value: false, onChanged: (value) {}),
                    ),
                  ),
                ],
              ),

              // ~ Theme
              settingSection(
                label: "Theme",
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 13),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: ColorName.greenBackground.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      leading: tileIcon(
                        Assets.svgIcons.notificationSettingsIcon.svg(),
                      ),
                      title: Text("Appearance ", style: AppTextStyle.m14),
                      subtitle: Text(
                        "Customize your app icon and feel",
                        style: AppTextStyle.l12,
                      ),
                    ),
                  ),
                ],
              ),

              // ~ Profile
              settingSection(
                label: "Profile",
                children: [
                  // ~ Update Email
                  Container(
                    margin: const EdgeInsets.only(top: 13),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: ColorName.greenBackground.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      leading: tileIcon(
                        Assets.svgIcons.walletSettingsIcon.svg(),
                      ),
                      title: Text("Update Email", style: AppTextStyle.m14),
                      trailing: Assets.svgIcons.caretDownIcon.svg(),
                    ),
                  ),

                  // ~ Update password
                  Container(
                    margin: const EdgeInsets.only(top: 13),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: ColorName.greenBackground.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      leading: tileIcon(
                        Assets.svgIcons.privacySettingsIcon.svg(),
                      ),
                      title: Text("Update Password", style: AppTextStyle.m14),
                      trailing: Assets.svgIcons.caretDownIcon.svg(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tileIcon(Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      width: 45.w,
      height: 45.h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: child,
    );
  }

  Widget settingSection({
    required String label,
    List<Widget> children = const <Widget>[],
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyle.b16),
        ...children,
      ],
    );
  }
}

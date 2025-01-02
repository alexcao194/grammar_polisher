import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/sense.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../commons/banner_ads.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'bloc/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const seeks = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.red,
  ];

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  WordStatus _status = WordStatus.unknown;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isGrantedNotificationsPermission = context.watch<NotificationsBloc>().state.isNotificationsGranted;
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final settingsSnapshot = state.settingsSnapshot;
        return BasePage(
          title: "Settings",
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: VocabularyItem(
                          word: Word(
                            word: "sample",
                            pos: "noun",
                            phonetic: "https://www.oxfordlearnersdictionaries.com/media/english/uk_pron/s/sam/sampl/sample__gb_3.mp3",
                            phoneticText: "/ˈsɑːmpl/",
                            phoneticAm: "https://www.oxfordlearnersdictionaries.com/media/english/us_pron/s/sam/sampl/sample__us_1.mp3",
                            phoneticAmText: "/ˈsæmpl/",
                            senses: [
                              Sense(
                                definition: "a number of people or things taken from a larger group and used in tests to provide information about the group",
                                examples: [],
                              )
                            ],
                            status: _status,
                          ),
                          onMastered: _onMastered,
                          onStar: _onStar,
                          viewOnly: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          "Color",
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          itemCount: SettingsScreen.seeks.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _onChangeColor(context, SettingsScreen.seeks[index].value),
                              child: Container(
                                width: 60,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: ColorScheme.fromSeed(
                                    seedColor: SettingsScreen.seeks[index],
                                    brightness: brightness,
                                  ).primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          "Theme",
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      RadioListTile<int>(
                        title: Text("Light"),
                        value: ThemeMode.light.index,
                        groupValue: settingsSnapshot.themeMode,
                        onChanged: (value) => _onChangeTheme(context, value),
                      ),
                      RadioListTile<int>(
                        title: Text("Dart"),
                        value: ThemeMode.dark.index,
                        groupValue: settingsSnapshot.themeMode,
                        onChanged: (value) => _onChangeTheme(context, value),
                      ),
                      RadioListTile<int>(
                        title: Text("System"),
                        value: ThemeMode.system.index,
                        groupValue: settingsSnapshot.themeMode,
                        onChanged: (value) => _onChangeTheme(context, value),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          "If you have any questions or suggestions, please contact us for support. We will respond as soon as possible.",
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _openContactMail,
                        child: Text("Contact us"),
                      ),
                      TextButton(
                        onPressed: _openTermsOfUse,
                        child: Text("Terms of Use"),
                      ),
                      TextButton(
                        onPressed: _openPrivacyPolicy,
                        child: Text("Privacy Policy"),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BannerAds(),
              ),
              if (!isGrantedNotificationsPermission)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RoundedButton(
                    onPressed: _openNotificationsSettings,
                    borderRadius: 16,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgNotifications,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            colorScheme.onPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text("Enable Notifications"),
                      ],
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  void _onChangeTheme(BuildContext context, int? value) {
    if (value == null) {
      return;
    }
    context.read<SettingsBloc>().add(
          SettingsEvent.saveSettings(
            themeMode: value,
          ),
        );
  }

  void _onChangeColor(BuildContext context, int value) {
    context.read<SettingsBloc>().add(
          SettingsEvent.saveSettings(
            seek: value,
          ),
        );
  }

  void _openNotificationsSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  void _onMastered() {
    if (_status == WordStatus.mastered) {
      setState(() {
        _status = WordStatus.unknown;
      });
    } else {
      setState(() {
        _status = WordStatus.mastered;
      });
    }
  }

  void _onStar() {
    if (_status == WordStatus.star) {
      setState(() {
        _status = WordStatus.unknown;
      });
    } else {
      setState(() {
        _status = WordStatus.star;
      });
    }
  }

  void _openContactMail() async {
    final contactEmail = const String.fromEnvironment("CONTACT_EMAIL");
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      query: 'subject=Feedback For Oxford Dictionary',
    );
    await launchUrl(emailLaunchUri);
  }

  void _openTermsOfUse() async {
    final termsOfUseUrl = const String.fromEnvironment("TERMS_OF_USE_URL");
    await launchUrl(Uri.parse(termsOfUseUrl));
  }

  void _openPrivacyPolicy() async {
    final privacyPolicyUrl = const String.fromEnvironment("PRIVACY_POLICY_URL");
    await launchUrl(Uri.parse(privacyPolicyUrl));
  }
}

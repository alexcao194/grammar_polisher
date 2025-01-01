import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/failure.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../utils/extensions/go_router_extension.dart';
import '../../../navigation/app_router.dart';
import '../home/bloc/home_bloc.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';

class HomeNavigation extends StatefulWidget {
  final Widget child;

  const HomeNavigation({super.key, required this.child});

  static const routes = [
    RoutePaths.home,
    RoutePaths.vocabulary,
    RoutePaths.notifications,
    RoutePaths.review,
    RoutePaths.settings,
  ];

  static const icons = [
    Assets.svgHome,
    Assets.svgVocabulary,
    Assets.svgNotifications,
    Assets.svgStar,
    Assets.svgSettings,
  ];

  static const labels = [
    "Grammar AI",
    "Oxford Words",
    "Reminders",
    "Review",
    "Settings",
  ];

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  late final AppLifecycleListener _appLifecycleListener;

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<HomeBloc>().state;

    final isLoading = homeState.isLoading;

    final colorScheme = Theme.of(context).colorScheme;

    final currentRoute = GoRouter.of(context).currentRoute;
    final selectedIndex = HomeNavigation.routes.indexOf(currentRoute);
    final selectedColor = colorScheme.primary;
    final unselectedColor = Colors.grey[600]!;

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            _handleError(context, state.failure);
          },
        ),
        BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state.wordIdFromNotification != null) {
              context.go(RoutePaths.vocabulary, extra: {'wordId': state.wordIdFromNotification});
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(child: widget.child),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.white.withAlpha(100),
                alignment: Alignment.center,
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: colorScheme.primary,
                  size: 48,
                ),
              )
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ), //
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: selectedIndex == -1 ? 0 : selectedIndex,
            selectedFontSize: 12,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: selectedColor,
            unselectedItemColor: unselectedColor,
            onTap: _onSelect,
            items: List.generate(
              HomeNavigation.labels.length,
              (index) => BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    color: index == selectedIndex ? colorScheme.primaryContainer : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    HomeNavigation.icons[index],
                    colorFilter: ColorFilter.mode(
                      index == selectedIndex ? selectedColor : unselectedColor,
                      BlendMode.srcIn,
                    ),
                    height: 24,
                  ),
                ),
                label: HomeNavigation.labels[index],
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    final notificationsBloc = context.read<NotificationsBloc>();
    notificationsBloc.add(const NotificationsEvent.requestPermissions());
    notificationsBloc.add(const NotificationsEvent.handleOpenAppFromNotification());
    context.read<VocabularyBloc>().add(const VocabularyEvent.getAllOxfordWords());
    _appLifecycleListener = AppLifecycleListener(
      onShow: () {
        debugPrint('NotificationsScreen: onShow');
        // this is needed to update the permissions status when the user returns to the app after changing the notification settings
        notificationsBloc.add(const NotificationsEvent.requestPermissions());
      },
    );
  }


  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
  }

  void _onSelect(int value) {
    context.go(HomeNavigation.routes[value]);
  }

  _handleError(BuildContext context, Failure? failure) {
    if (failure != null) {
      AppSnackBar.showError(context, failure.message);
    }
  }
}

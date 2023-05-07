import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// pages
import '../pages/pages.dart';

// constants
import '../utils/constants/constants.dart';

// providers
import '../providers/providers.dart';

class CustomPageViewController extends StatefulWidget {
  const CustomPageViewController({super.key});

  @override
  State<CustomPageViewController> createState() =>
      _CustomPageViewControllerState();
}

class _CustomPageViewControllerState extends State<CustomPageViewController> {
  final _pageTitles = [
    'Practice coordinates',
    'Practice square colors',
    'Practice moves'
  ];

  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const PracticeCoordinatesPage(),
    PracticeSquareColorsPage(),
    const PracticeMovesPage(),
  ];

  // page controller
  late final PageController _pageController;

  // follow up page routes
  final List<String> _followUpPageRoutes = [
    PracticeCoordinatesGameplayPage.routeName,
    PracticeSquareColorsGameplayPage.routeName,
    PracticeMovesGameplayPage.routeName,
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
          return Container(
            height: 70,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _currentPageIndex > 0
                      ? () {
                          setState(() {
                            _currentPageIndex -= 1;
                          });

                          _pageController.animateToPage(
                            _currentPageIndex,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.decelerate,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back_ios),
                  color: themeProvider.isDark()
                      ? kLightColorDarkTheme
                      : kLightColor,
                  iconSize: 14,
                  disabledColor: kGrayColor,
                ),
                Text(
                  '${_currentPageIndex + 1}. ${_pageTitles[_currentPageIndex]}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: themeProvider.isDark()
                            ? kLightColorDarkTheme
                            : kLightColor,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: _currentPageIndex < _pages.length - 1
                      ? () {
                          setState(() {
                            _currentPageIndex += 1;
                          });

                          _pageController.animateToPage(
                            _currentPageIndex,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.decelerate,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: themeProvider.isDark()
                      ? kLightColorDarkTheme
                      : kLightColor,
                  iconSize: 14,
                  disabledColor: kGrayColor,
                ),
              ],
            ),
          );
        }),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            children: _pages,
            onPageChanged: (value) {
              setState(() {
                _currentPageIndex = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(_followUpPageRoutes[_currentPageIndex]);
            },
            child: const Text('START'),
          ),
        )
      ],
    );
  }
}

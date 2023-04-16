import 'package:flutter/material.dart';

class CustomPageView extends StatefulWidget {
  const CustomPageView({super.key});

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  final _pageTitles = [
    'Practice coordinates',
    'Practice square colors',
    'Practice moves'
  ];

  int _currentPageIndex = 0;

  final List<Widget> _pages = [Text('1'), Text('2'), Text('3')];

  // page controller
  late final PageController _pageController;

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
        Container(
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
                color: Colors.white,
                iconSize: 14,
                disabledColor: Colors.grey,
              ),
              Text(
                '${_currentPageIndex + 1}. ${_pageTitles[_currentPageIndex]}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
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
                color: Colors.white,
                iconSize: 14,
                disabledColor: Colors.grey,
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: _pages,
            onPageChanged: (value) {
              setState(() {
                _currentPageIndex = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

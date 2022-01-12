import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';

enum MarketSortType {
  recommend,
  updated,
  likes,
  downloads,
}

class MarketWidget extends StatefulWidget {
  const MarketWidget({Key? key}) : super(key: key);

  @override
  _MarketWidgetState createState() => _MarketWidgetState();
}

class _MarketWidgetState extends State<MarketWidget> {
  MarketSortType _type = MarketSortType.recommend;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MarketSortType.recommend,
              MarketSortType.updated,
              MarketSortType.likes,
              MarketSortType.downloads,
            ]
                .map(
                  (e) => Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _type = e;
                          });
                        },
                        child: Center(
                          child: Text(
                            '${LocaleKeys.market_sort_types}.${e.name}'.tr(),
                            style: _type == e ? TextStyle(fontWeight: FontWeight.bold, fontSize: 15) : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: .3,
                color: context.t.dividerColor,
              ),
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            child: Column(
              children: [Text('asd')],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DButton.like(
                enabled: true,
                onTap: () {},
              ),
              DButton.download(
                enabled: true,
                onTap: () {},
              ),
            ]
                .map((e) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

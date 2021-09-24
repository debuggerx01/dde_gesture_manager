import 'package:dde_gesture_manager/extensions.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dde_gesture_manager/generated/locale_keys.g.dart';

class VersionChecker extends StatelessWidget {
  const VersionChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      initialData: null,
      builder: (context, snapshot) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (snapshot.hasData && snapshot.data != null)
            Text(
              '${LocaleKeys.version_current.tr()} : ${snapshot.data?.version ?? ''}',
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: TextButton(
              child: Text(LocaleKeys.version_check_update).tr(),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

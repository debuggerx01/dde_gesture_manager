import 'package:auto_size_text/auto_size_text.dart';
import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/http/api.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:dde_gesture_manager_api/models.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';

import 'dde_button.dart';

class MeWidget extends StatefulWidget {
  const MeWidget({Key? key}) : super(key: key);

  @override
  _MeWidgetState createState() => _MeWidgetState();
}

class _MeWidgetState extends State<MeWidget> {
  List<Scheme> uploads = [];

  @override
  void initState() {
    super.initState();
    Api.userUploads().then((value) {
      if (mounted)
        setState(() {
          uploads = value;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.person, size: defaultButtonHeight),
              Flexible(
                child: AutoSizeText(
                  context.watch<ConfigsProvider>().email ?? '',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  maxLines: 1,
                ),
              ),
              DButton.logout(
                enabled: true,
                onTap: () => context.read<ConfigsProvider>().setProps(accessToken: '', email: ''),
              ),
            ],
          ),
          Text('我的上传'),
          Container(
            height: 400,
            child: ListView.builder(
              itemBuilder: (context, index) => Text(uploads[index].name ?? ''),
              itemCount: uploads.length,
            ),
          ),
        ],
      ),
    );
  }
}

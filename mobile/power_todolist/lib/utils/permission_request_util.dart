import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:power_todolist/l10n/localization_intl.dart';

export 'package:permission_handler/permission_handler.dart';

class PermissionReqUtil {
  static PermissionReqUtil _instance;

  static PermissionReqUtil getInstance() {
    if (_instance == null) {
      _instance = PermissionReqUtil._internal();
    }
    return _instance;
  }

  PermissionReqUtil._internal();

  void requestPermission(
    PermissionGroup reqPermissions, {
    bool showDialog = true,
    @required BuildContext context,
    @required VoidCallback granted,
    VoidCallback denied,
    VoidCallback disabled,
    VoidCallback restricted,
    VoidCallback unknown,
    String deniedDes,
    String disabledDes,
    String restrictedDes,
    String unknownDes,
    String openSetting,
  }) async {
    Map<PermissionGroup, PermissionStatus> output = await PermissionHandler().requestPermissions([
      reqPermissions
    ]);

    switch (output[reqPermissions]) {
      case PermissionStatus.granted:
        if (granted != null) granted();
//        toShow(showDialog, context, reqPermissions, "Permission to apply successfully");
        break;
      case PermissionStatus.denied:
        if (denied != null) denied();
        toShow(
          showDialog,
          context,
          reqPermissions,
          deniedDes ?? MyLocalizations.of(context).deniedDes,
          openSetting ?? MyLocalizations.of(context).openSystemSetting,
          showOpenSettingButton: true,
        );
        break;
      case PermissionStatus.disabled:
        debugPrint("disabled:${reqPermissions}");
        if (disabled != null) {
          disabled();
          return;
        }
        ;
        toShow(showDialog, context, reqPermissions, disabledDes, openSetting);
        break;
      case PermissionStatus.restricted:
        debugPrint("restricted:${reqPermissions}");
        if (restricted != null) restricted();
        toShow(showDialog, context, reqPermissions, restrictedDes, openSetting, showOpenSettingButton: true);
        break;
      case PermissionStatus.unknown:
        debugPrint("Unknown:${reqPermissions}");
        if (unknown != null) unknown();
        toShow(showDialog, context, reqPermissions, unknownDes, openSetting);
        break;
    }
  }

  void toShow(bool showDialog, BuildContext context, PermissionGroup reqPermissions, String description, String openSetting, {bool showOpenSettingButton = false}) {
    if (showDialog) {
      if (context == null) throw FlutterError("\n\nWhen showOpenSettingButton is true, the context cannot be empty.\n");
      toShowDialog(
        context,
        "${reqPermissions}",
        description,
        openSetting,
        showOpenSettingButton: showOpenSettingButton,
      );
    }
  }

  void toShowDialog(BuildContext context, String permissionName, String description, String openSetting, {bool showOpenSettingButton = false}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("${permissionName} ${description}"),
          actions: <Widget>[
            showOpenSettingButton
                ? FlatButton(
                    onPressed: () {
                      PermissionHandler().openAppSettings();
                    },
                    child: Text(openSetting))
                : SizedBox(),
          ],
        );
      },
    );
  }
}
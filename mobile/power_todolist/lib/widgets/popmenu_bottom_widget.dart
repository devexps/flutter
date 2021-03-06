import 'package:flutter/material.dart';
import 'package:power_todolist/l10n/localization_intl.dart';

class PopMenuBtWidget extends StatelessWidget {
  final Color iconColor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const PopMenuBtWidget({
    Key key,
    this.iconColor,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (a) {
        switch (a) {
          case "edit":
            if (onEdit != null) onEdit();
            break;
          case "delete":
            if (onDelete != null) onDelete();
            break;
        }
      },
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: "edit",
            child: Container(
              child: Text(MyLocalizations.of(context).editTask),
              alignment: Alignment.centerLeft,
            ),
          ),
          PopupMenuItem(
            value: "delete",
            child: Container(
              child: Text(MyLocalizations.of(context).deleteTask),
              alignment: Alignment.centerLeft,
            ),
          ),
        ];
      },
      icon: Icon(
        Icons.more_vert,
        color: iconColor ?? Theme.of(context).primaryColor,
      ),
    );
  }
}

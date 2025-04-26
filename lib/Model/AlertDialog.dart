import 'package:flutter/material.dart';

// delete
Future<bool> showConfirmationDialog(
    BuildContext context, String memberName) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('تاكيد الحذف'),
            content: Text('   $memberNameهل تريد حذف من المجموعه'),
            //
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}

// for add admin

Future<bool> showAdminAlert(BuildContext context, String memberName) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Promote to Admin'),
            content: Text(' $memberName   ر هل تريد تعيين مشرفا في المجموعه'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}

/*
Future<bool> _showConfirmationDialog(
    BuildContext context, String memberName) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Do you want to remove $memberName from the group?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}
*/
Future<bool> ShowEditDialog(BuildContext context, String groupName) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('تعديل المجموعة'),
            content: Text('  هل تريد تغيير اسم   $groupName  واضافه اعضاء جدد'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}

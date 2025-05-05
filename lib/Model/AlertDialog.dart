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
                child:const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child:const Text('Yes'),
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
            title:const Text('Promote to Admin'),
            content: Text(' $memberName   ر هل تريد تعيين مشرفا في المجموعه'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child:const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child:const Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}


Future<bool> ShowEditDialog(BuildContext context, String groupName) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title:const Text('تعديل المجموعة'),
            content: Text('  هل تريد تغيير اسم   $groupName  واضافه اعضاء جدد'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child:const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child:const Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}

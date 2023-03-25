// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Color? titleColor;
  final Color? backgroundColor;
  final Icon? leftIcon;
  final bool? isShowLeftIcon;
  final bool? isShowActionIcon1;
  final bool? isShowActionIcon2;
  final bool? isShowActionIcon3;
  final Widget? actionIcon1;
  final Widget? actionIcon2;
  final Widget? actionIcon3;
  final VoidCallback? pressedLeftIcon;
  final VoidCallback? pressedActionIcon1;
  final VoidCallback? pressedActionIcon2;
  final VoidCallback? pressedActionIcon3;

  const CustomAppBar({
    Key? key,
    this.title,
    this.titleColor,
    this.backgroundColor,
    this.leftIcon,
    this.isShowLeftIcon = false,
    this.isShowActionIcon1 = false,
    this.isShowActionIcon2 = false,
    this.isShowActionIcon3 = false,
    this.actionIcon1 = const Icon(Icons.search),
    this.actionIcon2 = const Icon(Icons.alarm),
    this.actionIcon3 = const Icon(Icons.airline_seat_flat),
    this.pressedLeftIcon,
    this.pressedActionIcon1,
    this.pressedActionIcon2,
    this.pressedActionIcon3,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // centerTitle: true,
      title: title,
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: isShowLeftIcon!
          ? IconButton(
        icon: leftIcon!,
        onPressed: pressedLeftIcon,
      )
          : const Offstage(),
      actions: [
        Visibility(
          visible: isShowActionIcon1!,
          child: IconButton(
            icon: actionIcon1!,
            onPressed: pressedActionIcon1,
          ),
        ),
        Visibility(
          visible: isShowActionIcon2!,
          child: IconButton(
            icon: actionIcon2!,
            onPressed: pressedActionIcon2,
          ),
        ),
        Visibility(
          visible: isShowActionIcon3!,
          child: IconButton(
            icon: actionIcon3!,
            onPressed: pressedActionIcon3,
          ),
        )
      ],
    );
  }
}
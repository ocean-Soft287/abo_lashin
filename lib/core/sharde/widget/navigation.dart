import 'package:flutter/material.dart';
void navigato(context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return screen;
  }));
}

void navigatofinsh(
    context,
    Widget screen,
    bool routeee,
    ) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation)=>screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child)
      =>SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    ),(route) =>routeee ,



  );
}
void navigapop(context){
  Navigator.pop(context);
}

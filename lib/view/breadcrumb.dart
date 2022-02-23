import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

class TMTBreadCrumb extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return   BreadCrumb(
      items: <BreadCrumbItem>[
        //add your BreadCrumbItem here
      ],
      divider: Icon(Icons.chevron_right),
    );
  }}
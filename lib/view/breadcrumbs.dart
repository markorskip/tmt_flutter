import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

class TMTBreadCrumbs extends StatelessWidget {

  final List<String> breadCrumbs;

  const TMTBreadCrumbs(this.breadCrumbs);

  @override
  Widget build(BuildContext context) {
    if (breadCrumbs.length > 0) {
      // if (breadCrumbs.length > 3) this.breadCrumbs =
      //     breadCrumbs.sublist(breadCrumbs.length - 3, breadCrumbs.length);
      List<BreadCrumbItem> items = breadCrumbs.map(
              (e) =>
              BreadCrumbItem(
                content: Text(e),
                //onTap: _navigateUp // TODO implement link back or make only the parent linkable
              )).toList();
      return BreadCrumb(
        items: items,
        divider: Icon(Icons.chevron_right),
        overflow: WrapOverflow(
          keepLastDivider: false,
          direction: Axis.horizontal,
        ),
      );
    }
    return Container(width: 0.0, height: 0.0);
  }
}
import 'package:metro/model/route_info.dart';

List<String> show(final List<RouteInfo> routes) {
  List<String> s = [];
  for (final route in routes) {
    String show = '';
    if (route.path.length <= 9) {
      show += 'Ticket price : 8 LE.\n';
    } else if (route.path.length <= 16) {
      show += 'Ticket price : 10 LE.\n';
    } else if (route.path.length <= 23) {
      show += 'Ticket price : 15 LE.\n';
    } else {
      show += 'Ticket price : 20 LE.\n';
    }

    show += 'Stations: ${route.path.length}\n';
    if (route.time < 60) {
      show += 'Estimated Time is ${route.time} minutes.\n';
    } else {
      final hours = route.time ~/ 60;
      final minutes = route.time - hours * 60;
      show += 'Estimated Time is $hours hour and $minutes minutes.\n';
    }

    if (route.transStations.isEmpty) {
      show += 'No Trans on way\n';
    } else {
      show +=
      "The total trans stations is ${route.transStations.length} and it's ${route.transStations}.\n";
    }

    show += 'Path: ${route.path}.\n';
    show += '----------------------------\n';
    s.add(show);
  }
  return s;
}
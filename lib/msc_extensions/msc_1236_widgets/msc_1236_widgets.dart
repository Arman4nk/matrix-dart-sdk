/// Extensions related to widgets in a room. Widgets are not part of the Matrix specification yet.
library;

import 'package:matrix/matrix.dart';

export 'src/widget.dart';
import 'dart:math';

extension MatrixWidgets on Room {
  /// Returns all present Widgets in the room.
  List<MatrixWidget> get widgets => {
        ...states['m.widget'] ?? states['im.vector.modular.widgets'] ?? {},
      }.values.expand((e) {
        try {
          return [MatrixWidget.fromJson(e.content, this)];
        } catch (_) {
          return <MatrixWidget>[];
        }
      }).toList();


  String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }


  Future<String> addWidget(MatrixWidget widget) {
    final user = client.userID;
    final widgetId =
        randomString(24);

    final json = widget.toJson();
    json['creatorUserId'] = user;
    json['id'] = widgetId;
    return client.setRoomStateWithKey(
      id,
      'im.vector.modular.widgets',
      widgetId,
      json,
    );
  }

  Future<String> deleteWidget(String widgetId) {
    return client.setRoomStateWithKey(
      id,
      'im.vector.modular.widgets',
      widgetId,
      {},
    );
  }
}

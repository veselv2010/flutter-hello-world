import 'package:playlist_app/blocs/trackInfoFormatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TrackInfoFormatter formatter;

  setUp(() {
    formatter = TrackInfoFormatter();
  });

  test('Formatted duration', () {
    String result = formatter.getFormattedDuration(130000);
    expect(result, '2:10');
  });

  test('Remaining time', () {
    String result = formatter.getRemainingTime(127000, 130000);
    expect(result, '-0:03');
  });

  tearDown(() {});
}

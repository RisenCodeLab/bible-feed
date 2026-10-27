import 'package:bible_feed/manager/deeplink_in_manager.dart';
import 'package:bible_feed/manager/json_encoding_manager.dart';
import 'package:bible_feed/manager/share_in_manager.dart';
import 'package:bible_feed/service/deeplink_service.dart';
import 'package:bible_feed/service/toast_service.dart';
import 'package:bible_feed/view/_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import 'deeplink_in_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DeepLinkService>(), MockSpec<ShareInManager>(), MockSpec<ToastService>()])
void main() {
  group('DeepLinkInManager', () {
    late MockDeepLinkService mockDeepLinkService;
    late MockShareInManager mockShareInManager;
    late MockToastService mockToastService;

    setUp(() {
      mockDeepLinkService = .new();
      mockShareInManager = .new();
      mockToastService = .new();

      when(mockDeepLinkService.addListener(any)).thenAnswer((invocation) {
        final listener = invocation.positionalArguments[0] as void Function();
        listener(); // Simulate listener call immediately for testing
      });
    });

    parameterizedTest(
      'calls sync and shows success toast on valid deep link',
      [
        [
          'JSON as first parameter',
          'biblefeed://risencode.com/share?${Constants.deeplinkQueryKey}=H4sIAAAAAAAAA6tWyk6tVLJSKkvMKU1VqgUAv5wYPw8AAAA=',
        ],
        [
          'JSON as non-first parameter',
          'biblefeed://risencode.com/share?foo=bar&${Constants.deeplinkQueryKey}=H4sIAAAAAAAAA6tWyk6tVLJSKkvMKU1VqgUAv5wYPw8AAAA=',
        ],
      ],
      customDescriptionBuilder: (_, description, values) => '$description: ${values[0]}',
      (String _, String uri) {
        when(mockDeepLinkService.uri).thenReturn(Uri.parse(uri));
        DeepLinkInManager(mockDeepLinkService, JsonEncodingManager(), mockShareInManager, mockToastService);
        verify(mockShareInManager.sync('{"key":"value"}')).called(1);
        verify(mockToastService.showOk('Success!')).called(1);
        verifyNever(mockToastService.showError(any));
      },
    );

    test('shows error toast on invalid deep link', () {
      when(mockDeepLinkService.uri).thenReturn(Uri.parse('biblefeed://risencode.com/share?wrongkey=value'));
      DeepLinkInManager(mockDeepLinkService, JsonEncodingManager(), mockShareInManager, mockToastService);
      verify(mockToastService.showError(any)).called(1);
      verifyNever(mockToastService.showOk(any));
      verifyNever(mockShareInManager.sync(any));
    });
  });
}

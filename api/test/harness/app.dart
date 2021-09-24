import 'package:conduit_test/conduit_test.dart';
import 'package:dde_gesture_manager/dde_gesture_manager.dart';

export 'package:conduit/conduit.dart';
export 'package:conduit_test/conduit_test.dart';
export 'package:dde_gesture_manager/dde_gesture_manager.dart';
export 'package:test/test.dart';

/// A testing harness for dde_gesture_manager.
///
/// A harness for testing an conduit application. Example test file:
///
///         void main() {
///           Harness harness = Harness()..install();
///
///           test("GET /path returns 200", () async {
///             final response = await harness.agent.get("/path");
///             expectResponse(response, 200);
///           });
///         }
///
class Harness extends TestHarness<DdeGestureManagerChannel> with TestHarnessORMMixin {
  @override
  ManagedContext? get context => channel?.context;

  @override
  Future onSetUp() async {
    await resetData();
  }

  @override
  Future onTearDown() async {}

  @override
  Future seed() async {
    // restore any static data. called by resetData.
  }
}

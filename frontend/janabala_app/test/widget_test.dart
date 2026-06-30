import "package:flutter_test/flutter_test.dart";

import "package:janabala_app/models/enums.dart";

void main() {
  test("enum wire round-trips", () {
    expect(IssueCategory.fromWire("WATER"), IssueCategory.water);
    expect(IssueStatus.fromWire("in_progress"), IssueStatus.inProgress);
    expect(Urgency.fromWire("HIGH"), Urgency.high);
    expect(IssueCategory.fromWire("UNKNOWN"), IssueCategory.other);
  });
}

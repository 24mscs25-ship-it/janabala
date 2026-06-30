// Mirrors the FROZEN API CONTRACT enums. Keep in sync with the backend.

enum IssueCategory {
  roads("ROADS"),
  water("WATER"),
  electricity("ELECTRICITY"),
  waste("WASTE"),
  healthcare("HEALTHCARE"),
  education("EDUCATION"),
  transport("TRANSPORT"),
  streetlight("STREETLIGHT"),
  drainage("DRAINAGE"),
  park("PARK"),
  noise("NOISE"),
  other("OTHER");

  const IssueCategory(this.wire);
  final String wire;

  static IssueCategory fromWire(String value) =>
      IssueCategory.values.firstWhere(
        (c) => c.wire == value,
        orElse: () => IssueCategory.other,
      );
}

enum Urgency {
  low("LOW"),
  medium("MEDIUM"),
  high("HIGH");

  const Urgency(this.wire);
  final String wire;

  static Urgency fromWire(String value) => Urgency.values.firstWhere(
        (u) => u.wire == value,
        orElse: () => Urgency.low,
      );
}

enum IssueStatus {
  open("open"),
  inProgress("in_progress"),
  resolved("resolved");

  const IssueStatus(this.wire);
  final String wire;

  static IssueStatus fromWire(String value) => IssueStatus.values.firstWhere(
        (s) => s.wire == value,
        orElse: () => IssueStatus.open,
      );
}


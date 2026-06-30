import type { IssueStatus, Urgency } from "@/lib/types";

export function StatusBadge({ status }: { status: IssueStatus }) {
  const label = status.replace("_", " ");
  return <span className={`badge badge-${status}`}>{label}</span>;
}

export function UrgencyBadge({ urgency }: { urgency: Urgency }) {
  return <span className={`badge badge-urg-${urgency}`}>{urgency}</span>;
}

export function CategoryBadge({ category }: { category: string }) {
  return <span className="badge badge-cat">{category}</span>;
}

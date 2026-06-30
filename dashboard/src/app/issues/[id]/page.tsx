"use client";

import Link from "next/link";
import { useParams, useRouter } from "next/navigation";
import { useEffect, useState } from "react";

import { api } from "@/lib/api";
import { useAuth } from "@/lib/auth";
import {
  STATUSES,
  type IssueResponse,
  type IssueStatus,
} from "@/lib/types";
import { CategoryBadge, StatusBadge, UrgencyBadge } from "@/components/Badges";

export default function IssueDetailPage() {
  const params = useParams<{ id: string }>();
  const id = params.id;
  const router = useRouter();
  const { user, isAdmin } = useAuth();

  const [issue, setIssue] = useState<IssueResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [statusDraft, setStatusDraft] = useState<IssueStatus>("open");
  const [saving, setSaving] = useState(false);
  const [actionError, setActionError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    setLoading(true);
    api
      .getIssue(id)
      .then((data) => {
        if (!active) return;
        setIssue(data);
        setStatusDraft(data.status);
      })
      .catch((err) => {
        if (active) setError((err as Error).message ?? "Failed to load issue");
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => {
      active = false;
    };
  }, [id]);

  // Edit allowed for the reporting owner or an admin (matches API authz).
  const canEdit = Boolean(
    issue && user && (isAdmin || issue.user_id === user.id)
  );

  async function saveStatus() {
    if (!issue) return;
    setSaving(true);
    setActionError(null);
    try {
      const updated = await api.updateIssue(issue.id, { status: statusDraft });
      setIssue(updated);
    } catch (err) {
      setActionError((err as Error).message ?? "Failed to update");
    } finally {
      setSaving(false);
    }
  }

  async function remove() {
    if (!issue) return;
    if (!confirm("Delete this issue? This cannot be undone.")) return;
    setSaving(true);
    setActionError(null);
    try {
      await api.deleteIssue(issue.id);
      router.push("/");
    } catch (err) {
      setActionError((err as Error).message ?? "Failed to delete");
      setSaving(false);
    }
  }

  if (loading) return <p className="muted">Loading…</p>;
  if (error) return <p className="error">Error: {error}</p>;
  if (!issue) return <p className="muted">Issue not found.</p>;

  const hasGeo = issue.latitude != null && issue.longitude != null;

  return (
    <div className="stack">
      <Link href="/" className="muted">
        ← Back to issues
      </Link>

      <div className="row" style={{ justifyContent: "space-between" }}>
        <h1 style={{ margin: 0 }}>{issue.title}</h1>
      </div>

      <div className="tag-row">
        <CategoryBadge category={issue.category} />
        <UrgencyBadge urgency={issue.urgency} />
        <StatusBadge status={issue.status} />
      </div>

      <div className="card">
        <dl className="grid-detail">
          <dt>Description</dt>
          <dd>{issue.description || <span className="muted">—</span>}</dd>

          <dt>Constituency</dt>
          <dd>{issue.constituency_id || <span className="muted">—</span>}</dd>

          <dt>Reported by</dt>
          <dd>{issue.user_id || <span className="muted">—</span>}</dd>

          <dt>Created</dt>
          <dd>{new Date(issue.created_at).toLocaleString()}</dd>

          <dt>Updated</dt>
          <dd>{new Date(issue.updated_at).toLocaleString()}</dd>

          <dt>Location</dt>
          <dd>
            {hasGeo ? (
              <a
                href={`https://www.openstreetmap.org/?mlat=${issue.latitude}&mlon=${issue.longitude}#map=16/${issue.latitude}/${issue.longitude}`}
                target="_blank"
                rel="noreferrer"
              >
                {issue.latitude}, {issue.longitude} (map pin ↗)
              </a>
            ) : (
              <span className="muted">No coordinates</span>
            )}
          </dd>
        </dl>
      </div>

      {issue.photo_urls && issue.photo_urls.length > 0 && (
        <div className="card">
          <label>Photos</label>
          <div className="photos">
            {issue.photo_urls.map((url) => (
              // eslint-disable-next-line @next/next/no-img-element
              <img key={url} src={url} alt="Issue photo" />
            ))}
          </div>
        </div>
      )}

      {canEdit && (
        <div className="card stack">
          <h2 style={{ margin: 0, fontSize: 16 }}>
            {isAdmin ? "Admin actions" : "Manage your report"}
          </h2>
          {actionError && <p className="error">{actionError}</p>}
          <div className="row">
            <div className="field">
              <label htmlFor="status-edit">Status</label>
              <select
                id="status-edit"
                value={statusDraft}
                onChange={(e) => setStatusDraft(e.target.value as IssueStatus)}
              >
                {STATUSES.map((s) => (
                  <option key={s} value={s}>
                    {s.replace("_", " ")}
                  </option>
                ))}
              </select>
            </div>
            <button
              className="btn-primary"
              disabled={saving || statusDraft === issue.status}
              onClick={saveStatus}
            >
              {saving ? "Saving…" : "Update status"}
            </button>
          </div>

          {isAdmin && (
            <div>
              <button className="btn-danger" disabled={saving} onClick={remove}>
                Delete issue
              </button>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

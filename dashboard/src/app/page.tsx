"use client";

import Link from "next/link";
import { useEffect, useState } from "react";

import { api } from "@/lib/api";
import {
  CATEGORIES,
  STATUSES,
  type Category,
  type Constituency,
  type IssueResponse,
  type IssueStatus,
} from "@/lib/types";
import { CategoryBadge, StatusBadge, UrgencyBadge } from "@/components/Badges";

const PAGE_SIZE = 20;

export default function IssueListPage() {
  const [issues, setIssues] = useState<IssueResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [category, setCategory] = useState<Category | "">("");
  const [status, setStatus] = useState<IssueStatus | "">("");
  const [constituencyId, setConstituencyId] = useState("");
  const [page, setPage] = useState(0);

  const [constituencies, setConstituencies] = useState<Constituency[]>([]);

  useEffect(() => {
    void api.listConstituencies().then(setConstituencies).catch(() => {});
  }, []);

  useEffect(() => {
    let active = true;
    setLoading(true);
    setError(null);
    api
      .listIssues({
        category: category || undefined,
        status: status || undefined,
        constituency_id: constituencyId || undefined,
        limit: PAGE_SIZE,
        offset: page * PAGE_SIZE,
      })
      .then((data) => {
        if (active) setIssues(data);
      })
      .catch((err) => {
        if (active) setError(err.message ?? "Failed to load issues");
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => {
      active = false;
    };
  }, [category, status, constituencyId, page]);

  function resetTo(setter: (v: never) => void) {
    return (value: never) => {
      setPage(0);
      setter(value);
    };
  }

  return (
    <div>
      <div className="row" style={{ justifyContent: "space-between" }}>
        <h1 style={{ margin: "0 0 16px" }}>Civic Issues</h1>
      </div>

      <div className="filters">
        <div className="field">
          <label htmlFor="f-cat">Category</label>
          <select
            id="f-cat"
            value={category}
            onChange={(e) =>
              resetTo(setCategory as (v: never) => void)(
                e.target.value as never
              )
            }
          >
            <option value="">All</option>
            {CATEGORIES.map((c) => (
              <option key={c} value={c}>
                {c}
              </option>
            ))}
          </select>
        </div>

        <div className="field">
          <label htmlFor="f-status">Status</label>
          <select
            id="f-status"
            value={status}
            onChange={(e) =>
              resetTo(setStatus as (v: never) => void)(e.target.value as never)
            }
          >
            <option value="">All</option>
            {STATUSES.map((s) => (
              <option key={s} value={s}>
                {s.replace("_", " ")}
              </option>
            ))}
          </select>
        </div>

        <div className="field">
          <label htmlFor="f-const">Constituency</label>
          <select
            id="f-const"
            value={constituencyId}
            onChange={(e) =>
              resetTo(setConstituencyId as (v: never) => void)(
                e.target.value as never
              )
            }
          >
            <option value="">All</option>
            {constituencies.map((c) => (
              <option key={c.id} value={c.id}>
                {c.name}
              </option>
            ))}
          </select>
        </div>
      </div>

      {error && <p className="error">Error: {error}</p>}
      {loading ? (
        <p className="muted">Loading issues…</p>
      ) : issues.length === 0 ? (
        <p className="muted">No issues match these filters.</p>
      ) : (
        <div>
          {issues.map((issue) => (
            <Link
              key={issue.id}
              href={`/issues/${issue.id}`}
              className="issue-row"
              style={{ textDecoration: "none", color: "inherit" }}
            >
              <div style={{ flex: 1 }}>
                <h3>{issue.title}</h3>
                <div className="issue-meta">
                  {new Date(issue.created_at).toLocaleString()}
                </div>
              </div>
              <div className="tag-row">
                <CategoryBadge category={issue.category} />
                <UrgencyBadge urgency={issue.urgency} />
                <StatusBadge status={issue.status} />
              </div>
            </Link>
          ))}
        </div>
      )}

      <div className="pagination">
        <button disabled={page === 0} onClick={() => setPage((p) => p - 1)}>
          ← Prev
        </button>
        <span className="muted">Page {page + 1}</span>
        <button
          disabled={issues.length < PAGE_SIZE}
          onClick={() => setPage((p) => p + 1)}
        >
          Next →
        </button>
      </div>
    </div>
  );
}

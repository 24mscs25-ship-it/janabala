"use client";

import Link from "next/link";
import { useAuth } from "@/lib/auth";

export function TopBar() {
  const { user, isAdmin, logout, loading } = useAuth();

  return (
    <header className="topbar">
      <div className="topbar-inner">
        <Link href="/" className="brand">
          Jana<span>Bala</span>
        </Link>
        <Link href="/">Issues</Link>
        <div className="spacer" />
        {loading ? (
          <span className="muted">…</span>
        ) : user ? (
          <div className="row">
            <span className="muted">
              {user.name || user.phone}
              {isAdmin ? " · admin" : ""}
            </span>
            <button onClick={logout}>Log out</button>
          </div>
        ) : (
          <Link className="btn" href="/login">
            Log in
          </Link>
        )}
      </div>
    </header>
  );
}

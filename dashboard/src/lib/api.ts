// Single typed API client. The frozen contract lives here so the rest of the
// app never builds URLs or shapes requests by hand.

import type {
  Constituency,
  IssueCreate,
  IssueListParams,
  IssueResponse,
  IssueUpdate,
  SendOtpResponse,
  TokenResponse,
  User,
} from "./types";

const API_BASE =
  process.env.NEXT_PUBLIC_API_BASE ?? "http://127.0.0.1:8000/api/v1";

const TOKEN_KEY = "janabala.token";

export function getToken(): string | null {
  if (typeof window === "undefined") return null;
  return window.localStorage.getItem(TOKEN_KEY);
}

export function setToken(token: string): void {
  if (typeof window === "undefined") return;
  window.localStorage.setItem(TOKEN_KEY, token);
}

export function clearToken(): void {
  if (typeof window === "undefined") return;
  window.localStorage.removeItem(TOKEN_KEY);
}

export class ApiError extends Error {
  status: number;
  constructor(status: number, message: string) {
    super(message);
    this.name = "ApiError";
    this.status = status;
  }
}

interface RequestOptions {
  method?: string;
  body?: unknown;
  auth?: boolean;
  query?: Record<string, string | number | undefined>;
}

async function request<T>(path: string, opts: RequestOptions = {}): Promise<T> {
  const { method = "GET", body, auth = false, query } = opts;

  let url = `${API_BASE}${path}`;
  if (query) {
    const params = new URLSearchParams();
    for (const [key, value] of Object.entries(query)) {
      if (value !== undefined && value !== "") params.set(key, String(value));
    }
    const qs = params.toString();
    if (qs) url += `?${qs}`;
  }

  const headers: Record<string, string> = {};
  if (body !== undefined) headers["Content-Type"] = "application/json";
  if (auth) {
    const token = getToken();
    if (token) headers["Authorization"] = `Bearer ${token}`;
  }

  const res = await fetch(url, {
    method,
    headers,
    body: body !== undefined ? JSON.stringify(body) : undefined,
    cache: "no-store",
  });

  if (res.status === 204) return undefined as T;

  const text = await res.text();
  const data = text ? JSON.parse(text) : undefined;

  if (!res.ok) {
    const detail =
      data && typeof data === "object" && "detail" in data
        ? typeof data.detail === "string"
          ? data.detail
          : JSON.stringify(data.detail)
        : res.statusText;
    throw new ApiError(res.status, detail);
  }

  return data as T;
}

export const api = {
  // --- Auth ---
  sendOtp(phone: string): Promise<SendOtpResponse> {
    return request("/auth/send-otp", { method: "POST", body: { phone } });
  },
  verifyOtp(phone: string, otp: string): Promise<TokenResponse> {
    return request("/auth/verify-otp", {
      method: "POST",
      body: { phone, otp },
    });
  },
  me(): Promise<User> {
    return request("/auth/me", { auth: true });
  },

  // --- Issues ---
  listIssues(params: IssueListParams = {}): Promise<IssueResponse[]> {
    return request("/issues", {
      query: {
        constituency_id: params.constituency_id,
        category: params.category,
        status: params.status,
        limit: params.limit,
        offset: params.offset,
      },
    });
  },
  getIssue(id: string): Promise<IssueResponse> {
    return request(`/issues/${id}`);
  },
  createIssue(body: IssueCreate): Promise<IssueResponse> {
    return request("/issues", { method: "POST", body, auth: true });
  },
  updateIssue(id: string, body: IssueUpdate): Promise<IssueResponse> {
    return request(`/issues/${id}`, { method: "PUT", body, auth: true });
  },
  deleteIssue(id: string): Promise<void> {
    return request(`/issues/${id}`, { method: "DELETE", auth: true });
  },

  // --- Constituencies ---
  listConstituencies(q?: string): Promise<Constituency[]> {
    return request("/constituencies", { query: { q } });
  },
};

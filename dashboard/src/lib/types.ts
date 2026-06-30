// Mirrors the FROZEN API CONTRACT (base path /api/v1). Keep in sync with the
// backend OpenAPI docs at http://127.0.0.1:8000/docs.

export const CATEGORIES = [
  "ROADS",
  "WATER",
  "ELECTRICITY",
  "WASTE",
  "HEALTHCARE",
  "EDUCATION",
  "TRANSPORT",
  "STREETLIGHT",
  "DRAINAGE",
  "PARK",
  "NOISE",
  "OTHER",
] as const;
export type Category = (typeof CATEGORIES)[number];

export const URGENCIES = ["LOW", "MEDIUM", "HIGH"] as const;
export type Urgency = (typeof URGENCIES)[number];

export const STATUSES = ["open", "in_progress", "resolved"] as const;
export type IssueStatus = (typeof STATUSES)[number];

export interface User {
  id: string;
  phone: string;
  name: string | null;
  constituency_id: string | null;
  role: string;
  is_verified: boolean;
  created_at: string;
}

export interface IssueResponse {
  id: string;
  user_id: string | null;
  client_id: string | null;
  constituency_id: string | null;
  category: Category;
  title: string;
  description: string | null;
  latitude: number | null;
  longitude: number | null;
  photo_urls: string[] | null;
  urgency: Urgency;
  status: IssueStatus;
  created_at: string;
  updated_at: string;
}

export interface IssueCreate {
  category: Category;
  title: string;
  description?: string;
  constituency_id?: string;
  latitude?: number;
  longitude?: number;
  photo_urls?: string[];
  urgency: Urgency;
}

export interface IssueUpdate {
  category?: Category;
  title?: string;
  description?: string;
  constituency_id?: string;
  latitude?: number;
  longitude?: number;
  photo_urls?: string[];
  urgency?: Urgency;
  status?: IssueStatus;
}

export interface SendOtpResponse {
  message: string;
  debug_otp: string | null;
}

export interface TokenResponse {
  access_token: string;
  token_type: string;
}

export interface Constituency {
  id: string;
  name: string;
  code: string;
  district: string | null;
}

export interface IssueListParams {
  constituency_id?: string;
  category?: Category;
  status?: IssueStatus;
  limit?: number;
  offset?: number;
}

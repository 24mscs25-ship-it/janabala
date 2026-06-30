"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import { api } from "@/lib/api";
import { useAuth } from "@/lib/auth";

const isDev = process.env.NODE_ENV !== "production";

export default function LoginPage() {
  const router = useRouter();
  const { login } = useAuth();

  const [step, setStep] = useState<"phone" | "otp">("phone");
  const [phone, setPhone] = useState("");
  const [otp, setOtp] = useState("");
  const [debugOtp, setDebugOtp] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  async function handleSendOtp(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    try {
      const res = await api.sendOtp(phone.trim());
      setStep("otp");
      // debug_otp is only populated by the backend in DEBUG mode; show it in dev.
      setDebugOtp(isDev ? res.debug_otp : null);
      if (isDev && res.debug_otp) setOtp(res.debug_otp);
    } catch (err) {
      setError((err as Error).message ?? "Failed to send OTP");
    } finally {
      setBusy(false);
    }
  }

  async function handleVerify(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    try {
      const res = await api.verifyOtp(phone.trim(), otp.trim());
      await login(res.access_token);
      router.push("/");
    } catch (err) {
      setError((err as Error).message ?? "Failed to verify OTP");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="center-narrow">
      <div className="card stack">
        <h1 style={{ margin: 0 }}>Log in</h1>
        <p className="muted" style={{ margin: 0 }}>
          Sign in with your phone number and a one-time code.
        </p>

        {error && <p className="error">{error}</p>}

        {step === "phone" ? (
          <form onSubmit={handleSendOtp} className="stack">
            <div className="field">
              <label htmlFor="phone">Phone number</label>
              <input
                id="phone"
                type="tel"
                placeholder="9876543210"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                required
              />
            </div>
            <button className="btn-primary" disabled={busy || !phone.trim()}>
              {busy ? "Sending…" : "Send OTP"}
            </button>
          </form>
        ) : (
          <form onSubmit={handleVerify} className="stack">
            {debugOtp && (
              <div className="notice">
                Dev OTP: <strong>{debugOtp}</strong> (DEBUG mode only)
              </div>
            )}
            <div className="field">
              <label htmlFor="otp">One-time code</label>
              <input
                id="otp"
                inputMode="numeric"
                placeholder="123456"
                value={otp}
                onChange={(e) => setOtp(e.target.value)}
                required
              />
            </div>
            <div className="row">
              <button className="btn-primary" disabled={busy || !otp.trim()}>
                {busy ? "Verifying…" : "Verify & log in"}
              </button>
              <button
                type="button"
                onClick={() => {
                  setStep("phone");
                  setOtp("");
                  setDebugOtp(null);
                }}
              >
                Change number
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}

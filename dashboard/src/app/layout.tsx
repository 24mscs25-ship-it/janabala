import type { Metadata } from "next";
import "./globals.css";
import { AuthProvider } from "@/lib/auth";
import { TopBar } from "@/components/TopBar";

export const metadata: Metadata = {
  title: "JanaBala Dashboard",
  description: "Civic issue dashboard for the JanaBala platform",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <AuthProvider>
          <TopBar />
          <main className="container">{children}</main>
        </AuthProvider>
      </body>
    </html>
  );
}

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.routers import auth, constituencies, issues, sync

app = FastAPI(
    title=settings.APP_NAME,
    description="Backend API for the JanaBala Digital Democracy Platform",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(
    constituencies.router, prefix="/api/v1/constituencies", tags=["constituencies"]
)
app.include_router(issues.router, prefix="/api/v1/issues", tags=["issues"])
app.include_router(sync.router, prefix="/api/v1/sync", tags=["sync"])


@app.get("/api/v1/health", tags=["health"])
def health():
    return {"status": "healthy", "version": "1.0.0", "phase": "1"}

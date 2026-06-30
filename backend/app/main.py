import logging
import time
import uuid

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles

from app.config import settings
from app.core.logging_config import configure_logging
from app.routers import auth, constituencies, issues, sync, uploads
from app.storage import UPLOAD_ROOT

configure_logging("DEBUG" if settings.DEBUG else "INFO")
logger = logging.getLogger("janabala.request")

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


@app.middleware("http")
async def log_requests(request: Request, call_next):
    request_id = request.headers.get("X-Request-ID", uuid.uuid4().hex)
    start = time.perf_counter()
    response = await call_next(request)
    duration_ms = round((time.perf_counter() - start) * 1000, 2)
    logger.info(
        "request",
        extra={
            "request_id": request_id,
            "method": request.method,
            "path": request.url.path,
            "status_code": response.status_code,
            "duration_ms": duration_ms,
        },
    )
    response.headers["X-Request-ID"] = request_id
    return response


@app.exception_handler(Exception)
async def unhandled_exception_handler(request: Request, exc: Exception):
    # Log the full traceback server-side; never leak it to the client.
    logger.exception(
        "unhandled exception",
        extra={"method": request.method, "path": request.url.path},
    )
    return JSONResponse(status_code=500, content={"detail": "Internal server error"})


app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(
    constituencies.router, prefix="/api/v1/constituencies", tags=["constituencies"]
)
app.include_router(issues.router, prefix="/api/v1/issues", tags=["issues"])
app.include_router(sync.router, prefix="/api/v1/sync", tags=["sync"])
app.include_router(uploads.router, prefix="/api/v1/uploads", tags=["uploads"])

# Serve uploaded files. In production a CDN / object store would front these.
app.mount(
    settings.UPLOAD_URL_PREFIX,
    StaticFiles(directory=str(UPLOAD_ROOT)),
    name="media",
)


@app.get("/api/v1/health", tags=["health"])
def health():
    return {"status": "healthy", "version": "1.0.0", "phase": "1"}

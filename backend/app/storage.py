"""Local-disk storage for uploaded files.

UPLOAD_DIR is created on import so the app and StaticFiles mount can rely on it
existing. Swap this module for an S3/cloud backend later without touching the
router.
"""
from pathlib import Path

from app.config import settings

UPLOAD_ROOT = Path(settings.UPLOAD_DIR)
UPLOAD_ROOT.mkdir(parents=True, exist_ok=True)


def upload_path(name: str) -> Path:
    return UPLOAD_ROOT / name

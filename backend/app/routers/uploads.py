import uuid

from fastapi import APIRouter, Depends, File, HTTPException, Request, UploadFile, status

from app.config import settings
from app.deps import get_current_user
from app.models import User
from app.storage import upload_path

router = APIRouter()

# Allowed image content types -> file extension.
_ALLOWED = {
    "image/jpeg": ".jpg",
    "image/png": ".png",
    "image/webp": ".webp",
    "image/gif": ".gif",
}


@router.post("", status_code=201)
async def upload_file(
    request: Request,
    file: UploadFile = File(...),
    user: User = Depends(get_current_user),
):
    ext = _ALLOWED.get(file.content_type or "")
    if ext is None:
        raise HTTPException(
            status_code=status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
            detail=f"Unsupported file type: {file.content_type}",
        )

    # Read with a hard cap so a huge upload can't exhaust memory/disk.
    contents = await file.read(settings.UPLOAD_MAX_BYTES + 1)
    if len(contents) > settings.UPLOAD_MAX_BYTES:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail=f"File exceeds {settings.UPLOAD_MAX_BYTES} bytes",
        )

    name = f"{uuid.uuid4().hex}{ext}"
    dest = upload_path(name)
    dest.write_bytes(contents)

    url = f"{settings.UPLOAD_URL_PREFIX}/{name}"
    absolute = str(request.base_url).rstrip("/") + url
    return {"url": url, "absolute_url": absolute, "filename": name}

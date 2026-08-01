import os
import secrets
import subprocess

from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel

app = FastAPI()


class RunRequest(BaseModel):
    task: str


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/run")
def run_task(request: RunRequest, x_api_key: str = Header(None)):
    expected = os.environ.get("API_SECRET_KEY")
    if not expected or not x_api_key or not secrets.compare_digest(x_api_key, expected):
        raise HTTPException(status_code=401, detail="Unauthorized")

    result = subprocess.run(
        ["goose", "run", "-t", request.task],
        capture_output=True,
        text=True,
    )
    status = "ok" if result.returncode == 0 else "error"
    return {"status": status, "stdout": result.stdout, "stderr": result.stderr}

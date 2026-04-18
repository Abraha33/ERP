"""Fixtures base: sesión DB con rollback al cerrar (sin commits en tests)."""

import pytest
from sqlalchemy.orm import Session

from app.core.db import SessionLocal


@pytest.fixture
def db_session() -> Session:
    session = SessionLocal()
    try:
        yield session
    finally:
        session.rollback()
        session.close()

"""Modelos SQLAlchemy — módulo auth.

Tablas reales en Supabase (columnas sin guión bajo, convención del schema real):
  - user_profiles  (userid, empresaid, sucursalid, ...)
  - user_roles     (userid, rolid, empresaid, activo)
  - roles          (id, codigo, nombre) — IDs fijos seed
  - empresas       (id, nombre, createdat, ...)
  - sucursales     (id, empresaid, nombre, codigo, activa, ...)

NO usar Base.metadata.create_all() — el schema lo manejan
las migraciones SQL en supabase/migrations/.
Solo lectura/escritura via ORM; DDL exclusivo del CLI de Supabase.
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, ForeignKey, String, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base


class Empresa(Base):
    """Tenant raíz del sistema. Todas las tablas de negocio tienen empresaid."""
    __tablename__ = "empresas"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    nombre: Mapped[str] = mapped_column(Text, nullable=False)
    createdat: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    updatedat: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    # Relaciones
    sucursales: Mapped[list[Sucursal]] = relationship("Sucursal", back_populates="empresa")
    user_profiles: Mapped[list[UserProfile]] = relationship("UserProfile", back_populates="empresa")


class Sucursal(Base):
    """Sucursal / punto de operación de una empresa."""
    __tablename__ = "sucursales"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    # columna real: empresaid (sin guión bajo)
    empresaid: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("empresas.id", ondelete="RESTRICT"), nullable=False
    )
    nombre: Mapped[str] = mapped_column(Text, nullable=False)
    codigo: Mapped[str | None] = mapped_column(String(50), nullable=True)
    activa: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    created_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    updatedat: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    # Relaciones
    empresa: Mapped[Empresa] = relationship("Empresa", back_populates="sucursales")


class Rol(Base):
    """Catálogo de roles de aplicación. IDs fijos — no insertar desde el backend."""
    __tablename__ = "roles"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True)
    codigo: Mapped[str] = mapped_column(String(50), nullable=False, unique=True)
    nombre: Mapped[str] = mapped_column(Text, nullable=False)

    # IDs fijos conocidos (para referencias hardcodeadas seguras en seeds/tests)
    ADMIN_ID      = uuid.UUID("b0100000-0000-0000-0000-000000000001")
    ENCARGADO_ID  = uuid.UUID("b0200000-0000-0000-0000-000000000002")
    CAJERO_ID     = uuid.UUID("b0300000-0000-0000-0000-000000000003")
    BODEGUERO_ID  = uuid.UUID("b0400000-0000-0000-0000-000000000004")
    AUDITOR_ID    = uuid.UUID("b0500000-0000-0000-0000-000000000005")
    EMPLEADO_ID   = uuid.UUID("b0600000-0000-0000-0000-000000000006")


class UserProfile(Base):
    """Perfil de usuario: vínculo auth.users → empresa/sucursal.
    
    Columnas reales sin guión bajo: userid, empresaid, sucursalid, 
    createdat, createdby, updatedat, updatedby.
    """
    __tablename__ = "user_profiles"
    __table_args__ = (
        UniqueConstraint("userid", name="user_profiles_userid_key"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    # FK a auth.users — no mapeamos auth schema en ORM, solo el UUID
    userid: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False, unique=True)
    empresaid: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("empresas.id", ondelete="RESTRICT"), nullable=False
    )
    sucursalid: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True), ForeignKey("sucursales.id", ondelete="RESTRICT"), nullable=True
    )
    nombre: Mapped[str | None] = mapped_column(Text, nullable=True)
    activo: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    encargadoid: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), nullable=True)
    pendiente_aprobacion: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    createdat: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    createdby: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), nullable=True)
    updatedat: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    updatedby: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), nullable=True)

    # Relaciones
    empresa: Mapped[Empresa] = relationship("Empresa", back_populates="user_profiles")
    sucursal: Mapped[Sucursal | None] = relationship("Sucursal")
    user_roles: Mapped[list[UserRole]] = relationship(
        "UserRole", foreign_keys="UserRole.userid", primaryjoin="UserProfile.userid == UserRole.userid"
    )


class UserRole(Base):
    """Asignación de rol a usuario por empresa. Soporte multi-rol por empresa."""
    __tablename__ = "user_roles"
    __table_args__ = (
        UniqueConstraint("userid", "rolid", "empresaid", name="user_roles_userid_rolid_empresaid_key"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    userid: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    rolid: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("roles.id", ondelete="RESTRICT"), nullable=False
    )
    empresaid: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("empresas.id", ondelete="RESTRICT"), nullable=False
    )
    activo: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    createdat: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    createdby: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), nullable=True)
    updatedat: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    updatedby: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), nullable=True)

    # Relaciones
    rol: Mapped[Rol] = relationship("Rol")

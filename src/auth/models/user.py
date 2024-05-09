from pydantic import BaseModel


class User(BaseModel):
    username: str
    password: str


class UserWithPermission(User):
    permission: int


class PermissionRequest(BaseModel):
    permission: int
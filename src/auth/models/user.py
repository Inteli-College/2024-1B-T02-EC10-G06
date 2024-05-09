from pydantic import BaseModel


class User(BaseModel):
    username: str
    password: str


class UserWithPermission(User):
    permission: str

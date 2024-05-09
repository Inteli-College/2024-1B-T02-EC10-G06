from fastapi import APIRouter, Depends, HTTPException, status
from models.user import User, UserWithPermission
from controller.user_controller import addUserToQueue
from controller.user_controller import getUser
from middleware.auth import oauth2_scheme,generate_token, get_password_hash, validate_token
router = APIRouter()


@router.get("/createUser/")
def create_user(user: User):
    
    return addUserToQueue(user)


@router.get("/login/")
def login(user: User):
    user = getUser(user.username)
    if not user:
        raise HTTPException(status_code=400, detail="User not found")
    if not get_password_hash(user.password) == user.password:
        raise HTTPException(status_code=400, detail="Invalid password")
    token = generate_token({"username": user.username,"permission": user.permission})
    return {"token": token}

@router.get("/getPermission/")
def get_permission(token: str = Depends(oauth2_scheme),permission: int = 0):
    user,tokenPermission = validate_token(token)
    if permission == tokenPermission:
        return {"message": "Token is valid"}
    else:
        raise HTTPException(status_code=401, detail="Invalid permission")
    
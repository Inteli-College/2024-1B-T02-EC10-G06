from fastapi import APIRouter, Depends, HTTPException
from models.user import User, UserWithPermission, PermissionRequest
from controller.user_controller import addUserToQueue
from controller.user_controller import getUser
from middleware.auth import oauth2_scheme,generate_token, get_password_hash, validate_token, verify_password
from datetime import timedelta
router = APIRouter()


@router.post("/createUser/")
def create_user(user: UserWithPermission):
    
    return addUserToQueue(user)


@router.get("/login/")
def login(user: User):
    userDb = getUser(user.username)
    if not user:
        raise HTTPException(status_code=400, detail="User not found")
    if verify_password(user.password, userDb["password"]):
        token = generate_token({"username": user.username,"permission": userDb["permission"]}, timedelta(minutes=15))
        return {"token": token}
    raise HTTPException(status_code=400, detail="Invalid password")

@router.get("/getPermission/")
def get_permission(token: str = Depends(oauth2_scheme),permission: PermissionRequest = None):
    if permission is None:
        raise HTTPException(status_code=400, detail="Permission not provided")
    
    user,tokenPermission = validate_token(token)
    
    if permission.permission == tokenPermission:
        return {"message": "Token is valid"}
    else:
        raise HTTPException(status_code=401, detail="Invalid permission")
    
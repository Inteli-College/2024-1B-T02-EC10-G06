import jwt
from datetime import datetime, timedelta, timezone
from dotenv import load_dotenv
import os
from fastapi import HTTPException
from fastapi.security import OAuth2PasswordBearer
import bcrypt


load_dotenv() 

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="./login")

def generate_token(data: dict, expires_delta: timedelta):
    #print(data)
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire,"username": data["username"], "permission": data["permission"]})
    encoded_jwt = jwt.encode(to_encode, os.environ["SECRET_KEY"], algorithm=os.environ["ALGORITHM"])
    return encoded_jwt



def get_password_hash(password):
    bytePassword=  bcrypt.hashpw(bytes(password, "utf-8"), bcrypt.gensalt())
    stringPassword = bytePassword.decode()
    return stringPassword

def verify_password(plain_password, hashed_password):
    return bcrypt.checkpw(bytes(plain_password, "utf-8"), bytes(hashed_password, "utf-8"))

def validate_token(token):
    try:
        payload = jwt.decode(token, os.environ["SECRET_KEY"], algorithms=[os.environ["ALGORITHM"]])
        username: str = payload.get("username")
        permission: int = payload.get("permission")
        if username is None:
            raise HTTPException(status_code=400, detail="Invalid token")
        return username, permission
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=400, detail="Token has expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=400, detail="Invalid token")
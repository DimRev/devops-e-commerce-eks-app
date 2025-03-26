from pydantic import BaseModel, EmailStr, ValidationError

class LoginRequestSchema(BaseModel):
    email: EmailStr
    password: str

class LogoutRequestSchema(BaseModel):
    # No fields defined; extend as needed
    pass

class RegisterRequestSchema(BaseModel):
    email: EmailStr
    username: str
    password: str

def login_request_schema(req: dict) -> LoginRequestSchema:
    # Get data from the request; works for Flask's request or a plain dict
    data = req.get_json() if hasattr(req, 'get_json') else req
    try:
        return LoginRequestSchema.model_validate(data)
    except ValidationError as e:
        raise ValueError(f"Invalid login request: {e}")

def logout_request_schema(req: dict) -> LogoutRequestSchema:
    data = req.get_json() if hasattr(req, 'get_json') else req
    try:
        return LogoutRequestSchema.model_validate(data)
    except ValidationError as e:
        raise ValueError(f"Invalid logout request: {e}")

def register_request_schema(req: dict) -> RegisterRequestSchema:
    data = req.get_json() if hasattr(req, 'get_json') else req
    try:
        return RegisterRequestSchema.model_validate(data)
    except ValidationError as e:
        raise ValueError(f"Invalid register request: {e}")

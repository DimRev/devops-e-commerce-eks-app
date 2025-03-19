class LoginRequestSchema:
    def __init__(self, email, password):
        self.email = email
        self.password = password

class LogoutRequestSchema:
    pass

class RegisterRequestSchema:
    def __init__(self, email, username, password):
        self.email = email
        self.username = username
        self.password = password

def login_request_schema(req: dict) -> LoginRequestSchema:
    data = req.get_json() if hasattr(req, 'get_json') else req

    if 'email' not in data or 'password' not in data:
        raise ValueError("Invalid login request. 'email' and 'password' are required.")

    email = data['email']
    password = data['password']
    if not isinstance(email, str) or not isinstance(password, str):
        raise ValueError("Invalid data types for 'email' or 'password'.")

    return LoginRequestSchema(email, password)


def logout_request_schema(req: dict):
    return LogoutRequestSchema()


def register_request_schema(req: dict):
    data = req.get_json() if hasattr(req, 'get_json') else req

    required_fields = ['email', 'username', 'password']
    for field in required_fields:
        if field not in data:
            raise ValueError(f"Invalid register request. '{field}' is required.")

    email = data['email']
    username = data['username']
    password = data['password']
    if not all(isinstance(field, str) for field in [email, username, password]):
        raise ValueError("All fields ('email', 'username', 'password') must be strings.")

    return RegisterRequestSchema(email, username, password)

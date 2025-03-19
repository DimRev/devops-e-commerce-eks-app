from auth.auth_schema import LoginRequestSchema, LogoutRequestSchema, RegisterRequestSchema

class AuthService:
    def __init__(self):
        pass

    def login(self, login_request: LoginRequestSchema):
        return "login not implemented"

    def logout(self, logout_request: LogoutRequestSchema):
        return "logout not implemented"

    def register(self, register_request: RegisterRequestSchema):
        return "register not implemented"

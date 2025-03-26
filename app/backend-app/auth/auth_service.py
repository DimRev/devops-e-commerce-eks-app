from auth.auth_schema import LoginRequestSchema, LogoutRequestSchema, RegisterRequestSchema
from data_stream.data_streamer import DataStreamer

data_streamer = DataStreamer()
class AuthService:
    def __init__(self):
        pass

    def login(self, login_request: LoginRequestSchema):
        data_streamer.send_info_log_event(f"User {login_request.email} is trying to login")
        return "login not implemented"

    def logout(self, logout_request: LogoutRequestSchema):
        data_streamer.send_info_log_event(f"User is trying to logout")
        return "logout not implemented"

    def register(self, register_request: RegisterRequestSchema):
        data_streamer.send_info_log_event(f"User {register_request.email} is trying to register")
        return "register not implemented"

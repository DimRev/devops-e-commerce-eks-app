import os

class Config:
    _instance = None

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super(Config, cls).__new__(cls, *args, **kwargs)
            # Initialize once here by setting the underlying variables
            cls._instance._ENV = os.getenv("ENV")
            cls._instance._APP_NAME = os.getenv("APP_NAME")
            cls._instance._KINESIS_STREAM_NAME = os.getenv("KINESIS_STREAM_NAME")
            cls._instance._AWS_REGION = os.getenv("AWS_REGION")
            cls._instance._VERSION = os.getenv("VERSION")
        return cls._instance


    def __init__(self):
        pass

    @property
    def ENV(self):
        return self._ENV

    @property
    def APP_NAME(self):
        return self._APP_NAME

    @property
    def KINESIS_STREAM_NAME(self):
        return self._KINESIS_STREAM_NAME

    @property
    def AWS_REGION(self):
        return self._AWS_REGION

    @property
    def VERSION(self):
        return self._VERSION
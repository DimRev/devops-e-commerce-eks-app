import os
import boto3
import json
import datetime
from enum import Enum
from pydantic import BaseModel
from uuid import uuid4
from config.config import Config

class LogLevel(Enum):
    INFO = "INFO"
    ERROR = "ERROR"
    WARNING = "WARNING"
    DEBUG = "DEBUG"
    CRITICAL = "CRITICAL"

class LogEvent(BaseModel):
    id: str
    timestamp: str
    message: str
    level: LogLevel

class DataStreamer:
    _instance = None

    def __new__(cls, stream_name=None, region_name=None):
        if cls._instance is None:
            cls._instance = super(DataStreamer, cls).__new__(cls)
            cls._instance._initialized = False
        return cls._instance

    def __init__(self, stream_name=None, region_name=None):
        # Prevent reinitialization on subsequent instantiations
        if self._initialized:
            return

        cfg = Config()
        self.stream_name = stream_name or cfg.KINESIS_STREAM_NAME
        self.region_name = region_name or cfg.AWS_REGION
        self.client = boto3.client("kinesis", region_name=self.region_name)
        self._initialized = True

    def __send_log_event(self, log_event: LogEvent, partition_key: str = "default"):
        """
        Sends a log event to the Kinesis stream.
        :param log_event: A dict or JSON string representing the event.
        :param partition_key: The partition key used by Kinesis (should be a string).
        :return: Response from the Kinesis put_record call.
        """
        # Convert dict to JSON if needed
        if isinstance(log_event, dict):
            log_event = json.dumps(log_event)
        # Ensure log event is in bytes
        if isinstance(log_event, str):
            log_event = log_event.encode("utf-8")

        response = self.client.put_record(
            StreamName=self.stream_name,
            Data=log_event,
            PartitionKey=partition_key
        )
        return response

    def send_info_log_event(self, message: str, partition_key: str = "default"):
        """
        Sends an info log event to the Kinesis stream.
        :param message: The message to send.
        :param partition_key: The partition key used by Kinesis (should be a string).
        :return: Response from the Kinesis put_record call.
        """
        log_event = LogEvent(
            id=str(uuid4()),
            timestamp=str(datetime.datetime.now()),
            message=message,
            level=LogLevel.INFO
        )
        return self.__send_log_event(log_event, partition_key)

    def send_error_log_event(self, message: str, partition_key: str = "default"):
        """
        Sends an error log event to the Kinesis stream.
        :param message: The message to send.
        :param partition_key: The partition key used by Kinesis (should be a string).
        :return: Response from the Kinesis put_record call.
        """
        log_event = LogEvent(
            id=str(uuid4()),
            timestamp=str(datetime.datetime.now()),
            message=message,
            level=LogLevel.ERROR
        )
        return self.__send_log_event(log_event, partition_key)

    def send_warning_log_event(self, message: str, partition_key: str = "default"):
        """
        Sends a warning log event to the Kinesis stream.
        :param message: The message to send.
        :param partition_key: The partition key used by Kinesis (should be a string).
        :return: Response from the Kinesis put_record call.
        """
        log_event = LogEvent(
            id=str(uuid4()),
            timestamp=str(datetime.datetime.now()),
            message=message,
            level=LogLevel.WARNING
        )
        return self.__send_log_event(log_event, partition_key)

    def send_debug_log_event(self, message: str, partition_key: str = "default"):
        """
        Sends a debug log event to the Kinesis stream.
        :param message: The message to send.
        :param partition_key: The partition key used by Kinesis (should be a string).
        :return: Response from the Kinesis put_record call.
        """
        log_event = LogEvent(
            id=str(uuid4()),
            timestamp=str(datetime.datetime.now()),
            message=message,
            level=LogLevel.DEBUG
        )
        return self.__send_log_event(log_event, partition_key)

    def send_critical_log_event(self, message: str, partition_key: str = "default"):
        """
        Sends a critical log event to the Kinesis stream.
        :param message: The message to send.
        :param partition_key: The partition key used by Kinesis (should be a string).
        :return: Response from the Kinesis put_record call.
        """
        log_event = LogEvent(
            id=str(uuid4()),
            timestamp=str(datetime.datetime.now()),
            message=message,
            level=LogLevel.CRITICAL
        )
        return self.__send_log_event(log_event, partition_key)
from enum import Enum


class Category(str, Enum):
    ROADS = "ROADS"
    WATER = "WATER"
    ELECTRICITY = "ELECTRICITY"
    WASTE = "WASTE"
    HEALTHCARE = "HEALTHCARE"
    EDUCATION = "EDUCATION"
    TRANSPORT = "TRANSPORT"
    STREETLIGHT = "STREETLIGHT"
    DRAINAGE = "DRAINAGE"
    PARK = "PARK"
    NOISE = "NOISE"
    OTHER = "OTHER"


class Urgency(str, Enum):
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"


class Status(str, Enum):
    OPEN = "open"
    IN_PROGRESS = "in_progress"
    RESOLVED = "resolved"

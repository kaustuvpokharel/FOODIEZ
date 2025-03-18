import os

DEVELOPMENT = os.getenv("DEVELOPMENT", "False").lower() in ("true", "1")

if DEVELOPMENT:
    from .development import *
else:
    from .production import *

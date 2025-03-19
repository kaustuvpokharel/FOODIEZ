import os
from pathlib import Path

import environ

env = environ.Env(
    DEVELOPMENT=(bool, False)
)
environ.Env.read_env(os.path.join(Path(__file__).resolve().parent.parent.parent, ".env"))

DEVELOPMENT = env("DEVELOPMENT")

if DEVELOPMENT:
    from .development import *
elif DEVELOPMENT is False:
    from .production import *

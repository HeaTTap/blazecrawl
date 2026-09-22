"""BlazeCrawl Python SDK (OSS)."""

from importlib.metadata import PackageNotFoundError
from importlib.metadata import version as _dist_version

from blazecrawl.client import BlazeCrawl
from blazecrawl.exceptions import (
    AuthError,
    BlazeCrawlError,
    NotFoundError,
    RateLimitError,
    ValidationError,
)

try:
    # Single source of truth: the installed distribution metadata, generated
    # from pyproject.toml at build time.
    __version__ = _dist_version("blazecrawl")
except PackageNotFoundError:  # running from a source tree without install
    __version__ = "0.0.0+unknown"
__all__ = [
    "BlazeCrawl",
    "BlazeCrawlError",
    "AuthError",
    "NotFoundError",
    "RateLimitError",
    "ValidationError",
    "__version__",
]

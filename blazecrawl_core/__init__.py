"""BlazeCrawl Core — security-first, self-hostable web-data engine.

BlazeCrawl Core turns web pages into clean, LLM-ready Markdown and structured
data via ``/v1/scrape``, ``/v1/crawl`` and ``/v1/map``. It is the open-source
engine; managed infrastructure (hosted proxies, managed LLM extraction,
enterprise tenancy) lives in the separate commercial BlazeCrawl Cloud product.
"""

from importlib.metadata import PackageNotFoundError
from importlib.metadata import version as _dist_version

try:
    # Single source of truth: the installed distribution metadata, which is
    # generated from pyproject.toml at build time. This makes runtime version
    # drift (the v0.1.1 defect) impossible for installed artifacts.
    __version__ = _dist_version("blazecrawl-core")
except PackageNotFoundError:  # running from a source tree without install
    __version__ = "0.0.0+unknown"

__all__ = ["__version__"]

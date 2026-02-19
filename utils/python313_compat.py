"""
Compatibility shim for Python 3.13+.

antlr4 (dependency of tarski) does "from typing.io import TextIO", but typing.io
was removed in Python 3.13. We register a fake typing.io in sys.modules.
"""
import sys
import types
import typing

if sys.version_info >= (3, 13) and "typing.io" not in sys.modules:
    typing_io = types.ModuleType("typing.io")
    typing_io.TextIO = typing.TextIO
    sys.modules["typing.io"] = typing_io

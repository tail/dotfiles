import functools


class ContextDecorator(object):
    """
    Backport of contextlib.ContextDecorator from Python 3.2.
    """

    def __call__(self, func):
        @functools.wraps(func)
        def decorated(*args, **kwargs):
            with self:
                return func(*args, **kwargs)

        return decorated

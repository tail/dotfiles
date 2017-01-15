"""Collection of profiling utility functions."""

import cProfile
import pstats
import time
from collections import defaultdict
from contextlib import contextmanager

from tail.utils import ContextDecorator

_accumulated = defaultdict(lambda: defaultdict(float))


class Accumulator(ContextDecorator):
    """
    Context manager / decorator which accumulates the time based on a
    group-name pair.

      >>> with Accumulator('sleep', 'half_second'):
      ...   time.sleep(0.5)
      ...

      >>> @Accumulator('sleep', 'quarter_second'):
      ... def sleep_quarter_second():
      ...   time.sleep(0.25)
      ...

    """

    def __init__(self, group, name):
        self.group = group
        self.name = name

    def __enter__(self):
        self.start = time.time()

    def __exit__(self, *exc):
        _accumulated[self.group][self.name] += (time.time() - self.start)


def print_accumulated(group=None, threshold_pct=0, reverse=True):
    """
    Print out accumulated timing.

    :param group: Group to print out stats for (optional, will print out all
                  groups if None).

    :param threshold_pct: Minimum percentage of time stat must take of overall
                          total time to be displayed.

    :param reverse: If True, print stats in descending order based on time
                    taken.

    """
    if group:
        groups = [group]
    else:
        groups = _accumulated.keys()

    for group in groups:
        print '===== %s =====' % (group, )
        group = _accumulated[group]

        total = sum(v for k, v in group.iteritems())
        try:
            max_key_length = max(len(k) for k, v in group.iteritems() if (v / total * 100) > threshold_pct)
        except ValueError:
            # If there aren't any keys matching, we can just bail now.
            return

        for k, v in sorted(group.iteritems(), key=lambda k: k[1], reverse=reverse):
            pct = v / total * 100
            if pct > threshold_pct:
                print ('  %' + str(max_key_length) + 's\t%.2fs\t(%.2f%%)') % (k, v, pct)

        print


@contextmanager
def profile_pstats(sort, *args):
    """
    A simple context manager around using cProfile.
    """
    profile = cProfile.Profile()
    profile.enable()

    yield

    profile.disable()

    ps = pstats.Stats(profile).sort_stats(sort)
    ps.print_stats(*args)

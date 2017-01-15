import os
import subprocess
global subprocess

# HACK: Prevent pyflakes from complaining.
dstat = globals()['dstat']


class dstat_plugin(dstat):
    """
    Displays a count of the number of current connections to a
    PostgreSQL database.
    """

    def __init__(self):
        self.name = 'pg conns'
        self.nick = ('act', 'iit', 'idle', 'tot',)
        self.vars = ('active', 'iit', 'idle', 'total',)
        self.type = 'd'     # decimal
        self.width = 4
        self.scale = 100

    ##################
    # Helper methods #
    ##################

    def shell(self, cmd, *args):
        return subprocess.Popen(cmd.split() + (list(args) or []),
                                stdout=subprocess.PIPE).stdout.read().strip()

    def execute_sql(self, sql):
        return self.shell('%s -t postgres -c' % (self.PSQL_BIN,), *[sql])

    #################
    # Dstat methods #
    #################

    def check(self):
        self.PSQL_BIN = self.shell('which psql')
        if not os.access(self.PSQL_BIN, os.X_OK):
            raise Exception('Missing PostgreSQL client binary.')
        if not self.execute_sql('SELECT 1'):
            raise Exception('Could not query PostgreSQL.')

    def extract(self):
        self.val['total'] = 0
        self.val['active'], self.val['iit'], self.val['idle'] = [int(v.strip()) for v in self.execute_sql("""
        SELECT
            (SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'active'),
            (SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'idle in transaction'),
            (SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'idle')
        """).split('|')]
        self.val['total'] = sum(self.val.values())

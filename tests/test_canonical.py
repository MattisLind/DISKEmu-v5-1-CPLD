import itertools
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from canonical_netlist import BDD


class CanonicalTests(unittest.TestCase):
    def test_every_three_variable_function_has_an_exact_cover(self):
        assignments = list(itertools.product((0, 1), repeat=3))
        for table in range(256):
            bdd = BDD(['A', 'B', 'C'])
            function = 0
            for index, values in enumerate(assignments):
                if (table >> index) & 1:
                    function = bdd.apply('or', function, bdd.cube(dict(enumerate(values))))
            cover = bdd.cover(function)
            for index, values in enumerate(assignments):
                actual = any(all(values[v] == bit for v, bit in cube) for cube in cover)
                self.assertEqual(actual, bool((table >> index) & 1), (table, values))

    def test_factoring_and_gate_order_do_not_change_canonical_cover(self):
        covers = []
        for factored in (False, True):
            bdd = BDD(['A', 'B', 'C'])
            a, b, c = (bdd.variable(name) for name in bdd.variables)
            if factored:
                function = bdd.apply('and', a, bdd.apply('or', b, c))
            else:
                function = bdd.apply('or', bdd.apply('and', c, a), bdd.apply('and', b, a))
            covers.append(bdd.cover(function))
        self.assertEqual(covers[0], covers[1])

    def test_different_functions_have_different_covers(self):
        bdd = BDD(['A', 'B'])
        a, b = (bdd.variable(name) for name in bdd.variables)
        self.assertNotEqual(bdd.cover(bdd.apply('and', a, b)), bdd.cover(bdd.apply('or', a, b)))

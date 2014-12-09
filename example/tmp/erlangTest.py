
from erlang import extended_b_lines

def test_calcluations():
    cases = [(0.001, 8, 18), (0.5, 30, 21), (0.03, 2, 6)]
    for case in cases:
        assert extended_b_lines(case[1], case[0]) == case[2]
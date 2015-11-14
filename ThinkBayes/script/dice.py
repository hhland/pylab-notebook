
#from thinkbayes import Suite


class Dice(Suite):
    """Represents hypotheses about which die was rolled."""

    def Likelihood(self, data, hypo):
        """Computes the likelihood of the data under the hypothesis.
        hypo: integer number of sides on the die
        data: integer die roll
        """
        if hypo < data:
            return 0
        else:
            return 1.0/hypo


def main():
    suite = Dice([4, 6, 8, 12, 20])

    suite.Update(6)
    print 'After one 6'
    suite.Print()

    for roll in [4, 8, 7, 7, 2]:
        suite.Update(roll)

    print 'After more rolls'
    suite.Print()


if __name__ == '__main__':
    main()
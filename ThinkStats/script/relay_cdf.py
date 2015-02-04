import relay
import Cdf
import myplot


def main():
    results = relay.ReadResults()
    speeds = relay.GetSpeeds(results)

    # plot the distribution of actual speeds
    cdf = Cdf.MakeCdfFromList(speeds, 'speeds')

    myplot.Cdf(cdf)
    myplot.Show(root='relay_cdf',
                title='CDF of running speed',
                xlabel='speed (mph)',
                ylabel='probability')


if __name__ == '__main__':
    main()
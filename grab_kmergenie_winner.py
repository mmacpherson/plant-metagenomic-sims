import os
import sys

def main(args):
    infile = args[0]
    results = []
    with open(infile) as fp:
        for line in fp:
            k, kmers, cutoff = line.strip().split()
            if k == 'k':
                continue
            results.append(dict(k=int(k),
                                kmers=int(kmers),
                                cutoff=int(cutoff)))
    winner = list(sorted(results, key=lambda e: e['kmers']))[-1]
    print winner['k'], winner['cutoff']

if __name__ == "__main__":
    main(sys.argv[1:])

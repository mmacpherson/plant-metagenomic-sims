import os
import sys
import random

import skbio as skb

args = sys.argv[1:]

infile = args[0]
n      = int(args[1])

with open(infile) as fp:

    seqs = skb.SequenceCollection.from_fasta_records(
        skb.parse.sequences.parse_fasta(fp),
        skb.sequence.DNA,
        validate=True,
    )

def random_start(k):
    if k <= 0:
        return 0
    return random.choice(xrange(k))

print skb.SequenceCollection(
    [skb.sequence.DNA(s.sequence[st:st + n], s.id) for s in seqs
     for st in [random_start(len(s.sequence) - n)]]
    ).to_fasta()

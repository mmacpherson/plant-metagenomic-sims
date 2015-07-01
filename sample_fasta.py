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

print skb.SequenceCollection(random.sample(seqs, n)).to_fasta()

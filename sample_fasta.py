import os
import sys
import random
import subprocess
import json

import skbio as skb

args = sys.argv[1:]

infile = args[0]
n = int(args[1])

ln = None
if len(args) > 2:
    ln = int(args[2])

CACHE_FILE = ".lencache"

def load_json(infile):
    return json.load(open(infile))

def save_json(cache, outfile):
    json.dump(cache, open(outfile, 'w'))

def count_compressed_fasta_sequences(fname):
    return int(subprocess.check_output(['zgrep', '-c', '^>', fname]))

def random_start(k):
    if k <= 0:
        return 0
    return random.choice(xrange(k))

try:
    cache = load_json(CACHE_FILE)
except IOError:
    cache = {}

if infile in cache:
    num_sequences = cache[infile]
else:
    num_sequences = count_compressed_fasta_sequences(infile)
    cache[infile] = num_sequences
    save_json(cache, CACHE_FILE)

which_sequences = set(random.sample(xrange(num_sequences), n))

tag = infile.split('.')[0]
it = skb.parse.sequences.load(infile)
for i, rec in enumerate(it):
    if i in which_sequences:
        seq = rec['Sequence']
        if ln is not None:
            st = random_start(len(seq) - ln)
            seq = seq[st:st + ln]
        print skb.DNA(seq, id=tag).to_fasta(),


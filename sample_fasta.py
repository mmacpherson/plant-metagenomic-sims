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

CACHE_FILE = ".seqcache"

def load_json(infile):
    with open(infile) as fp:
        return json.load(fp)

def save_json(cache, outfile):
    with open(outfile, 'w') as fp:    
        json.dump(cache, fp)

def count_compressed_fasta_sequences(fname):
    return int(subprocess.check_output(['zgrep', '-c', '^>', fname]))

def get_average_fasta_read_length(fname, n=200):
    it = skb.parse.sequences.load(fname)
    acc = []
    for rec in it:
        acc.append(len(rec['Sequence']))
        if len(acc) >= n:
            break
    return sum(acc) / float(len(acc))

try:
    cache = load_json(CACHE_FILE)
except IOError:
    cache = {'num_sequences': {}, 'avg_read_length': {}}

tag = os.path.basename(infile)
if tag in cache['num_sequences'] and tag in cache['avg_read_length']:
    print >> sys.stderr, 'Loading from cache [%s]' % tag
    num_sequences = cache['num_sequences'][tag]
    read_length = cache['avg_read_length'][tag]
else:
    print >> sys.stderr, 'Analyzing [%s]' % tag
    num_sequences = count_compressed_fasta_sequences(infile)
    read_length = get_average_fasta_read_length(infile)
    cache['num_sequences'][tag] = num_sequences
    cache['avg_read_length'][tag] = read_length
    print >> sys.stderr, 'Caching [%s] analysis' % tag
    save_json(cache, CACHE_FILE)

if n <= 0:
    sys.exit(0)

if ln is None or (ln < read_length):
    which_sequences = set(random.sample(xrange(num_sequences), n))
else:
    total_sequence_bp = ln * n
    expected_num_reads_needed = total_sequence_bp / read_length
    draw = int(expected_num_reads_needed * 1.01) # 1% cushion
    which_sequences = set(random.sample(xrange(num_sequences), draw))

def random_substring(st, k):
    'Return random substring of length k from st.'
    if k <= 0:
        return ''
    if k >= len(st):
        return st
    start = random.choice(xrange(len(st) - k))
    return st[start:start + k]

def total_length(sequences):
    return sum(len(s) for s in sequences) + (len(sequences) - 1) # the 'N's

def take(seqs, n):
    return random_substring('N'.join(seqs), n)

tag = os.path.basename(infile).split('.')[0]
it = skb.parse.sequences.load(infile)
acc = []
n_seqs_produced = 0
for i, rec in enumerate(it):
    if n_seqs_produced >= n:
        break
    if i in which_sequences:
        acc.append(rec['Sequence'])
        if total_length(acc) >= ln:
            out = take(acc, ln)
            print skb.DNA(out, id=tag).to_fasta(),
            acc = []
            n_seqs_produced += 1

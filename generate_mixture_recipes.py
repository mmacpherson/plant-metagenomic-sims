import sys
import math

TAB = '\t'

from attrdict import AttrDict
SPECIES = AttrDict(dict(
    PTRE='p_tremuloides',
    PDEL='p_deltoides',
    BPAP='b_papyrifera',
    BSCO='b_scoparia',
    ATRI='a_tridentata',
    AART='a_artemisiifolia',
    PPRA='p_pratensis',
    ZMAY='z_mays',
))
SP=SPECIES

GENOME_SIZE = AttrDict({ # all in Mbp
    SP.PTRE: 500,
    SP.PDEL: 500,
    SP.BPAP: 500, # a guess!
    SP.BSCO: 500, # a guess!
    SP.ATRI: 4000,
    SP.AART: 570,
    SP.PPRA: 2600,
    SP.ZMAY: 2500
})

SRA = AttrDict({
    SP.PTRE: 'SRR540223',
    SP.PDEL: 'SRR1121654',
    SP.BPAP: 'SRR1477753',
    SP.BSCO: 'SRR1198330',
    SP.ATRI: 'SRR058121',
    SP.AART: 'ERR231632',
    SP.PPRA: 'SRR769554',
    #SP.ZMAY: ''
})

mixtures = [

    # ((SP.BPAP, 1), (SP.ATRI, 1), (SP.ZMAY, 1)),

    # ((SP.BPAP, 1), (SP.ATRI, 1), (SP.ZMAY, 1), (SP.BSCO, 1), (SP.PPRA, 1)),

    ((SP.PTRE, 1), (SP.PDEL, 1)),

    # ((SP.PPRA, 1), (SP.ZMAY, 1)),

    ((SP.BPAP, 1), (SP.ATRI, 1)),

    ((SP.BPAP, 1), (SP.PPRA, 1)),

    ((SP.BPAP, 1), (SP.PPRA, 9)),

    ((SP.BPAP, 1), (SP.PPRA, 19)),

    ((SP.BPAP, 1), (SP.PPRA, 99)),
]

def sra2seq(sra):
    return '%s.fasta.gz' % sra

def normalize(v):
    s = float(sum(v))
    return [e / s for e in v]

def generate_mixture_targets(mixture, seq_mbp, read_len, idn):
    species, proportions = zip(*mixture)
    gsizes = [float(GENOME_SIZE[sp]) for sp in species]
    weighted_props = normalize([p * g for (p, g) in zip(proportions, gsizes)])
    sras = [SRA[sp] for sp in species]
    out = []
    targets = []
    for (i, (s, w, f)) in enumerate(zip(species, weighted_props, sras)):
        target = 'mix-%s.%d.fa' % (idn, i)
        target_bp = seq_mbp * w * 1e6
        num_reads = int(math.ceil(target_bp / float(read_len)))
        cmd = "python $(HOME)/src/plant-metagenomic-sims/sample_fasta.py %s %s %s > %s" % (sra2seq(f), num_reads, read_len, target)
        out += ['%s:' % target]
        out += ['%s%s' % (TAB, cmd)]
        out += ['']
        targets += [target]

    target = 'mix-%s.fa' % idn
    targets = ' '.join(targets)
    out += ['%s: %s' % (target, targets)]
    out += ['%scat %s > %s' % (TAB, targets, target)]
    out += ['']

    return target, '\n'.join(out)


SEQUENCE_MBP = 1 # how many Mbp will be sequenced
READ_LENGTH  = 500 # platform read length, in bp

targets = []
for i, mix in enumerate(mixtures):
    target, make = generate_mixture_targets(mix, SEQUENCE_MBP, READ_LENGTH, i + 1)
    print make
    targets += [target]

print 'all: %s' % ' '.join(targets)

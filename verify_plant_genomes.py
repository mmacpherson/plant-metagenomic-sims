import os
import sys

MD5FILE = 'md5checksums.txt'

def pse(*args):
    print >> sys.stderr, ' '.join(e for e in args)

def parse_md5file(content):
    
    out = {}
    for line in content:
        md5, path = map(os.path.basename, line.strip().split())
        out[path] = md5

    return out

def main(args):

    root = os.getcwd()

    for path in os.listdir(root):
        os.chdir(root)

        if not os.path.isdir(path):
            continue

        # pse('Checking [%s]' % path)
        os.chdir(path)
        # -- I expect there to be a file named
        #    MD5FILE.
        if not MD5FILE:
            pse('No md5 file in [%s]' % path)
            continue

        with open(MD5FILE) as fp:
            md5file_map = parse_md5file(fp)

        if not md5file_map:
            pse('Empty md5 file in [%s]' % path)
            continue

        computed_md5_map = parse_md5file(os.popen('md5sum *'))

        genome_files = [fn for fn in computed_md5_map if fn.endswith('.fna.gz')]
        if not genome_files:
            pse('No genome data file present in [%s]' % path)
            continue

        for fn, md5 in computed_md5_map.items():
            if fn in md5file_map and md5file_map[fn] != md5:
                pse('Mismatched md5sum in [%s/%s]' % (path, fn))
            

if __name__ == '__main__':
    main(sys.argv[1:])

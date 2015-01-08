import os
import sys
#from ftplib import FTP
import ftputil

NCBI_SERVER = 'ftp.ncbi.nlm.nih.gov'
PLANTS_DIR = 'genomes/genbank/plant'

REP_DIR = 'representative'
REF_DIR = 'reference'
LATEST_DIR = 'latest_assembly_versions'

def ftp_file_size(host, fn):
    try:
        return host.stat(fn)[-4]
    except ftputil.error.PermanentError:
        try:
            return host.lstat(fn)[-4]
        except ftputil.error.PermanentError:
            return None

def first_matching(items, ordered_matches):
    for match in ordered_matches:
        if match in items:
            return match
    return None

def main(args):
    with ftputil.FTPHost(NCBI_SERVER, 'anonymous', 'a@b.c') as host:
        host.chdir(PLANTS_DIR)
        plants_dir = host.getcwd()
        plant_genome_dirs = host.listdir(host.curdir)
        download_size = 0
        for pgd in plant_genome_dirs:
            host.chdir(os.path.join(plants_dir, pgd))
            entries = host.listdir(host.curdir)
            dirname = first_matching(entries,
                                   (REP_DIR, REF_DIR, LATEST_DIR))
            if dirname is None:
                print >> sys.stderr, \
                    "No data folder found for [%s]." % pgd
                continue

            host.chdir(dirname)
            assembly = host.listdir(host.curdir)
            if len(assembly) == 0:
                print >> sys.stderr, \
                    "No data found within folder for [%s]." % pgd
                continue
            elif len(assembly) > 1:
                print >> sys.stderr, \
                    "Multiple assemblies found for [%s]." % pgd
            host.chdir(assembly[0])
            assembly_files = host.listdir(host.curdir)
            wanted_assembly_files = [e for e in assembly_files
                                     if e.endswith('_assembly_report.txt') or
                                     e.endswith('.fna.gz') or
                                     e == 'md5checksums.txt'
            ]

            if not os.path.exists(pgd):
                os.mkdir(pgd)
            os.chdir(pgd)
            for waf in wanted_assembly_files:
                dl_size = ftp_file_size(host, waf)
                download_size += dl_size
                print pgd, waf
                if dl_size < 52428800:
                    print >> sys.stderr, "Downloading [%s]" % waf
                    host.download(waf, waf)
            os.chdir('..')
        print "Total download size (GB) %0.2f" % (download_size / float(2 ** 30))


if __name__ == '__main__':
    main(sys.argv[1:])

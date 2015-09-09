import os
import sys
#from ftplib import FTP
import ftputil

NCBI_SERVER = 'ftp.ncbi.nlm.nih.gov'
PLANTS_DIR = 'genomes/genbank/plant'

REP_DIR = 'representative'
REF_DIR = 'reference'
LATEST_DIR = 'latest_assembly_versions'

def matchup(items, ordered_matches):
    return [match for match in ordered_matches if match in items]

def main(args):
    with ftputil.FTPHost(NCBI_SERVER, 'anonymous', 'a@b.c') as host:
        host.chdir(PLANTS_DIR)
        plants_dir = host.getcwd()
        plant_genome_dirs = host.listdir(host.curdir)
        download_size = 0
        for pgd in plant_genome_dirs:
            pgd_home = os.path.join(plants_dir, pgd)
            if not host.path.isdir(pgd_home):
                continue
            host.chdir(pgd_home)
            entries = host.listdir(host.curdir)
            dirnames = matchup(entries, (REP_DIR, REF_DIR, LATEST_DIR))
            if not dirnames:
                print >> sys.stderr, \
                    "No data folder found for [%s]." % pgd
                continue

            for dirname in dirnames:
                host.chdir(dirname)
                assembly = host.listdir(host.curdir)
                if len(assembly) == 0:
                    print >> sys.stderr, \
                        "No data found within folder for [%s]." % pgd
                    # -- Go back to plant's main dir and try next available.
                    host.chdir(pgd_home)
                    continue
                elif len(assembly) > 1:
                    print >> sys.stderr, \
                        "Multiple assemblies found for [%s]." % pgd

                # -- This means pick the first-listed
                #    assembly when several are present.
                host.chdir(assembly[0])
                assembly_files = host.listdir(host.curdir)

                wanted_assembly_files = [e for e in assembly_files
                                         if e.endswith('_assembly_report.txt') or
                                         e.endswith('.fna.gz') or
                                         e == 'md5checksums.txt'
                ]

                if not os.path.exists(pgd):
                    os.mkdir(pgd)

                for waf in wanted_assembly_files:
                    print "mkdir -p %s && wget --no-clobber -O %s/%s ftp://%s/%s/%s/%s/%s/%s" % (pgd, pgd, waf, NCBI_SERVER, PLANTS_DIR, pgd, dirname, assembly[0], waf)

                # -- Stop trying to dl a genome after the first one
                #    that works.
                break


if __name__ == '__main__':
    main(sys.argv[1:])

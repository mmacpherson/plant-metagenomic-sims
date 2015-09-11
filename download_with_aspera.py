import os
import sys

# -- Script to download SRA files from NCBI's trace archive directly,
#    because I couldn't get prefetch to work correctly with
#    aspera/ascp.

# -- The thing I had to work out manually was the '-l 23000', which is
#    something like the max download speed. Too high, it crashes.

# -- df. http://www.ncbi.nlm.nih.gov/books/NBK158899/#SRA_download.determining_the_location_of
# -- cf. http://download.asperasoft.com/download/docs/ascp/2.7/html/

LOCAL_DL_DIR='$HOME/ncbi/public/sra/'
CL='\
$HOME/.aspera/connect/bin/ascp -T -l 23000 -k2 \
-i $HOME/.aspera/connect/etc/asperaweb_id_dsa.openssh \
--user anonftp --host ftp.ncbi.nlm.nih.gov --mode recv \
%(sra_url)s %(dl_dir)s'

def resolve_tag(tag):
    sra_t='/sra/sra-instant/reads/ByRun/sra/%(dir1)s/%(dir2)s/%(tag)s/%(tag)s.sra'
    return sra_t % dict(dir1=tag[:3], dir2=tag[:6], tag=tag)

def main(args):

    ctx = dict(dl_dir=LOCAL_DL_DIR)

    for tag in args:
        tag = tag.strip()
        ctx.update(sra_url=resolve_tag(tag))
        cl = CL % ctx
        print >> sys.stderr, cl
        os.system(cl)

if __name__ == '__main__':
    main(sys.argv[1:])



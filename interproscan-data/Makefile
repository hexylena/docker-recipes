all: interproscan panther


interproscan: interproscan-5.6-48.0-64-bit.tar.gz interproscan-5.6-48.0-64-bit.tar.gz.md5
	md5sum -c interproscan-5.6-48.0-64-bit.tar.gz.md5

interproscan-5.6-48.0-64-bit.tar.gz.md5:
	wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.6-48.0/interproscan-5.6-48.0-64-bit.tar.gz.md5

interproscan-5.6-48.0-64-bit.tar.gz:
	wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.6-48.0/interproscan-5.6-48.0-64-bit.tar.gz


panther: panther-data-9.0.tar.gz panther-data-9.0.tar.gz.md5
	md5sum -c panther-data-9.0.tar.gz.md5

panther-data-9.0.tar.gz:
	wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-9.0.tar.gz

panther-data-9.0.tar.gz.md5:
	wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-9.0.tar.gz.md5

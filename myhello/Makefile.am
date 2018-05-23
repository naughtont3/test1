SUBDIRS = src
EXTRA_DIST = doc

# NOTE: By default the 'EXTRA_DIST' will include the entire 'doc' directory,
#       to include SVN/CVS files, etc.  This hook is fired after the dist
#       directory is created, but before the tar/gz occurs
dist-hook:
	rm -rf `find $(distdir)/doc -name .svn`



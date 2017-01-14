# Assuming perl and App::cpanminus and expect are installed...
depend:
	@cpanm --installdeps .
	@expect -c "package require Tcl 8.5;"

test:
	@prove

clean:
	@-rm -f .zcompdump >/dev/null 2>&1

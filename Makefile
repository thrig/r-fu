# Assuming perl and App::cpanminus and expect are installed...
depend:
	@cpanm --installdeps .
	@expect -c "puts {have expect}"

test:
	@prove

clean:
	@-rm -f .zcompdump >/dev/null 2>&1

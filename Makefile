test:
	@perl -MApp::Prove -MTest::Cmd -MTest::Most -le 'print "have perl reqs"'
	@expect -c "puts {have expect}"
	@prove

clean:
	@-rm -f .zcompdump >/dev/null 2>&1

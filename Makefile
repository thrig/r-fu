test:
	@perl -MApp::Prove -MTest::Cmd -MTest::Most -le 'print "reqs installed"'
	@prove

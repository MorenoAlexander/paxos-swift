import XCTest

import paxosTests

var tests = [XCTestCaseEntry]()
tests += paxosTests.allTests()
XCTMain(tests)

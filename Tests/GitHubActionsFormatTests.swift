import XCTest
@testable import xcsift

/// Tests for GitHub Actions format output
final class GitHubActionsFormatTests: XCTestCase {

    func testGitHubActionsFormatWithColumn() throws {
        let parser = OutputParser()
        let input = """
        main.swift:15:5: error: use of undeclared identifier 'unknown'
        """
        let result = parser.parse(input: input)

        let output = result.formatGitHubActions()

        XCTAssertTrue(output.contains("::error file=main.swift,line=15,col=5::use of undeclared identifier 'unknown'"))
        XCTAssertTrue(output.contains("::notice ::"))
    }

    func testGitHubActionsFormatWarningWithColumn() throws {
        let parser = OutputParser()
        let input = """
        Parser.swift:20:10: warning: immutable value 'result' was never used
        """
        let result = parser.parse(input: input, printWarnings: true)

        let output = result.formatGitHubActions()

        XCTAssertTrue(output.contains("::warning file=Parser.swift,line=20,col=10::immutable value 'result' was never used"))
    }

    func testGitHubActionsFormatTestWithTitle() throws {
        let parser = OutputParser()
        let input = """
        /path/to/TestFile.swift:42:9: error: testUserLogin(): XCTAssertEqual failed: ("expected") is not equal to ("actual")
        Test Case '-[MyTests testUserLogin]' failed (0.123 seconds).
        """
        let result = parser.parse(input: input)

        let output = result.formatGitHubActions()

        // Test should have title parameter
        XCTAssertTrue(output.contains("title="))
    }

    func testGitHubActionsFormatWithoutColumn() throws {
        let parser = OutputParser()
        let input = """
        main.swift:15: error: some error without column
        """
        let result = parser.parse(input: input)

        let output = result.formatGitHubActions()

        // Should not have col= when column is not present
        XCTAssertTrue(output.contains("::error file=main.swift,line=15::some error without column"))
        XCTAssertFalse(output.contains("col="))
    }

    func testGitHubActionsFormatSummary() throws {
        let parser = OutputParser()
        let input = """
        main.swift:15:5: error: error 1
        main.swift:20:10: error: error 2
        Parser.swift:30:15: warning: warning 1
        Build failed
        """
        let result = parser.parse(input: input, printWarnings: true)

        let output = result.formatGitHubActions()

        XCTAssertTrue(output.contains("::notice ::Build failed"))
        XCTAssertTrue(output.contains("2 errors"))
        XCTAssertTrue(output.contains("1 warning"))
    }
}

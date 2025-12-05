import XCTest
@testable import xcsift

/// Tests for basic parsing functionality: errors, warnings, tests, and build output
final class ParsingTests: XCTestCase {

    func testParseError() {
        let parser = OutputParser()
        let input = """
            main.swift:15:5: error: use of undeclared identifier 'unknown'
            unknown = 5
            ^
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "failed")
        XCTAssertEqual(result.summary.errors, 1)
        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.errors[0].file, "main.swift")
        XCTAssertEqual(result.errors[0].line, 15)
        XCTAssertEqual(result.errors[0].message, "use of undeclared identifier 'unknown'")
    }

    func testParseSuccessfulBuild() {
        let parser = OutputParser()
        let input = """
            Building for debugging...
            Build complete!
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "success")
        XCTAssertEqual(result.summary.errors, 0)
        XCTAssertEqual(result.summary.failedTests, 0)
        XCTAssertNil(result.summary.passedTests)
    }

    func testFailingTest() {
        let parser = OutputParser()
        let input = """
            Test Case 'LoginTests.testInvalidCredentials' failed (0.045 seconds).
            XCTAssertEqual failed: Expected valid login
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "failed")
        XCTAssertEqual(result.summary.failedTests, 2)
        XCTAssertEqual(result.failedTests.count, 2)
        XCTAssertNil(result.summary.passedTests)
        XCTAssertEqual(result.failedTests[0].test, "LoginTests.testInvalidCredentials")
        XCTAssertEqual(result.failedTests[1].test, "Test assertion")
    }

    func testMultipleErrors() {
        let parser = OutputParser()
        let input = """
            UserService.swift:45:12: error: cannot find 'invalidFunction' in scope
            NetworkManager.swift:23:5: error: use of undeclared identifier 'unknownVariable'
            AppDelegate.swift:67:8: warning: unused variable 'config'
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "failed")
        XCTAssertEqual(result.summary.errors, 2)
        XCTAssertEqual(result.errors.count, 2)
        XCTAssertNil(result.summary.passedTests)
    }

    func testInvalidAssertion() {
        let line = "XCTAssertTrue failed - Connection should be established"
        let parser = OutputParser()
        let result = parser.parse(input: line)

        XCTAssertEqual(result.status, "failed")
        XCTAssertEqual(result.summary.failedTests, 1)
        XCTAssertNil(result.summary.passedTests)
        XCTAssertEqual(result.failedTests.count, 1)
        XCTAssertEqual(result.failedTests[0].test, "Test assertion")
        XCTAssertEqual(result.failedTests[0].message, line.trimmingCharacters(in: .whitespaces))
    }

    func testWrongFileReference() {
        let parser = OutputParser()
        let input = """
            NonexistentFile.swift:999:1: error: file not found
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "failed")
        XCTAssertEqual(result.summary.errors, 1)
        XCTAssertNil(result.summary.passedTests)
        XCTAssertEqual(result.errors[0].file, "NonexistentFile.swift")
        XCTAssertEqual(result.errors[0].line, 999)
        XCTAssertEqual(result.errors[0].message, "file not found")
    }

    func testBuildTimeExtraction() {
        let parser = OutputParser()
        let input = """
            Building for debugging...
            Build failed after 5.7 seconds
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.summary.buildTime, "5.7 seconds")
        XCTAssertNil(result.summary.passedTests)
    }

    func testParseCompileError() {
        let parser = OutputParser()
        let input = """
            UserManager.swift:42:10: error: cannot find 'undefinedVariable' in scope
            print(undefinedVariable)
            ^
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "failed")
        XCTAssertEqual(result.summary.errors, 1)
        XCTAssertNil(result.summary.passedTests)
        XCTAssertEqual(result.errors[0].file, "UserManager.swift")
        XCTAssertEqual(result.errors[0].line, 42)
        XCTAssertEqual(result.errors[0].message, "cannot find 'undefinedVariable' in scope")
    }

    func testPassedTestCountFromExecutedSummary() {
        let parser = OutputParser()
        let input = """
            Test Case 'SampleTests.testExample' passed (0.001 seconds).
            Executed 5 tests, with 0 failures (0 unexpected) in 5.017 (5.020) seconds
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.summary.passedTests, 5)
        XCTAssertEqual(result.summary.failedTests, 0)
        XCTAssertEqual(result.summary.buildTime, "5.017")
    }

    func testPassedTestCountFromPassLineOnly() {
        let parser = OutputParser()
        let input = """
            Test Case 'SampleTests.testExample' passed (0.001 seconds).
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.summary.passedTests, 1)
        XCTAssertEqual(result.summary.failedTests, 0)
    }

    func testSwiftCompilerVisualErrorLinesAreFiltered() {
        let parser = OutputParser()
        // Swift compiler outputs each error twice:
        // 1. Main error line with file:line:column
        // 2. Visual caret line with pipe and backtick
        // We should only capture the first one
        let input = """
            /Users/test/project/Tests/TestFile.swift:16:34: error: missing argument for parameter 'fragments' in call
             14 |             kind: "class",
             15 |             language: "swift",
             16 |             structuredContent: []
                |                                  `- error: missing argument for parameter 'fragments' in call
             17 |         )
             18 |
            """

        let result = parser.parse(input: input)

        // Should only have 1 error (not 2), and it should have file/line info
        XCTAssertEqual(result.status, "failed")
        XCTAssertEqual(result.summary.errors, 1)
        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.errors[0].file, "/Users/test/project/Tests/TestFile.swift")
        XCTAssertEqual(result.errors[0].line, 16)
        XCTAssertEqual(result.errors[0].message, "missing argument for parameter 'fragments' in call")
    }

    func testLargeRealWorldBuildOutput() throws {
        let parser = OutputParser()

        let fixtureURL = Bundle.module.url(forResource: "build", withExtension: "txt")!
        let input = try String(contentsOf: fixtureURL, encoding: .utf8)

        // This is a large successful build output (2.6MB, 8000+ lines)
        // Test that it parses without hanging and completes in reasonable time
        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "success")
        XCTAssertEqual(result.summary.errors, 0)
        XCTAssertEqual(result.summary.failedTests, 0)
    }

    func testParseWarning() {
        let parser = OutputParser()
        let input = """
            AppDelegate.swift:67:8: warning: unused variable 'config'
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "success")
        XCTAssertEqual(result.summary.warnings, 1)
        XCTAssertEqual(result.warnings.count, 1)
        XCTAssertEqual(result.warnings[0].file, "AppDelegate.swift")
        XCTAssertEqual(result.warnings[0].line, 67)
        XCTAssertEqual(result.warnings[0].message, "unused variable 'config'")
    }

    func testParseMultipleWarnings() {
        let parser = OutputParser()
        let input = """
            UserService.swift:45:12: warning: variable 'temp' was never used
            NetworkManager.swift:23:5: warning: initialization of immutable value 'data' was never used
            AppDelegate.swift:67:8: warning: unused variable 'config'
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "success")
        XCTAssertEqual(result.summary.warnings, 3)
        XCTAssertEqual(result.warnings.count, 3)
    }

    func testParseErrorsAndWarnings() {
        let parser = OutputParser()
        let input = """
            UserService.swift:45:12: error: cannot find 'invalidFunction' in scope
            NetworkManager.swift:23:5: warning: variable 'temp' was never used
            AppDelegate.swift:67:8: warning: unused variable 'config'
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "failed")
        XCTAssertEqual(result.summary.errors, 1)
        XCTAssertEqual(result.summary.warnings, 2)
        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.warnings.count, 2)
    }

    func testPrintWarningsFlagFalse() {
        let parser = OutputParser()
        let input = """
            AppDelegate.swift:67:8: warning: unused variable 'config'
            """

        let result = parser.parse(input: input, printWarnings: false)

        XCTAssertEqual(result.summary.warnings, 1)
        XCTAssertEqual(result.warnings.count, 1)
        XCTAssertEqual(result.printWarnings, false)

        // Encode to JSON and verify warnings are not included
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(result)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        XCTAssertFalse(jsonString.contains("\"warnings\":["))
        XCTAssertTrue(jsonString.contains("\"warnings\":1"))  // Summary should still show count
    }

    func testPrintWarningsFlagTrue() {
        let parser = OutputParser()
        let input = """
            AppDelegate.swift:67:8: warning: unused variable 'config'
            """

        let result = parser.parse(input: input, printWarnings: true)

        XCTAssertEqual(result.summary.warnings, 1)
        XCTAssertEqual(result.warnings.count, 1)
        XCTAssertEqual(result.printWarnings, true)

        // Encode to JSON and verify warnings are included
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(result)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        XCTAssertTrue(jsonString.contains("\"warnings\":["))
        XCTAssertTrue(jsonString.contains("unused variable"))
    }

    func testSwiftTestingSummaryPassed() {
        let parser = OutputParser()
        let input = """
            ✓ Test "LocaleUrlTag handles deep paths correctly in default locale" passed after 0.022 seconds.
            ✓ Test "LocaleUrlTag generates correct URLs in non-default locale (en)" passed after 0.022 seconds.
            ✓ Test "LocaleUrlTag handles deep paths correctly in non-default locale" passed after 0.023 seconds.
            Test run with 23 tests in 5 suites passed after 0.031 seconds.
            """

        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "success")
        XCTAssertEqual(result.summary.passedTests, 23)
        XCTAssertEqual(result.summary.failedTests, 0)
        XCTAssertEqual(result.summary.buildTime, "0.031")
    }

    func testRealWorldSwiftTestingOutput() throws {
        let parser = OutputParser()

        let fixtureURL = Bundle.module.url(forResource: "swift-testing-output", withExtension: "txt")!
        let input = try String(contentsOf: fixtureURL, encoding: .utf8)

        // This is real Swift Testing output with 23 passed tests
        let result = parser.parse(input: input)

        XCTAssertEqual(result.status, "success")
        XCTAssertEqual(result.summary.errors, 0)
        XCTAssertEqual(result.summary.failedTests, 0)
        XCTAssertEqual(result.summary.passedTests, 23)
        XCTAssertEqual(result.summary.buildTime, "0.031")
    }

    func testJSONLikeLinesAreFiltered() {
        let parser = OutputParser()
        // This simulates the actual problematic case: Swift compiler warning/note lines
        // with string interpolation patterns that were incorrectly parsed as errors
        let input = """
            /Path/To/File.swift:79:41: warning: string interpolation produces a debug description for an optional value; did you mean to make this explicit?

                return "Encryption error: \\(message)"

                                            ^~~~~~~

            /Path/To/File.swift:79:41: note: use 'String(describing:)' to silence this warning

                return "Encryption error: \\(message)"

                                            ^~~~~~~

                                            String(describing:  )

            /Path/To/File.swift:79:41: note: provide a default value to avoid this warning

                return "Encryption error: \\(message)"

                                            ^~~~~~~

                                                    ?? <#default value#>
            """

        let result = parser.parse(input: input)

        // Should parse the warning correctly, but NOT parse the note lines as errors
        // The note lines contain \\(message) pattern which shouldn't be treated as error messages
        XCTAssertEqual(result.status, "success")  // No actual errors, just warnings
        XCTAssertEqual(result.summary.errors, 0)
        XCTAssertEqual(result.summary.warnings, 1)  // Should parse the warning
        XCTAssertEqual(result.errors.count, 0)
    }

    func testJSONLikeLinesWithActualErrors() {
        let parser = OutputParser()
        // Mix of compiler note lines (with interpolation patterns) and actual errors
        // Should only parse the real errors, not the note lines
        let input = """
            /Path/To/File.swift:79:41: note: use 'String(describing:)' to silence this warning
                return "Encryption error: \\(message)"
                                            ^~~~~~~
            main.swift:15:5: error: use of undeclared identifier 'unknown'
            """

        let result = parser.parse(input: input)

        // Should parse the real error but ignore note lines with interpolation patterns
        XCTAssertEqual(result.status, "failed")
        XCTAssertEqual(result.summary.errors, 1)
        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.errors[0].file, "main.swift")
        XCTAssertEqual(result.errors[0].line, 15)
        XCTAssertEqual(result.errors[0].message, "use of undeclared identifier 'unknown'")
    }

    // MARK: - Fix-it Tests

    func testErrorWithFixHints() {
        let parser = OutputParser()
        let input = """
            main.swift:15:5: error: use of undeclared identifier 'foo'
            main.swift:15:5: note: did you mean 'for'?
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.errors[0].file, "main.swift")
        XCTAssertEqual(result.errors[0].line, 15)
        XCTAssertEqual(result.errors[0].message, "use of undeclared identifier 'foo'")
        XCTAssertEqual(result.errors[0].notes, ["did you mean 'for'?"])
    }

    func testWarningWithFixHints() {
        let parser = OutputParser()
        let input = """
            Parser.swift:20:10: warning: variable 'result' was never mutated
            Parser.swift:20:10: note: change 'var' to 'let' to make it constant
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.warnings.count, 1)
        XCTAssertEqual(result.warnings[0].file, "Parser.swift")
        XCTAssertEqual(result.warnings[0].line, 20)
        XCTAssertEqual(result.warnings[0].message, "variable 'result' was never mutated")
        XCTAssertEqual(result.warnings[0].notes, ["change 'var' to 'let' to make it constant"])
    }

    func testErrorWithoutFixHints() {
        let parser = OutputParser()
        let input = "main.swift:10:1: error: cannot find 'xyz' in scope"
        let result = parser.parse(input: input)

        XCTAssertEqual(result.errors.count, 1)
        XCTAssertNil(result.errors[0].notes)
    }

    func testWarningWithoutFixHints() {
        let parser = OutputParser()
        let input = "Model.swift:30:5: warning: unused variable 'temp'"
        let result = parser.parse(input: input)

        XCTAssertEqual(result.warnings.count, 1)
        XCTAssertNil(result.warnings[0].notes)
    }

    func testMultipleNotesAllCaptured() {
        let parser = OutputParser()
        // When multiple notes exist, all real fix-its are captured
        let input = """
            main.swift:15:5: error: ambiguous use of 'foo'
            main.swift:10:10: note: did you mean 'foo(_:)'?
            main.swift:20:10: note: or did you mean 'foo(bar:)'?
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.errors[0].notes, ["did you mean 'foo(_:)'?", "or did you mean 'foo(bar:)'?"])
    }

    func testAmbiguousUseWithCandidatesNotCaptured() {
        let parser = OutputParser()
        // "found this candidate" is a reference note, not a fix-it
        let input = """
            main.swift:15:5: error: ambiguous use of 'foo'
            main.swift:10:10: note: found this candidate
            main.swift:20:10: note: found this candidate
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.errors.count, 1)
        XCTAssertNil(result.errors[0].notes)  // Reference notes are filtered
    }

    func testFixHintsWithVisualMarkers() {
        let parser = OutputParser()
        // Real compiler output with visual markers (~~~, ^~~, let)
        let input = """
            /Users/dev/Project/Sources/Parser.swift:20:10: warning: variable 'result' was never mutated
                var result = compute()
                ~~~^~~
            /Users/dev/Project/Sources/Parser.swift:20:10: note: change 'var' to 'let' to make it constant
                var result = compute()
                ^~~
                let
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.warnings.count, 1)
        XCTAssertEqual(result.warnings[0].notes, ["change 'var' to 'let' to make it constant"])
    }

    func testMixedErrorsAndWarningsWithFixHints() {
        let parser = OutputParser()
        let input = """
            Parser.swift:20:10: warning: variable 'result' was never mutated
            Parser.swift:20:10: note: change 'var' to 'let' to make it constant
            main.swift:15:5: error: use of undeclared identifier 'foo'
            main.swift:15:5: note: did you mean 'for'?
            Model.swift:30:20: warning: result of call to 'save()' is unused
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.warnings.count, 2)

        XCTAssertEqual(result.errors[0].notes, ["did you mean 'for'?"])
        XCTAssertEqual(result.warnings[0].notes, ["change 'var' to 'let' to make it constant"])
        XCTAssertNil(result.warnings[1].notes)  // No note for this warning
    }

    func testFixHintsFromFixture() throws {
        let url = Bundle.module.url(forResource: "fixit-output", withExtension: "txt")!
        let input = try String(contentsOf: url, encoding: .utf8)

        let parser = OutputParser()
        let result = parser.parse(input: input)

        // 2 errors, 2 warnings from fixture
        XCTAssertEqual(result.errors.count, 2)
        XCTAssertEqual(result.warnings.count, 2)

        // First warning has fix hints
        XCTAssertEqual(
            result.warnings[0].message,
            "variable 'result' was never mutated; consider changing to 'let' constant"
        )
        XCTAssertEqual(result.warnings[0].notes, ["change 'var' to 'let' to make it constant"])

        // First error has fix hints
        XCTAssertEqual(result.errors[0].message, "use of undeclared identifier 'foo'")
        XCTAssertEqual(result.errors[0].notes, ["did you mean 'for'?"])

        // Second warning has fix hints
        XCTAssertEqual(result.warnings[1].message, "result of call to 'save()' is unused")
        XCTAssertEqual(result.warnings[1].notes, ["consider using '_ = ' to silence this warning"])

        // Second error has no fix hints
        XCTAssertEqual(result.errors[1].message, "cannot find 'xyz' in scope")
        XCTAssertNil(result.errors[1].notes)
    }

    // MARK: - Reference Note Filtering Tests

    func testReferenceNotesDeclaredHereNotCaptured() {
        let parser = OutputParser()
        // Real-world example: Swift 6 actor isolation warning
        let input = """
            DeviceProvider.swift:101:16: warning: main actor-isolated property 'osVersion' can not be referenced from a nonisolated context
            UIDevice.swift:50:20: note: property declared here
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.warnings.count, 1)
        XCTAssertNil(result.warnings[0].notes)  // "declared here" is not a fix-it
    }

    func testReferenceNotesClassPropertyDeclaredHereNotCaptured() {
        let parser = OutputParser()
        let input = """
            DeviceProvider.swift:101:16: warning: main actor-isolated class property 'current' can not be referenced
            UIDevice.swift:25:10: note: class property declared here
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.warnings.count, 1)
        XCTAssertNil(result.warnings[0].notes)  // "class property declared here" is not a fix-it
    }

    func testSystemNoteDetectedEncodingNotCaptured() {
        let parser = OutputParser()
        let input = """
            Bundle+Custom.swift:82:5: warning: 'nonisolated(unsafe)' has no effect on property 'appVersion'
            Bundle+Custom.swift:82:5: note: detected encoding of input file as Unicode (UTF-8) (in target 'CommonKit' from project 'inDriver')
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.warnings.count, 1)
        XCTAssertNil(result.warnings[0].notes)  // System note is not a fix-it
    }

    func testRealFixHintsStillCapturedAfterFiltering() {
        let parser = OutputParser()
        // Mix of reference note (should be skipped) and real fix-it (should be captured)
        let input = """
            main.swift:10:5: error: use of undeclared identifier 'foo'
            main.swift:10:5: note: did you mean 'for'?
            other.swift:20:10: warning: variable 'x' was never used
            other.swift:5:10: note: 'x' declared here
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.errors.count, 1)
        XCTAssertEqual(result.warnings.count, 1)

        // Real fix-it should be captured
        XCTAssertEqual(result.errors[0].notes, ["did you mean 'for'?"])
        // Reference note should not be captured
        XCTAssertNil(result.warnings[0].notes)
    }

    func testMultipleReferenceNotesAllFiltered() {
        let parser = OutputParser()
        let input = """
            File.swift:10:5: error: protocol 'MyProtocol' requires function 'doSomething()'
            Protocol.swift:5:10: note: protocol requires function 'doSomething()' with type '() -> Void'
            Protocol.swift:3:10: note: requirement specified as 'doSomething' in protocol 'MyProtocol'
            """
        let result = parser.parse(input: input)

        XCTAssertEqual(result.errors.count, 1)
        XCTAssertNil(result.errors[0].notes)  // Both notes are reference notes
    }
}

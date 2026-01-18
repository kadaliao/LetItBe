import Foundation
import SQLite3

final class SQLiteStore {
    private var db: OpaquePointer?

    init(databaseName: String) throws {
        let url = try Self.databaseURL(for: databaseName)
        if sqlite3_open(url.path, &db) != SQLITE_OK {
            throw SQLiteStoreError.openFailed
        }
    }

    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }

    func execute(_ sql: String) throws {
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            throw SQLiteStoreError.executionFailed
        }
    }

    func prepare(_ sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            throw SQLiteStoreError.prepareFailed
        }
        return statement
    }

    func step(_ statement: OpaquePointer?) throws -> Int32 {
        guard let statement else {
            throw SQLiteStoreError.invalidStatement
        }
        let result = sqlite3_step(statement)
        return result
    }

    func finalize(_ statement: OpaquePointer?) {
        guard let statement else { return }
        sqlite3_finalize(statement)
    }

    private static func databaseURL(for name: String) throws -> URL {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw SQLiteStoreError.missingDirectory
        }
        return directory.appendingPathComponent("\(name).sqlite")
    }
}

enum SQLiteStoreError: Error {
    case missingDirectory
    case openFailed
    case executionFailed
    case prepareFailed
    case invalidStatement
}

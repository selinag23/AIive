import Foundation
import FMDB

class MemoDB {
    static let shared = MemoDB()
    
    let databaseFileName = "memos.db"
    var database: FMDatabase?
    
    private init() {
        setupDatabase()
    }
    
    func setupDatabase() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let databaseURL = documentsDirectory.appendingPathComponent(databaseFileName)
        
        database = FMDatabase(url: databaseURL)
        
        guard let db = database else {
            print("Unable to create database.")
            return
        }
        
        if db.open() {
            let createTableQuery = """
            CREATE TABLE IF NOT EXISTS memos (
                id TEXT PRIMARY KEY,
                title TEXT,
                context TEXT,
                date REAL
            )
            """
            do {
                try db.executeUpdate(createTableQuery, values: nil)
                print("Table created successfully")
            } catch {
                print("Failed to create table: \(error.localizedDescription)")
            }
            db.close()
        } else {
            print("Unable to open database.")
        }
    }
    
    func addMemo(memo: Memo) {
        guard let db = database else {
            print("Database not initialized.")
            return
        }
        
        if db.open() {
            let insertQuery = "INSERT INTO memos (id, title, context, date) VALUES (?, ?, ?, ?)"
            do {
                try db.executeUpdate(insertQuery, values: [memo.id.uuidString, memo.title, memo.context, memo.date.timeIntervalSince1970])
                print("Memo added successfully")
            } catch {
                print("Failed to add memo: \(error.localizedDescription)")
            }
            db.close()
        }
    }
    
    func fetchMemos() -> [Memo] {
        var memos = [Memo]()
        
        guard let db = database else {
            print("Database not initialized.")
            return memos
        }
        
        if db.open() {
            let selectQuery = "SELECT * FROM memos"
            do {
                let results = try db.executeQuery(selectQuery, values: nil)
                while results.next() {
                    if let id = results.string(forColumn: "id"),
                       let title = results.string(forColumn: "title"),
                       let context = results.string(forColumn: "context"),
                       let date = results.double(forColumn: "date") as Double? {
                        let memo = Memo(id: UUID(uuidString: id)!, title: title, context: context, date: Date(timeIntervalSince1970: date))
                        memos.append(memo)
                    }
                }
                print("Memos fetched successfully")
            } catch {
                print("Failed to fetch memos: \(error.localizedDescription)")
            }
            db.close()
        }
        
        return memos
    }

    func updateMemo(memo: Memo) {
        guard let db = database else {
            print("Database not initialized.")
            return
        }
        
        if db.open() {
            let updateQuery = "UPDATE memos SET title = ?, context = ?, date = ? WHERE id = ?"
            do {
                try db.executeUpdate(updateQuery, values: [memo.title, memo.context, memo.date.timeIntervalSince1970, memo.id.uuidString])
                print("Memo updated successfully")
            } catch {
                print("Failed to update memo: \(error.localizedDescription)")
            }
            db.close()
        }
    }

    func deleteMemo(memo: Memo) {
        guard let db = database else {
            print("Database not initialized.")
            return
        }
        
        if db.open() {
            let deleteQuery = "DELETE FROM memos WHERE id = ?"
            do {
                try db.executeUpdate(deleteQuery, values: [memo.id.uuidString])
                print("Memo deleted successfully")
            } catch {
                print("Failed to delete memo: \(error.localizedDescription)")
            }
            db.close()
        }
    }
    
    func printAllMemos() {
        guard let db = database else {
            print("Database not initialized.")
            return
        }
        
        if db.open() {
            let selectQuery = "SELECT * FROM memos"
            do {
                let results = try db.executeQuery(selectQuery, values: nil)
                while results.next() {
                    if let id = results.string(forColumn: "id"),
                       let title = results.string(forColumn: "title"),
                       let context = results.string(forColumn: "context"),
                       let date = results.double(forColumn: "date") as Double? {
                        print("Memo - ID: \(id), Title: \(title), Context: \(context), Date: \(Date(timeIntervalSince1970: date))")
                    }
                }
            } catch {
                print("Failed to fetch memos: \(error.localizedDescription)")
            }
            db.close()
        }
    }
}

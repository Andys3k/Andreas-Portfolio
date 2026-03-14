import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct PassJSONDocument: FileDocument {
    static var readableContentTypes: [UTType] = [.json]

    let data: Data

    init(document: PassDocument) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        self.data = (try? encoder.encode(document.payload)) ?? Data()
    }

    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

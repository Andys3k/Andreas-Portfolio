import SwiftUI

struct ContentView: View {
    @State private var document = PassDocument.sample
    @State private var exportedDocument: PassJSONDocument?
    @State private var isExporterPresented = false

    var body: some View {
        NavigationStack {
            PassEditorView(document: $document) {
                exportedDocument = PassJSONDocument(document: document)
                isExporterPresented = true
            }
            .navigationTitle("Wallet Pass Studio")
            .toolbarTitleDisplayMode(.inline)
        }
        .fileExporter(
            isPresented: $isExporterPresented,
            document: exportedDocument,
            contentType: .json,
            defaultFilename: document.safeExportName
        ) { _ in
            exportedDocument = nil
        }
    }
}

#Preview {
    ContentView()
}

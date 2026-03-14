import SwiftUI

struct PassEditorView: View {
    @Binding var document: PassDocument
    let onExport: () -> Void

    var body: some View {
        List {
            Section("Preview") {
                PassPreviewCard(document: document)
                    .listRowInsets(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                    .listRowBackground(Color.clear)
            }

            Section("Pass Details") {
                Picker("Style", selection: $document.style) {
                    ForEach(PassStyle.allCases) { style in
                        Text(style.title).tag(style)
                    }
                }

                TextField("Description", text: $document.description)
                TextField("Organization", text: $document.organizationName)
                TextField("Logo Text", text: $document.logoText)
                TextField("Serial Number", text: $document.serialNumber)
                TextField("Pass Type ID", text: $document.passTypeIdentifier)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Team ID", text: $document.teamIdentifier)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                Toggle("Prevent Sharing", isOn: $document.sharingProhibited)
            }

            Section("Colors") {
                TextField("Foreground Hex", text: $document.foregroundColorHex)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Background Hex", text: $document.backgroundColorHex)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Label Hex", text: $document.labelColorHex)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            FieldListSection(title: "Primary Fields", fields: $document.primaryFields)
            FieldListSection(title: "Secondary Fields", fields: $document.secondaryFields)
            FieldListSection(title: "Auxiliary Fields", fields: $document.auxiliaryFields)
            FieldListSection(title: "Back Fields", fields: $document.backFields)

            Section("Barcode") {
                Picker("Format", selection: $document.barcodeFormat) {
                    ForEach(BarcodeFormat.allCases) { format in
                        Text(format.title).tag(format)
                    }
                }
                TextField("Message", text: $document.barcodeMessage, axis: .vertical)
                TextField("Alt Text", text: $document.barcodeAltText)
            }

            Section {
                Button("Export pass.json", action: onExport)
                    .frame(maxWidth: .infinity, alignment: .center)
            } footer: {
                Text("This exports the raw pass payload. Real Wallet passes still require Apple signing and packaging into .pkpass.")
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct FieldListSection: View {
    let title: String
    @Binding var fields: [PassField]

    var body: some View {
        Section(title) {
            ForEach($fields) { $field in
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Key", text: $field.key)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Label", text: $field.label)
                    TextField("Value", text: $field.value, axis: .vertical)
                }
                .padding(.vertical, 4)
            }
            .onDelete { fields.remove(atOffsets: $0) }

            Button("Add Field") {
                fields.append(.empty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PassEditorView(document: .constant(.sample), onExport: {})
    }
}

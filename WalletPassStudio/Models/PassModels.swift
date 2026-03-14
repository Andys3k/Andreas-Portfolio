import Foundation

enum PassStyle: String, CaseIterable, Codable, Identifiable {
    case generic
    case coupon
    case eventTicket = "eventTicket"
    case storeCard = "storeCard"
    case boardingPass = "boardingPass"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .generic:
            "Generic"
        case .coupon:
            "Coupon"
        case .eventTicket:
            "Event Ticket"
        case .storeCard:
            "Store Card"
        case .boardingPass:
            "Boarding Pass"
        }
    }
}

enum BarcodeFormat: String, CaseIterable, Codable, Identifiable {
    case qr = "PKBarcodeFormatQR"
    case pdf417 = "PKBarcodeFormatPDF417"
    case aztec = "PKBarcodeFormatAztec"
    case code128 = "PKBarcodeFormatCode128"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .qr:
            "QR"
        case .pdf417:
            "PDF417"
        case .aztec:
            "Aztec"
        case .code128:
            "Code 128"
        }
    }
}

struct PassField: Identifiable, Codable, Hashable {
    var id = UUID()
    var key: String
    var label: String
    var value: String

    static let empty = PassField(key: "", label: "", value: "")
}

struct PassDocument: Codable {
    var formatVersion = 1
    var passTypeIdentifier = "pass.com.example.walletpassstudio"
    var teamIdentifier = "ABCDE12345"
    var serialNumber = UUID().uuidString
    var organizationName = "Acme Inc."
    var description = "Custom Wallet Pass"
    var logoText = "VIP ACCESS"
    var foregroundColorHex = "#FFFFFF"
    var backgroundColorHex = "#111827"
    var labelColorHex = "#F59E0B"
    var sharingProhibited = false
    var style: PassStyle = .generic
    var primaryFields: [PassField] = [
        PassField(key: "title", label: "Title", value: "Conference 2026")
    ]
    var secondaryFields: [PassField] = [
        PassField(key: "holder", label: "Holder", value: "Andreas Horak")
    ]
    var auxiliaryFields: [PassField] = [
        PassField(key: "entry", label: "Entry", value: "Gate A")
    ]
    var backFields: [PassField] = [
        PassField(key: "support", label: "Support", value: "support@example.com")
    ]
    var barcodeMessage = "CONF-2026-0001"
    var barcodeFormat: BarcodeFormat = .qr
    var barcodeAltText = "Scan at entry"

    var safeExportName: String {
        let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = trimmed.isEmpty ? "pass" : trimmed
        return name.replacingOccurrences(of: " ", with: "-").lowercased()
    }

    var payload: PassPayload {
        let structure = PassPayload.PassStructure(
            primaryFields: payloadFields(from: primaryFields),
            secondaryFields: payloadFields(from: secondaryFields),
            auxiliaryFields: payloadFields(from: auxiliaryFields),
            backFields: payloadFields(from: backFields)
        )

        return PassPayload(
            description: description,
            formatVersion: formatVersion,
            organizationName: organizationName,
            passTypeIdentifier: passTypeIdentifier,
            serialNumber: serialNumber,
            teamIdentifier: teamIdentifier,
            logoText: logoText.nilIfBlank,
            foregroundColor: foregroundColorHex.nilIfBlank,
            backgroundColor: backgroundColorHex.nilIfBlank,
            labelColor: labelColorHex.nilIfBlank,
            sharingProhibited: sharingProhibited ? true : nil,
            barcode: barcodeMessage.isEmpty ? nil : .init(
                format: barcodeFormat.rawValue,
                message: barcodeMessage,
                messageEncoding: "iso-8859-1",
                altText: barcodeAltText.nilIfBlank
            ),
            generic: style == .generic ? structure : nil,
            coupon: style == .coupon ? structure : nil,
            eventTicket: style == .eventTicket ? structure : nil,
            storeCard: style == .storeCard ? structure : nil,
            boardingPass: style == .boardingPass ? structure : nil
        )
    }

    static let sample = PassDocument()

    private func payloadFields(from fields: [PassField]) -> [PassPayload.Field] {
        fields
            .filter { !$0.key.isBlank && !$0.value.isBlank }
            .map { PassPayload.Field(key: $0.key, label: $0.label.nilIfBlank, value: $0.value) }
    }
}

struct PassPayload: Codable {
    struct Field: Codable {
        var key: String
        var label: String?
        var value: String
    }

    struct Barcode: Codable {
        var format: String
        var message: String
        var messageEncoding: String
        var altText: String?
    }

    struct PassStructure: Codable {
        var primaryFields: [Field]
        var secondaryFields: [Field]
        var auxiliaryFields: [Field]
        var backFields: [Field]
    }

    var description: String
    var formatVersion: Int
    var organizationName: String
    var passTypeIdentifier: String
    var serialNumber: String
    var teamIdentifier: String
    var logoText: String?
    var foregroundColor: String?
    var backgroundColor: String?
    var labelColor: String?
    var sharingProhibited: Bool?
    var barcode: Barcode?
    var generic: PassStructure?
    var coupon: PassStructure?
    var eventTicket: PassStructure?
    var storeCard: PassStructure?
    var boardingPass: PassStructure?
}

private extension String {
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var nilIfBlank: String? {
        isBlank ? nil : self
    }
}

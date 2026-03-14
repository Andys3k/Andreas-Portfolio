import SwiftUI

struct PassPreviewCard: View {
    let document: PassDocument

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(document.organizationName)
                        .font(.caption)
                        .foregroundStyle(labelColor)
                    Text(document.logoText.isEmpty ? document.description : document.logoText)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(foregroundColor)
                        .lineLimit(2)
                }

                Spacer()

                Text(document.style.title.uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(labelColor)
            }

            fieldRow(document.primaryFields, columns: 1, titleFont: .title2.weight(.bold))
            fieldRow(document.secondaryFields, columns: 2, titleFont: .headline)
            fieldRow(document.auxiliaryFields, columns: 2, titleFont: .subheadline.weight(.semibold))

            if !document.barcodeMessage.isEmpty {
                VStack(alignment: .center, spacing: 6) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white.opacity(0.92))
                        .frame(height: 56)
                        .overlay {
                            Text(document.barcodeFormat.title)
                                .font(.footnote.monospaced())
                                .foregroundStyle(.black)
                        }
                    Text(document.barcodeAltText.isEmpty ? document.barcodeMessage : document.barcodeAltText)
                        .font(.caption)
                        .foregroundStyle(foregroundColor.opacity(0.85))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 6)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 240, alignment: .topLeading)
        .background(
            LinearGradient(
                colors: [backgroundColor, backgroundColor.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 18, y: 10)
    }

    private var foregroundColor: Color {
        Color(hex: document.foregroundColorHex) ?? .white
    }

    private var backgroundColor: Color {
        Color(hex: document.backgroundColorHex) ?? Color(red: 0.07, green: 0.1, blue: 0.16)
    }

    private var labelColor: Color {
        Color(hex: document.labelColorHex) ?? .yellow
    }

    @ViewBuilder
    private func fieldRow(_ fields: [PassField], columns: Int, titleFont: Font) -> some View {
        let filtered = fields.filter { !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        if !filtered.isEmpty {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: columns), alignment: .leading, spacing: 10) {
                ForEach(filtered) { field in
                    VStack(alignment: .leading, spacing: 2) {
                        if !field.label.isEmpty {
                            Text(field.label.uppercased())
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(labelColor)
                        }
                        Text(field.value)
                            .font(titleFont)
                            .foregroundStyle(foregroundColor)
                            .lineLimit(2)
                    }
                }
            }
        }
    }
}

private extension Color {
    init?(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard cleaned.count == 6, let value = UInt64(cleaned, radix: 16) else {
            return nil
        }

        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    PassPreviewCard(document: .sample)
        .padding()
        .background(Color(.systemGroupedBackground))
}

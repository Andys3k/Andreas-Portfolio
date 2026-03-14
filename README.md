# WalletPassStudio

`WalletPassStudio` is a small SwiftUI iOS app project for creating and editing custom Apple Wallet pass payloads.

What it does today:

- lets you edit common pass metadata
- supports generic, coupon, event ticket, store card, and boarding pass styles
- previews the pass with your colors and fields
- exports a formatted `pass.json`

What it does not do yet:

- sign the pass into a real `.pkpass`
- add the pass to Apple Wallet directly
- manage Apple certificates or pass assets

To create real Wallet passes, you will still need:

- a Pass Type ID
- Apple-issued signing certificates
- pass images like icon and logo
- a packaging and signing step

Open `WalletPassStudio.xcodeproj` in Xcode and run the iOS app target.

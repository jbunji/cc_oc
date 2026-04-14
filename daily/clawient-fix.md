# Clawient Connection Fix — Research Notes (Feb 26, 2026)

## Root Cause
`GatewayConnectionController.swift` line 668-671:
```swift
private func resolveManualUseTLS(host: String, useTLS: Bool) -> Bool {
    useTLS || self.shouldRequireTLS(host: host)
}
private func shouldRequireTLS(host: String) -> Bool {
    !Self.isLoopbackHost(host)
}
```

**The TLS toggle is ignored for non-localhost hosts.** Any LAN IP (192.168.7.59) forces TLS=true regardless of user preference. This is a security feature — prevents plaintext auth over the network.

For discovered gateways, it's even stricter:
```swift
let tlsRequired = true
guard gateway.tlsEnabled || stored != nil else {
    return "Discovered gateway is missing TLS and no trusted fingerprint is stored."
}
```

## Why Safari worked but Clawient didn't
Safari loads a plain HTTP page (the dashboard). Clawient tries to establish an authenticated WebSocket, which the app forces to require TLS for security.

## Fix Options

### Option 1: Set up TLS on the gateway (RECOMMENDED)
- Generate self-signed cert: `openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -keyout key.pem -out cert.pem -days 3650 -subj "/CN=192.168.7.59"`
- Configure gateway with cert
- On first connect, Clawient will show a "Trust this fingerprint?" prompt — accept it
- One-time setup, works forever

### Option 2: Rebuild Clawient with TLS check removed (HACK)
- Modify `resolveManualUseTLS` to just return `useTLS`
- Build and deploy to iPhone via Xcode
- Works but loses security — bad practice

### Option 3: SSH tunnel (UGLY)
- Not practical from iOS

## Recommendation
Option 1. Check if gateway config has TLS cert fields. Look at schema for `tls` or `cert` config.

## Gateway TLS Config
Need to check: does the gateway support self-signed certs? What config fields exist?
Look at `gateway.tls` in config schema.

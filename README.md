# WDW Wait Times

Live ride wait times for all four Walt Disney World parks — available as an **iPhone app** and an **Apple TV app**. Both are free to install directly from Xcode with a personal Apple ID. No App Store, no paid developer account needed.

---

## What's in this repo

| Branch | App | Platform |
|---|---|---|
| `claude/disney-wait-times-app-lbmkB` | DisneyWaitTimes | iPhone (iOS 17+) |
| `claude/disney-wait-times-tvos-app` | DisneyWaitTimesTV | Apple TV HD / 4K (tvOS 17+) |

Both apps pull live data from the free [themeparks.wiki](https://themeparks.wiki) public API — no account or API key required.

---

## Features

- **All 4 WDW parks** — Magic Kingdom, EPCOT, Hollywood Studios, Animal Kingdom
- **Live wait times** for every attraction, updated in real time
- **Color-coded badges** — green (under 20 min), orange (20–45 min), red (over 45 min)
- **Status labels** — Walk on / N min / Down / Closed / Refurb
- **Single rider lanes** displayed as a sub-label when available
- **Per-park accent themes** — each park gets its own glow color over a magical starry night background
- **iPhone:** pull to refresh, search bar, last-updated timestamp
- **Apple TV:** auto-refreshes every 5 minutes, Refresh button, remote-friendly layout with large text

---

## What you need

- A **Mac** (required to build iOS/tvOS apps — no way around this)
- **Xcode 15 or later** — free from the Mac App Store (~10 GB download)
- A **personal Apple ID** — the same one you use for iCloud; no paid developer account needed
- An **iPhone** (iOS 17+) and/or an **Apple TV HD or 4K** (tvOS 17+)

> **7-day limit:** Apple lets free Apple IDs install apps directly on devices, but the app will stop launching after 7 days. To use it again, plug in (or pair) your device and press ▶ in Xcode — takes about 30 seconds. This is an Apple restriction that can't be avoided without a $99/year Apple Developer membership.

---

## Step 1 — Install Xcode (do this first, once)

1. Open the **App Store** on your Mac.
2. Search for **Xcode** and click **Get / Install**.
3. Wait for it to finish — it is large (~10 GB).
4. Open Xcode once so it finishes setting up its command-line tools. Accept any prompts.

---

## Step 2 — Add your Apple ID to Xcode (do this once)

1. Open Xcode → menu bar: **Xcode → Settings** (or `Cmd + ,`).
2. Click the **Accounts** tab.
3. Click **+** in the bottom-left → **Apple ID** → sign in.
4. Close Settings.

---

## iPhone App

### Download

1. In Safari, go to:
   **https://github.com/sudds65/TestClaude/tree/claude/disney-wait-times-app-lbmkB**
2. Sign in to GitHub if prompted.
3. Click the green **Code** button → **Download ZIP**.
4. In Finder → Downloads: double-click the ZIP to unzip it, then drag the folder to your Desktop.

### Open in Xcode

5. Open the unzipped folder → open the **DisneyWaitTimes** folder inside → double-click **DisneyWaitTimes.xcodeproj**.
6. If macOS warns it was downloaded from the internet, click **Open**.

### Set up signing

7. In Xcode's left sidebar, click the top item **DisneyWaitTimes** (blue icon).
8. Click **DisneyWaitTimes** under **TARGETS**.
9. Click the **Signing & Capabilities** tab.
10. Make sure **Automatically manage signing** is ticked.
11. Under **Team**, choose **Personal Team**.
    > If you see a bundle identifier error, change the **Bundle Identifier** to something unique like `com.yourname.disneywaitimes`.

### Connect your iPhone

12. Plug your iPhone into your Mac with a USB cable.
13. On your iPhone: tap **Trust** on the "Trust This Computer?" prompt, then enter your passcode.
14. In Xcode's toolbar, click the device selector and pick your iPhone.

### Install

15. Press the **▶ Play button** or `Cmd + R`. First build takes 1–2 minutes.

### Trust yourself on iPhone

16. On your iPhone: **Settings → General → VPN & Device Management**.
17. Tap your Apple ID email → **Trust "[your email]"** → **Trust**.
18. Open **DisneyWaitTimes** from your home screen.

---

## Apple TV App

The signing process is identical to the iPhone app. The key difference is that **Apple TV pairs wirelessly** — there is no USB cable.

### Download

1. In Safari, go to:
   **https://github.com/sudds65/TestClaude/tree/claude/disney-wait-times-tvos-app**
2. Sign in to GitHub if prompted.
3. Click the green **Code** button → **Download ZIP**.
4. Unzip, drag the folder to your Desktop.

### Open in Xcode

5. Open the unzipped folder → open **DisneyWaitTimesTV** → double-click **DisneyWaitTimesTV.xcodeproj**.

### Set up signing

6. Click **DisneyWaitTimesTV** in the left sidebar → **DisneyWaitTimesTV** under TARGETS → **Signing & Capabilities**.
7. Tick **Automatically manage signing** → Team = **Personal Team**.
   > Bundle identifier error? Change it to something like `com.yourname.disneywaitimes.tv`.

### Enable pairing on your Apple TV

8. On the Apple TV: **Settings → Remotes and Devices → Remote App and Devices** — leave this screen open.

### Pair your Apple TV with Xcode

9. In Xcode: **Window → Devices and Simulators** (`Cmd + Shift + 2`).
10. Click the **Devices** tab → your Apple TV should appear → click it → click **Pair**.
11. A **6-digit code** appears on your TV — type it into Xcode right away (it expires quickly).
12. Close the Devices window when paired. Pairing is remembered forever.

### Install

13. In Xcode's toolbar, click the device selector and pick your Apple TV.
14. Press **▶** or `Cmd + R`. First build takes 2–3 minutes.

### Trust yourself on Apple TV

15. On the Apple TV: **Settings → General → Device Management**.
16. Tap your Apple ID email → **Trust "[your email]"** → confirm.
17. Open **DisneyWaitTimesTV** from the Home screen.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `git clone` says "Authentication failed" | Don't use git — follow the Download ZIP steps above instead. |
| GitHub shows a 404 at the branch URLs | Make sure you're signed in to GitHub in the browser. |
| Xcode can't find your iPhone | Unplug and re-plug the cable; make sure you tapped Trust on the phone. |
| Apple TV doesn't appear in Devices and Simulators | Both devices must be on the same Wi-Fi. Re-open Settings → Remotes and Devices → Remote App and Devices on the Apple TV. |
| Pairing code doesn't work | It expires fast — try again. Restart Xcode if needed. |
| Signing error about bundle identifier | Change the Bundle Identifier in the Signing tab to something unique. |
| "Untrusted Developer" error | Complete the Trust step in Settings on that device. |
| App shows an error message about HTTP or the API | The error now shows the actual status code. Share it and we can diagnose. |
| App stops launching after a week | Re-press ▶ in Xcode with the device connected — takes 30 seconds to re-sign. |
| Xcode says "No account" | Go to Xcode → Settings → Accounts and add your Apple ID. |

---

## Re-installing after the 7-day expiry

You do **not** need to re-download the ZIP.

1. Open the `.xcodeproj` file you already have on your Desktop.
2. Connect or pair your device.
3. Press **▶** in Xcode.

Done. The 30-second build re-signs the app for another 7 days.

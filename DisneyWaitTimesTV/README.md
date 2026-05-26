# WDW Wait Times — Apple TV

A free Apple TV app that shows live ride wait times for all four Walt Disney World parks. Big text, color-coded badges, auto-refreshes every 5 minutes — perfect to leave on a TV while planning your day.

---

## What you need before starting

- A **Mac** (required to build tvOS apps)
- **Xcode 15 or later** — free from the Mac App Store
- An **Apple ID** (free — no paid developer account needed)
- An **Apple TV HD or Apple TV 4K** (any generation)
- Both the Mac and Apple TV on the **same Wi-Fi network**
- Your Apple TV remote

> **Important — 7-day limit:** Apple lets free Apple IDs install apps directly, but the app stops launching after **7 days**. To use it again, re-run the install step from Xcode. This is an Apple restriction for non-paid accounts.

> **Note:** Unlike iPhone, you cannot plug an Apple TV into your Mac. Xcode pairs with Apple TV **wirelessly** over your local network.

---

## Step 1 — Install Xcode

1. Open the **App Store** on your Mac.
2. Search for **Xcode** and click **Get** / **Install**.
3. Wait for it to finish — it is a large download (~10 GB).
4. Open Xcode once after installing so it finishes setting up its tools.

---

## Step 2 — Download the code from GitHub

We're going to download the project as a ZIP file. **You do not need Terminal, git, or any developer tools for this part.**

1. Open **Safari** (or any browser) on your Mac.
2. Go to this exact URL — copy and paste it:

   **https://github.com/sudds65/TestClaude/tree/claude/disney-wait-times-tvos-app**

3. If you aren't already signed in to GitHub, click **Sign in** in the top-right corner and log in with your GitHub account (the same one you used to access this repo).

4. Once the page loads, find the green **Code** button on the right side, above the file list. Click it.

5. In the menu that drops down, click **Download ZIP**.

6. Open **Finder** and go to your **Downloads** folder. You'll see a file named something like:

   `TestClaude-claude-disney-wait-times-tvos-app.zip`

7. Double-click the ZIP file to unzip it. You'll get a folder with the same name.

8. Drag that unzipped folder out of Downloads onto your **Desktop** so it's easy to find. (Optional, but recommended.)

> **Stuck on this step?** Make sure you are signed in to GitHub in your browser, and that you can see the file list when you visit the URL above. If you see a "404" page, your GitHub account doesn't have access to this repo.

---

## Step 3 — Open the project in Xcode

1. In Finder, open the folder you just unzipped on your Desktop.
2. Inside it, you'll see a folder called **DisneyWaitTimesTV**. Open that.
3. Inside `DisneyWaitTimesTV`, look for a file called **DisneyWaitTimesTV.xcodeproj** — it has a blue Xcode icon.
4. Double-click that file. Xcode will open with the project loaded.

> If macOS warns you that "DisneyWaitTimesTV.xcodeproj" was downloaded from the internet, click **Open** to confirm.

---

## Step 4 — Sign in with your Apple ID

1. In the menu bar, go to **Xcode → Settings** (or press `Cmd + ,`).
2. Click the **Accounts** tab.
3. Click **+** in the bottom-left and choose **Apple ID**.
4. Sign in with your Apple ID and password.
5. Close the Settings window.

---

## Step 5 — Set up code signing

1. In the left sidebar of Xcode, click the top item **DisneyWaitTimesTV** (blue icon).
2. In the main panel, click the **DisneyWaitTimesTV** target under **TARGETS**.
3. Click **Signing & Capabilities**.
4. Make sure **Automatically manage signing** is checked.
5. Under **Team**, select **Personal Team** (this is what Xcode calls a free Apple ID).

   > If you see an error about the bundle identifier being taken, change the
   > **Bundle Identifier** to something unique like
   > `com.yourname.disneywaitimes.tv`.

---

## Step 6 — Enable pairing on your Apple TV

On the Apple TV itself:

1. Open **Settings** on the Apple TV.
2. Go to **Remotes and Devices → Remote App and Devices**.
3. Leave this screen open — your Apple TV is now broadcasting and waiting for Xcode to pair.

---

## Step 7 — Pair your Apple TV with Xcode

Back on your Mac:

1. In Xcode, go to **Window → Devices and Simulators** (or press `Cmd + Shift + 2`).
2. Click the **Devices** tab at the top.
3. Your Apple TV should appear in the list on the left. Click it.
4. Click the **Pair** button.
5. A **6-digit code** will appear on your Apple TV screen — type it into Xcode.
6. After pairing, the Apple TV will show a small "connected" indicator next to its name in Xcode. This pairing is remembered, so you only do it once.

   > If your Apple TV does not appear, make sure both devices are on the same
   > Wi-Fi network and that you opened the Remote App and Devices screen in
   > Step 6.

7. Close the Devices and Simulators window.

---

## Step 8 — Build and install

1. In Xcode's toolbar at the top, click the device selector and choose your **Apple TV**.
2. Press the **Play button** (▶) or `Cmd + R`.
3. Xcode compiles the app and sends it to your Apple TV over Wi-Fi. The first build takes 2–3 minutes.
4. The app will launch automatically on your TV when the install finishes.

---

## Step 9 — Trust the developer on your Apple TV

The first time the app installs, tvOS requires you to manually trust yourself as a developer. You only do this once.

1. On your Apple TV, open **Settings**.
2. Go to **General → Device Management**.
3. Under **Developer App**, select your Apple ID email address.
4. Choose **Trust "[your Apple ID]"** and confirm.

Go back to the Home screen — the app is now launchable.

---

## Step 10 — Use the app

1. From the Apple TV Home screen, open **DisneyWaitTimesTV**.
2. Use the Apple TV Remote to swipe between the four park tabs at the top: Magic Kingdom, EPCOT, Hollywood Studios, Animal Kingdom.
3. Scroll the list of rides with the remote — operating rides appear first, sorted by wait time (longest at the top).
4. The app auto-refreshes every 5 minutes. You can also focus the **Refresh** button at the top-right to update immediately.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `git clone` says "Authentication failed" or "Invalid username or token" | You don't need git at all — follow Step 2 above to download a ZIP from the browser instead. |
| GitHub shows "404" when you visit the URL in Step 2 | Make sure you're signed in to GitHub in that browser, and that your GitHub account has access to this repo. |
| Apple TV doesn't appear in Devices and Simulators | Both devices must be on the same Wi-Fi. On Apple TV, re-open Settings → Remotes and Devices → Remote App and Devices. |
| Pairing code doesn't work | Try again — the code refreshes if not entered quickly. Restart Xcode if needed. |
| "Untrusted Developer" error on Apple TV | Complete Step 9. |
| Signing error about bundle ID | Change the Bundle Identifier in Step 5 to something unique. |
| App shows "Couldn't load wait times" | Apple TV needs an internet connection. Use the Refresh button or wait for auto-refresh. |
| App icon shows as placeholder | Normal — the project includes empty icon stacks; you can replace the layers in `Assets.xcassets/AppIcon.brandassets` if you want a real icon. |

---

## Notes

- The app uses the free [themeparks.wiki](https://themeparks.wiki) public API — no account or API key required.
- Wait times are only available when the parks are open.
- **The app expires every 7 days** with a free Apple ID. When it stops launching, open Xcode, make sure your Apple TV is still on the Remote App and Devices screen (or paired), and press ▶ again.
- For the iPhone version, see the `claude/disney-wait-times-app-lbmkB` branch.

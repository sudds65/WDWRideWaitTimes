# WDW Wait Times

A free iPhone app that shows live ride wait times for all four Walt Disney World parks.

---

## What you need before starting

- A **Mac** (required to build iOS apps)
- **Xcode 15 or later** — free from the Mac App Store
- An **Apple ID** (free — the same one you use for iCloud or the App Store; no paid developer account needed)
- Your **iPhone** and its USB cable
- A **GitHub account** with access to this repository

> **Important — 7-day limit:** Apple allows free Apple IDs to install apps directly on a device, but the app will stop launching after **7 days**. To use it again, just plug your phone back into your Mac and re-run Step 7. This is an Apple restriction for non-paid accounts and cannot be avoided without a $99/year Apple Developer membership.

---

## Step 1 — Install Xcode

1. Open the **App Store** on your Mac.
2. Search for **Xcode** and click **Get** / **Install**.
3. Wait for it to finish — it is a large download (~10 GB).
4. Open Xcode once after installing so it finishes setting up its tools. Accept any prompts it shows.

---

## Step 2 — Download the code from GitHub

We're going to download the project as a ZIP file. **You do not need Terminal, git, or any developer tools for this part.**

1. Open **Safari** (or any browser) on your Mac.
2. Go to this exact URL — copy and paste it:

   **https://github.com/sudds65/TestClaude/tree/claude/disney-wait-times-app-lbmkB**

3. If you aren't already signed in to GitHub, click **Sign in** in the top-right corner and log in with your GitHub account (the same one you used to access this repo).

4. Once the page loads, find the green **Code** button on the right side, above the file list. Click it.

5. In the menu that drops down, click **Download ZIP**.

6. Open **Finder** and go to your **Downloads** folder. You'll see a file named something like:

   `TestClaude-claude-disney-wait-times-app-lbmkB.zip`

7. Double-click the ZIP file to unzip it. You'll get a folder with the same name.

8. Drag that unzipped folder out of Downloads onto your **Desktop** so it's easy to find. (Optional, but recommended.)

> **Stuck on this step?** Make sure you are signed in to GitHub in your browser, and that you can see the file list when you visit the URL above. If you see a "404" page, your GitHub account doesn't have access to this repo.

---

## Step 3 — Open the project in Xcode

1. In Finder, open the folder you just unzipped on your Desktop.
2. Inside it, you'll see a folder called **DisneyWaitTimes**. Open that.
3. Inside `DisneyWaitTimes`, look for a file called **DisneyWaitTimes.xcodeproj** — it has a blue Xcode icon.
4. Double-click that file. Xcode will open with the project loaded.

> If macOS warns you that "DisneyWaitTimes.xcodeproj" was downloaded from the internet, click **Open** to confirm.

---

## Step 4 — Sign in with your Apple ID

Xcode needs your Apple ID to install apps on your phone.

1. In the menu bar, go to **Xcode → Settings** (or press `Cmd + ,`).
2. Click the **Accounts** tab.
3. Click the **+** button in the bottom-left corner and choose **Apple ID**.
4. Sign in with your Apple ID and password.
5. Close the Settings window.

---

## Step 5 — Set up code signing for the app

1. In the left sidebar of Xcode, click the top item named **DisneyWaitTimes** (it has a blue Xcode icon).
2. In the main panel, click the **DisneyWaitTimes** target under **TARGETS**.
3. Click the **Signing & Capabilities** tab.
4. Make sure **Automatically manage signing** is checked.
5. Click the **Team** dropdown and select **Personal Team** (this is what Xcode calls a free Apple ID).
6. Xcode will show a green checkmark when signing is configured correctly.

   > If you see an error about a bundle identifier being taken, change the
   > **Bundle Identifier** field to something unique like
   > `com.yourname.disneywaitimes`.

---

## Step 6 — Connect your iPhone

1. Plug your iPhone into your Mac with the USB cable.
2. On your iPhone, a prompt will appear asking **"Trust This Computer?"** — tap **Trust**, then enter your iPhone passcode.
3. Back in Xcode, click the device selector at the top of the window (it shows a phone or simulator name). Your iPhone should appear in the list — select it.

---

## Step 7 — Build and install the app

1. Press the **Play button** (▶) in the top-left of Xcode, or press `Cmd + R`.
2. Xcode will compile the app and install it on your iPhone. This takes 1–2 minutes the first time.
3. Watch the progress bar at the top of Xcode.

---

## Step 8 — Trust the developer on your iPhone

Because you are installing an app outside the App Store, iOS requires you to manually trust yourself as a developer. You only do this once.

1. On your iPhone, go to **Settings → General → VPN & Device Management**.
2. Under **Developer App**, tap your Apple ID email address.
3. Tap **Trust "[your Apple ID]"**.
4. Tap **Trust** again on the confirmation prompt.

---

## Step 9 — Open the app

1. Find **DisneyWaitTimes** on your iPhone home screen and tap it.
2. The app will load and fetch live wait times. Make sure your phone has an internet connection.
3. Swipe between the four park tabs at the bottom: **MK**, **EP**, **HS**, **AK**.
4. Pull down on any list to refresh the wait times.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `git clone` says "Authentication failed" or "Invalid username or token" | You don't need git at all — follow Step 2 above to download a ZIP from the browser instead. |
| GitHub shows "404" when you visit the URL in Step 2 | Make sure you're signed in to GitHub in that browser, and that your GitHub account has access to this repo. |
| "Untrusted Developer" error on iPhone | Complete Step 8 above |
| Xcode can't find your iPhone | Unplug and re-plug the cable; make sure you tapped Trust on the phone |
| Signing error about bundle ID | Change the Bundle Identifier in Step 5 to something unique |
| App shows "Couldn't load wait times" | Check that your phone has an active internet connection and try pulling to refresh |
| Xcode says "No account" | Repeat Step 4 to add your Apple ID |

---

## Notes

- The app uses the free [themeparks.wiki](https://themeparks.wiki) public API — no account or API key is required.
- Wait times are only available when the parks are open.
- **The app expires every 7 days** with a free Apple ID. When it stops launching, plug your phone into your Mac and press ▶ in Xcode again — takes about 30 seconds.

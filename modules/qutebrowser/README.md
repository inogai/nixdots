# Make Qutebrowser a Default Browser on macOS

This document explains how to configure Qutebrowser installed via Nix to appear
as a default browser option in macOS System Settings.

## Problem

By default, the Qutebrowser Nix package for macOS is missing the necessary
`Info.plist` keys to be recognized as a web browser. As a result, it doesn't
show up in "System Settings" → "Desktop & Dock" → "Default web browser".

## Solution

The solution is to override the Qutebrowser package and inject a custom
`Info.plist` with the required keys.

The most critical addition is `CFBundleDocumentTypes`, which registers the app
as a handler for HTML files. This signals to macOS that Qutebrowser is a web
browser. Other essential keys like `CFBundleURLTypes` are also added to handle
`http/https` schemes.

## Implementation

The `Info.plist` is modified during the `postFixup` phase because the `.app`
bundle is created just before this phase, ensuring the file exists when we
modify it.

The Nix configuration below implements this override.

```nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  # Version-specific variables that should be updated when qutebrowser is upgraded
  appName = "qutebrowser";
  bundleIdentifier = "org.nixos.qutebrowser";
  version = pkgs.qutebrowser.version;
  minMacOSVersion = "11.0.0";

  infoPlistContent = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
            <key>CFBundleDevelopmentRegion</key>
            <string>English</string>
            <key>CFBundleDisplayName</key>
            <string>${appName}</string>
            <key>CFBundleExecutable</key>
            <string>${appName}</string>
            <key>CFBundleIconFile</key>
            <string>${appName}.icns</string>
            <key>CFBundleIconFiles</key>
            <array>
                    <string>${appName}.icns</string>
            </array>
            <key>CFBundleIdentifier</key>
            <string>${bundleIdentifier}</string>
            <key>CFBundleInfoDictionaryVersion</key>
            <string>6.0</string>
            <key>CFBundleName</key>
            <string>${appName}</string>
            <key>CFBundlePackageType</key>
            <string>APPL</string>
            <key>CFBundleShortVersionString</key>
            <string>${version}</string>
            <key>CFBundleSignature</key>
            <string>????</string>
            <key>CFBundleVersion</key>
            <string>${version}</string>
            <key>LSApplicationCategoryType</key>
            <string>public.app-category.productivity</string>
            <key>LSMinimumSystemVersion</key>
            <string>${minMacOSVersion}</string>
            <key>NSHighResolutionCapable</key>
            <true/>
            <key>NSSupportsAutomaticGraphicsSwitching</key>
            <true/>
            <key>NSSupportsSuddenTermination</key>
            <false/>
            <key>NSRequiresAquaSystemAppearance</key>
            <string>NO</string>
            <key>CFBundleDocumentTypes</key>
            <array>
                    <dict>
                            <key>CFBundleTypeName</key>
                            <string>HTML Document</string>
                            <key>CFBundleTypeRole</key>
                            <string>Viewer</string>
                            <key>LSHandlerRank</key>
                            <string>Alternate</string>
                            <key>LSItemContentTypes</key>
                            <array>
                                    <string>public.html</string>
                                    <string>public.xhtml</string>
                            </array>
                    </dict>
            </array>
            <key>CFBundleURLTypes</key>
            <array>
                    <dict>
                            <key>CFBundleURLName</key>
                            <string>HTTP URL</string>
                            <key>CFBundleURLSchemes</key>
                            <array>
                                    <string>http</string>
                                    <string>https</string>
                            </array>
                            <key>CFBundleTypeRole</key>
                            <string>Viewer</string>
                            <key>LSHandlerRank</key>
                            <string>Default</string>
                    </dict>
            </array>
    </dict>
    </plist>
  '';

  customQutebrowser = pkgs.qutebrowser.overrideAttrs (oldAttrs: {
    postFixup = (oldAttrs.postFixup or "") + ''
      PLIST_PATH="$out/Applications/qutebrowser.app/Contents/Info.plist"
      if [ -f "$PLIST_PATH" ]; then
        echo "Found existing Info.plist, modifying to add URL scheme handlers..."
        cat > "$PLIST_PATH" << 'EOF'
${infoPlistContent}EOF
        echo "Info.plist successfully updated with HTTP/HTTPS URL schemes"
      else
        echo "WARNING: Info.plist not found at $PLIST_PATH"
        echo "Bundle structure:"
        ls -la "$out/Applications/qutebrowser.app/Contents/" 2>/dev/null || echo "Bundle does not exist"
      fi
    '';
  });
in {
  programs.qutebrowser = {
    enable = true;
    package = customQutebrowser;
    # ... rest of configuration
  };
}
```

## Verification

After applying this configuration and rebuilding with `home-manager switch`,
verify the changes:

1. **Check `Info.plist`**:

   ```bash
   # Check if Info.plist was updated
   cat ~/.nix-profile/Applications/qutebrowser.app/Contents/Info.plist | grep -A 5 CFBundleURLTypes
   ```

2. **Re-register with Launch Services**:

   ```bash
   /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f ~/.nix-profile/Applications/qutebrowser.app
   ```

3. **Verify `web-browser` flag**:

   ```bash
   /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -dump | grep -A 25 "$(readlink ~/.nix-profile/Applications/qutebrowser.app | rev | cut -d'/' -f4- | rev)" | grep "web-browser"
   ```

   You should see `flags: web-browser`.

### Setting as Default Browser

1. Open **System Settings** → **Desktop & Dock**.
2. Find the **Default web browser** dropdown and select **qutebrowser**.

Alternatively, run this command:

```sh
nix run github:NixOS/nixpkgs/nixos-unstable#defaultbrowser -- qutebrowser
```

## Technical Background

macOS Launch Services identifies an app as a web browser if its `Info.plist`
contains:

1. **`CFBundleDocumentTypes`** with HTML content types (the primary trigger).
2. **`CFBundleURLTypes`** with `http/https` schemes.

When present, Launch Services sets the `web-browser` flag, making the app a
valid default browser. The `launch-disabled` flag may appear due to macOS
security for `/nix/store` paths but does not affect functionality.

## Maintenance

The version is derived automatically from `pkgs.qutebrowser.version`. After
upgrades, re-register the app to ensure macOS recognizes the new version:

```bash
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f ~/.nix-profile/Applications/qutebrowser.app
```

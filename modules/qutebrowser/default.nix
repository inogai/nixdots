{
  config,
  pkgs,
  lib,
  ...
}: let
  keys = import ../../lib/keybindings.nix;
  dir = keys.direction;
  mode = keys.mode;

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
    postFixup =
      (oldAttrs.postFixup or "")
      + ''
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
    loadAutoconfig = true;
    searchEngines = {
      DEFAULT = "https://google.com/search?q={}";
      g = "https://google.com/search?q={}";
      p = "https://www.perplexity.ai/?q={}";
    };
    settings = {
      url.default_page = "https://www.google.com";
      colors.webpage.bg = "white";
      # fonts.default_family = "Iosevka";
      fonts.default_size = "18pt";
      tabs.position = "left";
      editor.command = [
        "kitty"
        "-e"
        "nvim"
        "-f"
        "{file}"
        "-c"
        "normal {line}G{column0}l"
      ];
    };
    keyBindings = {
      normal = {
        " e" = "config-cycle tabs.show always switching";
        "  " = "cmd-set-text -s :tab-select";
        "<F12>" = "devtools";
        "xx" = "config-source";
        "xr" = "greasemonkey-reload;; reload";
        "xc" = "spawn sh -c 'echo \"{url}\" >> $HOME/urls.txt'";

        # Direction keys (from lib/keybindings.nix)
        ${dir.left} = "scroll-px 0 100";
        ${dir.down} = "scroll-px 0 -100";
        ${dir.up} = "scroll-px -100 0";
        ${dir.right} = "scroll-px 100 0";
        ${lib.toUpper dir.left} = "back";
        ${lib.toUpper dir.right} = "forward";
        ${lib.toUpper dir.down} = "tab-next";
        ${lib.toUpper dir.up} = "tab-prev";

        # Mode keys (from lib/keybindings.nix)
        ${mode.insert} = "mode-enter insert";
      };
    };
  };
}

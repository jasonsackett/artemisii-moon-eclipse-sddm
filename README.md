# Artemis II Moon Eclipse SDDM theme

A minimal static SDDM theme for Plasma/SDDM, built around a dark lunar-eclipse image.

## Files

- `Main.qml`: main theme layout and login UI
- `metadata.desktop`: SDDM theme metadata
- `theme.conf`: editable defaults
- `background.jpg`: background artwork
- `preview.png`: preview image for theme pickers / store listings
- `PKGBUILD`: simple Arch/CachyOS package recipe

## Local install

```bash
sudo mkdir -p /usr/share/sddm/themes/artemisii-moon-eclipse
sudo cp -r ./* /usr/share/sddm/themes/artemisii-moon-eclipse/
```

Then select it in System Settings > Colors & Themes > Login Screen (SDDM), or set:

```ini
[Theme]
Current=artemisii-moon-eclipse
```

in `/etc/sddm.conf`.

## Test before switching

```bash
sddm-greeter-qt6 --test-mode --theme "$PWD"
```

If your system only has the Qt5 greeter, use:

```bash
sddm-greeter --test-mode --theme "$PWD"
```

## Build the package

Put `PKGBUILD` and `artemisii-moon-eclipse-sddm.tar.gz` in the same directory, then run:

```bash
makepkg -si
```

## Licenses

```
Code license: MIT
Background image: NASA imagery. Not owned by this theme author and not relicensed here.
Source attribution: NASA
Use of the included NASA image remains subject to NASA Media Usage Guidelines.
```

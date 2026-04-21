# SafetyShield

iOS-приложение в стиле кибербезопасности: тёмная неоновая тема, кнопка «Перейти в Telegram» → [@safetyshield](https://t.me/safetyshield).

## Что внутри
- **Theos-проект** (Objective-C + UIKit, без Xcode)
- Кастомный градиентный фон, grid-overlay, пульсирующий щит, неоновая кнопка с тенью
- Открывает `tg://resolve?domain=safetyshield`, с фоллбэком на `https://t.me/safetyshield`

## Сборка

### Вариант А — локально через WSL2 + Theos (Windows)
```bash
# Однократная установка
wsl --install -d Ubuntu
# внутри WSL:
sudo apt update && sudo apt install -y build-essential fakeroot rsync perl curl zip git
bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"
# SDK
cd $THEOS/sdks
curl -LO https://github.com/theos/sdks/archive/master.zip
unzip master.zip && mv sdks-master/*.sdk . && rm -rf sdks-master master.zip

# Сборка
cd /mnt/c/SafetyShield/SafetyShield
make package FINALPACKAGE=1
# Получишь packages/com.safetyshield.app_1.0.0_iphoneos-arm.deb
```

Конвертация `.deb` → `.ipa`:
```bash
DEB=$(ls packages/*.deb | head -n1)
mkdir -p ipa_build/Payload
dpkg-deb -x "$DEB" ipa_build/extracted
cp -R ipa_build/extracted/Applications/SafetyShield.app ipa_build/Payload/
cd ipa_build && zip -qr ../SafetyShield.ipa Payload
```

### Вариант Б — бесплатная сборка через GitHub Actions
1. Залей репозиторий на GitHub
2. Вкладка **Actions** → **Build SafetyShield IPA** → **Run workflow**
3. Скачай артефакт `SafetyShield-IPA` — там готовый `.ipa`

Workflow уже готов в [.github/workflows/build-ipa.yml](.github/workflows/build-ipa.yml).

## Установка на устройство
- **С джейлом:** ставь `.deb` через Sileo/Zebra, или кинь `.ipa` в TrollStore / AppSync + Filza
- **Без джейла:** TrollStore (если версия iOS совместима) или Sideloadly/AltStore с Apple ID

## Структура
```
SafetyShield/
├── Makefile           # Theos build config
├── control            # Debian package metadata
├── entitlements.plist
├── main.m
├── AppDelegate.{h,m}
├── ViewController.{h,m}   # вся UI-магия здесь
└── Resources/
    └── Info.plist
```

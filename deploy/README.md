# XMP Server — راه‌اندازی روی VPS

سرور XMP همان موتور متن‌باز MTA (فورک xmp-blue، GPLv3) با برند و نام‌های XMP است
و با XMP Client و کلاینت‌های سازگار کار می‌کند.

## نصب سریع (Debian/Ubuntu)

```bash
git clone https://github.com/XMP-Sa/xmp-blue.git
cd xmp-blue/deploy
sudo bash install-server.sh "اسم سرور من"
```

اسکریپت: آخرین ریلیز سرور را از گیت‌هاب می‌گیرد، در `/opt/xmp-server` نصب می‌کند،
سرویس systemd می‌سازد و پورت‌ها را باز می‌کند.

## پورت‌ها

| پورت | پروتکل | کاربرد |
|---|---|---|
| 22003 | UDP | بازی (قابل تغییر در `mtaserver.conf`) |
| 22126 | UDP | ASE — نمایش در لیست سرورها (پورت بازی + ۱۲۳) |
| 22005 | TCP | HTTP داخلی سرور (دانلود ریسورس‌ها) |

## مدیریت

```bash
systemctl status xmp-server
journalctl -u xmp-server -f
systemctl restart xmp-server
```

کانفیگ اصلی: `/opt/xmp-server/mods/deathmatch/mtaserver.conf`
(نام فایل کانفیگ عمداً همان نام استاندارد موتور مانده تا مستندات و ابزارهای موجود کار کنند.)

## نکته درباره هاست موقت

GitHub Actions برای میزبانی سرور بازی مناسب نیست (آی‌پی عمومی و پورت UDP ورودی ندارد)؛
فقط برای بیلد و تست دود استفاده می‌شود. برای سرور همیشه‌روشن یک VPS لینوکسی کوچک کافی است.

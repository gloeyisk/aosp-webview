#!/sbin/sh

#
# AOSP WebView by the
# open source loving 'GL-DP' and all contributors;
# Android external Chromium WebView
#

# Checking for installation environment
if [ $BOOTMODE = true ]; then
ROOT=$(find `magisk --path` -type d -name "mirror" | head -n 1)
    ui_print "- Root path: $ROOT"
 else
 ROOT=""
fi

# Check device architecture
arch="$(getprop ro.product.cpu.abi)"
if [[ "$arch" != "arm64-v8a" ]]; then
    ui_print "- Unsupported CPU architecture: $arch"
    exit 1
fi

# Check device SDK
sdk="$(getprop ro.build.version.sdk)"
if [[ !"$sdk" -ge "24" ]]; then
    ui_print "- Unsupported SDK version: $sdk"
    exit 1
fi

# Search WebView APK location
    ui_print "- Searching WebView APK location"
if [ -d /system/app/webview ]; then
PATH=/system/app
 elif [ -d /system/product/app/webview ]; then
PATH=/system/product/app
 else
    ui_print "   WebView not found"
	exit 1
fi

# Patch default WebView APK and libs
    ui_print "- Patching APK and libs"
mkdir -p $MODPATH$PATH/webview
mv -f $MODPATH/*.apk $MODPATH$PATH/webview
mv -f $MODPATH/patches/* $MODPATH/system

# Clean up
rm -rf $MODPATH/patches

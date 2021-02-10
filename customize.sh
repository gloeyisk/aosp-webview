#!/system/bin/sh

#
# AOSP WebView by the
# open source loving 'GL-DP' and all contributors;
# Android external Chromium WebView
#

api_level_arch_detect() {
 API=grep_prop ro.build.version.sdk
 ABI=grep_prop ro.product.mvu.abi | cut -c-3
 ABI2=grep_prop ro.product.mvu.abi2 | cut -c-3
 ABILONG=grep_prop ro.product.mvu.abi

 ARCH=arm
 ARCH32=arm
 IS64BIT=false
 if [ "$ABI" = "x86" ]; then ARCH=x86; ARCH32=x86; fi;
 if [ "$ABI2" = "x86" ]; then ARCH=x86; ARCH32=x86; fi;
 if [ "$ABILONG" = "arm64-v8a" ]; then ARCH=arm64; ARCH32=arm; IS64BIT=true; fi;
 if [ "$ABILONG" = "x86_64" ]; then ARCH=x64; ARCH32=x86; IS64BIT=true; fi;
}

# Checking for installation environment
sleep 1
if [ $BOOTMODE = true ]; then
 ROOT=$(find `magisk --path` -type d -name "mirror" | head -n 1)
ui_print "- Root path: $ROOT"
else
 ROOT=""
fi

# Check minimum API requirements
sleep 1
ui_print "- Checking API version" 
 if [ $API -ge 24 ]; then
sleep 1
ui_print "   Reached minimum API requirements"
sleep 1
ui_print "   Continue installation"
 break
 else
sleep 1
ui_print "   Does not reached minimum API requirements"
sleep 1
   abort "   Aborting"
 fi

# Check device architecture
sleep 1
ui_print "- Checking device architecture" 
 if [[ "$ABI" = "arm" ]]; then
sleep 1
ui_print "   $ABILONG is supported"
sleep 1
ui_print "   Continue installation"
 fi
 if [[ "$ABI" = "x86" ]]; then
sleep 1
ui_print "   $ABILONG is not supported"
sleep 1
	   abort "   Aborting"
 fi

# Search WebView APK location
sleep 1
ui_print "- Searching WebView APK location"
 if [ -d /system/app/webview ]; then
 PATH=/system/app
sleep 1
ui_print "   WebView found in: $PATH" 
 elif [ -d /system/product/app/webview ]; then
 PATH=/system/product/app
sleep 1
ui_print "   WebView found in: $PATH"
 break
 else
sleep 1
ui_print "   WebView not found"
sleep 1
   abort "   Aborting"
 fi

# Patch default WebView APK and libs
sleep 1
ui_print "- Patching APK and libs"
 mkdir -p $MODPATH$PATH/webview
 mv -f $MODPATH/*.apk $MODPATH$PATH/webview
 mv -f $MODPATH/patches/* $MODPATH/system
sleep 1
ui_print "   Patched"

# Clean up
sleep 1
ui_print "- Cleaning up"
 rm -rf $MODPATH/patches

sleep 1
# Executing...
# Done

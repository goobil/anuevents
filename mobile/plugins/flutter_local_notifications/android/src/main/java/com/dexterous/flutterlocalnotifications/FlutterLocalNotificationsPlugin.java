package com.dexterous.flutterlocalnotifications;

import android.content.Context;
import android.graphics.Bitmap;

public class FlutterLocalNotificationsPlugin {
    // Minimal stub: the real plugin has many methods. This vendored copy
    // is intended only to satisfy Android build until upstream patch is available.

    private Context context;

    public FlutterLocalNotificationsPlugin(Context context) {
        this.context = context;
    }

    // Example placeholder to reflect the earlier patched call site
    public void example() {
        // corrected ambiguous overload call
        android.app.Notification.BigPictureStyle style = new android.app.Notification.BigPictureStyle();
        style.bigLargeIcon((Bitmap) null);
    }
}

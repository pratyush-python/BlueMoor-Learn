package com.bluemoor.learn

import android.app.Application
import android.os.StrictMode
import com.bluemoor.learn.security.SecureStorage

class BlueMoorApp : Application() {
    override fun onCreate() {
        super.onCreate()

        // Wipe any older plain-text stores left from early test builds.
        SecureStorage.wipeLegacyPlainStores(this)

        if (BuildConfig.DEBUG) {
            StrictMode.setThreadPolicy(
                StrictMode.ThreadPolicy.Builder()
                    .detectAll()
                    .penaltyLog()
                    .build(),
            )
            StrictMode.setVmPolicy(
                StrictMode.VmPolicy.Builder()
                    .detectAll()
                    .penaltyLog()
                    .build(),
            )
        }
    }
}

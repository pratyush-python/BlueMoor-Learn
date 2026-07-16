package com.bluemoor.learn.security

import android.content.Context
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import java.io.File

/**
 * Device-bound encrypted preferences using the Android Keystore.
 *
 * - Master key: AES-256-GCM, stored in Android Keystore (hardware-backed when available)
 * - Preference keys: AES-256-SIV
 * - Preference values: AES-256-GCM
 *
 * Ciphertext is useless on another device without the Keystore key.
 */
object SecureStorage {

    const val PREFS_NAME = "bluemoor_progress_secure"
    private const val LEGACY_DATASTORE_NAME = "bluemoor_progress.preferences_pb"

    @Volatile
    private var cached: SharedPreferences? = null

    fun encryptedPreferences(context: Context): SharedPreferences {
        cached?.let { return it }
        return synchronized(this) {
            cached ?: create(context.applicationContext).also { cached = it }
        }
    }

    private fun create(context: Context): SharedPreferences {
        val masterKey = MasterKey.Builder(context)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .setUserAuthenticationRequired(false)
            .build()

        return EncryptedSharedPreferences.create(
            context,
            PREFS_NAME,
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
        )
    }

    /**
     * Removes any pre-security plain DataStore file so progress is not
     * left readable on disk after upgrade.
     */
    fun wipeLegacyPlainStores(context: Context) {
        val app = context.applicationContext
        runCatching {
            val ds = File(app.filesDir, "datastore/$LEGACY_DATASTORE_NAME")
            if (ds.exists()) ds.delete()
        }
        runCatching {
            // Old plain SharedPreferences name if any early builds used it
            app.deleteSharedPreferences("bluemoor_progress")
        }
    }
}

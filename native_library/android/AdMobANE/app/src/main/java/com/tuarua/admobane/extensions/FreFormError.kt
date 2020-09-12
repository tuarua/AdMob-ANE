package com.tuarua.admobane.extensions

import com.google.android.ump.FormError

fun FormError.toMap(): Map<String, Any?>? {
    return mapOf("text" to message.toString(), "id" to this.errorCode)
}
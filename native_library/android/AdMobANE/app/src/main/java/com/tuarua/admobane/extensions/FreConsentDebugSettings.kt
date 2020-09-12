package com.tuarua.admobane.extensions

import android.content.Context
import com.adobe.fre.FREObject
import com.google.android.ump.ConsentDebugSettings
import com.tuarua.frekotlin.Int
import com.tuarua.frekotlin.List
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun ConsentDebugSettings(context : Context, freObject: FREObject?): ConsentDebugSettings? {
    val rv = freObject ?: return null
    val builder = ConsentDebugSettings.Builder(context)
    builder.setDebugGeography(Int(rv["geography"]) ?: 0)
    val testDeviceIdentifiers = List<String>(rv["testDeviceIdentifiers"])
    testDeviceIdentifiers.forEach { device ->
        builder.addTestDeviceHashedId(device)
    }
    return builder.build()
}
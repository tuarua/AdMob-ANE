package com.tuarua.admobane {
public class ErrorCodes {
    //Something happened internally; for instance, an invalid response was received from the ad server.
    public static const INTERNAL_ERROR:int = 0;
    //The ad request was invalid; for instance, the ad unit ID was incorrect.
    public static const INVALID_REQUEST:int = 1;
    //The ad request was unsuccessful due to network connectivity.
    public static const NETWORK_ERROR:int = 2;
    //The ad request was successful, but no ad was returned due to lack of ad inventory.
    public static const NO_FILL:int = 3;
}
}
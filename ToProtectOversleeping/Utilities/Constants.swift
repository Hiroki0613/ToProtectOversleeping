//
//  Constants.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/10.
//

import UIKit

enum PrimaryColor {
    static let primary = UIColor.systemOrange
}

enum PrimaryPlace {
    static let primaryAddressLatitude = 35.637375
    static let primaryAddressLongitude = 139.756308
}

enum Lottie {
    static let alarmClock = "32490-alarm-clock"
    static let chatBubblesInsidePhone = "23414-chat-bubbles-inside-phone"
    static let forestMorning = "16401-forest-morning"
    static let vaporwaveVendingMachine = "43027-vaporwave-vending-machine"
}

enum WalkThrough {
    static let titleFont = "Helvetica-Bold"
    static let descFont = "HiraMaruProN-W4"
    
    static let thanksIcon = "thanks"
    static let notAlarmIcon = "notAlarm"
    static let hotToUseIcon = "howToUse"
    static let rainyDayIcon = "rainyDay"
}

enum QrcodeImage {
    static let icon = "wakeup"
}

enum UserDefaultsString {
    static let userName = "userName"
    static let isFirstOpenApp = "isFirstOpenApp"
    static let wakeUpResultDate = "wakeUpResultDate"
    static let teamChatName = "teamChatName"
    static let theGoalSettingText = "theGoalSettingText"
    static let isFirstDownloadInstructions = "isFirstDownloadInstructions"
    static let isFirstAccessToGPSVendingMachineScan = "isFirstAccessToGPSVendingMachineScan"
    static let isFirstAccessToChat = "isFirstAccessToChat"
}

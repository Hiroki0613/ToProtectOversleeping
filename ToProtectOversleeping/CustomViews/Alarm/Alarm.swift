//
//  Alarm.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/05.
//

// 参考URL
// https://qiita.com/K_Kenty/items/d589a0f0e1949e167aab
// https://qiita.com/wadaaaan/items/d75b67ef712d49b2399e

import Foundation

struct Alarm {
    // 起きる時間までの秒数を計算
    // この関数を元に、2h以内かどうかを判定する。
    func calculateTimeInterval(userAwakeTime: Date) -> Int {
        // タイマーの時間を計算する
        var interval = Int(userAwakeTime.timeIntervalSinceNow)
        
        if interval < 0 {
            interval = 86400 - (0 - interval)
        }
        
        let calendar = Calendar.current
        let seconds = calendar.component(.second, from: userAwakeTime)
        return interval - seconds
    }
}

//
//  Alarm.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/05.
//

// 参考URL
// https://qiita.com/K_Kenty/items/d589a0f0e1949e167aab

import Foundation

class Alarm {
    var selectedWakeUpTime: Date?
    var sleepTimer: Timer?
    var seconds = 0
    
    // アラームタイマーを開始
    func runTimer() {
        //calculateIntervalにユーザーが入力した日付を渡す。渡り値をsecondsに代入
        guard let selectedWakeUpTime = selectedWakeUpTime else { return }
        seconds = calculateInterval(userAwakeTime: selectedWakeUpTime)
        
        if sleepTimer == nil {
            // タイマーをセット、１秒ごとにupdateCurrentTimeを呼ぶ
            sleepTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateTimer() {
        if seconds != 0 {
            // secondsから-1する
            seconds = seconds - 1
        } else {
            // タイマーを止める
            sleepTimer?.invalidate()
            // タイマーにnilを代入
            sleepTimer = nil
            
            // ここで目覚ましのアクション
        }
    }
    
    func stopTimer() {
        // sleepTimerがnilじゃない場合
        if sleepTimer != nil {
            // タイマーを止める
            sleepTimer?.invalidate()
            // タイマーにnilを代入
        } else {
            // タイマーを止める
            // 目覚ましアクションを止める
        }
    }
    
    // 起きる時間までの秒数を計算
    private func calculateInterval(userAwakeTime: Date) -> Int {
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

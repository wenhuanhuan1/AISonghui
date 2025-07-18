//
//  WHHLanguageManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/18.
//

import UIKit

enum WHHLanguageKey: String {
    /// 英文
    case WHHEN = "en"
    /// 繁体中文
    case WHHZHHANT = "zh-Hant"
    /// 简体中文
    case WHHZHHANS = "zh-Hans"
}

class WHHLanguageManager {
    static let shared = WHHLanguageManager()

    private(set) var languageType:WHHLanguageKey = .WHHZHHANS
    
    private let userDefaultsKey = "SelectedLanguage"
    private var currentBundle: Bundle = Bundle.main

    var currentLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: userDefaultsKey) ?? defaultLanguage()
        }
        set {
            guard availableLanguages().contains(newValue) else { return }
            UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
            updateBundle(languageCode: newValue)
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }

    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: userDefaultsKey)
        updateBundle(languageCode: savedLanguage ?? defaultLanguage())
    }

    private func defaultLanguage() -> String {
        return languageType.rawValue
    }

    func availableLanguages() -> [String] {
        return Bundle.main.localizations.filter { $0 != "Base" }
    }

    private func updateBundle(languageCode: String) {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            currentBundle = Bundle.main
            return
        }
        currentBundle = bundle
    }

    func localizedString(forKey key: String) -> String {
        return currentBundle.localizedString(forKey: key, value: nil, table: nil)
    }

    func resetToSystemLanguage() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        currentLanguage = defaultLanguage()
    }

    func initNeedLanguage() {
    
        if let saveLagure = UserDefaults.standard.string(forKey: userDefaultsKey){
            // 用户已经切换过语音
            currentLanguage = saveLagure
        } else {
            // 没有切换过
            if let languageCode = Locale.current.languageCode {
                // 系统切换不需要保存
                updateBundle(languageCode: languageCode)
            }
        }
    }
}

extension String {
    var localized: String {
        return WHHLanguageManager.shared.localizedString(forKey: self)
    }

    func localized(with arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("LanguageChangedNotification")
}

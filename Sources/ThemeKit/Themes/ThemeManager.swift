//
//  ThemeManager.swift
//  ThemeKit
//
//  Created by Sun on 2024/8/19.
//

import UIKit
import Combine

import WWExtensions

public class ThemeManager {
    
    private static let defaultLightMode: ThemeMode = .system
    private static let userDefaultsKey = "theme_mode"

    public static var shared = ThemeManager()

    @PostPublished public var themeMode: ThemeMode {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: ThemeManager.userDefaultsKey)
            currentTheme = ThemeManager.theme(mode: themeMode)
            Theme.updateNavigationBarTheme()
        }
    }

    private(set) var currentTheme: ITheme

    init() {
        var storedThemeMode: ThemeMode?
        if let newLightMode = UserDefaults.standard.value(forKey: ThemeManager.userDefaultsKey) as? String {
            storedThemeMode = ThemeMode(rawValue: newLightMode)
        }

        let themeMode = storedThemeMode ?? ThemeManager.defaultLightMode
        currentTheme = ThemeManager.theme(mode: themeMode)

        self.themeMode = themeMode
    }

    private static func theme(mode: ThemeMode) -> ITheme {
        switch mode {
        case .light: return LightTheme()
        case .dark: return DarkTheme()
        case .system: return SystemTheme()
        }
    }

}

public class Theme {

    public static var current: ITheme {
        ThemeManager.shared.currentTheme
    }

    public static func updateNavigationBarTheme() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.shadowColor = .clear
        standardAppearance.shadowImage = UIImage()
        standardAppearance.backgroundColor = .zx009
        standardAppearance.backgroundImage = UIImage()
        standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.zx001]
        standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.zx001]

        UINavigationBar.appearance().standardAppearance = standardAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = standardAppearance
    }
}

public enum ThemeMode: String {
    case light
    case dark
    case system
}

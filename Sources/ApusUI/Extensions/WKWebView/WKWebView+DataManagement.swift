//
//  WKWebView+DataManagement.swift
//  ApusUI
//
//  Created by SwiftDevelop on 2025/12/01.
//

import WebKit
import UIKit

// MARK: - Enums
public enum WebsiteDataType {
    case cookies
    case diskCache
    case memoryCache
    case localStorage
    case offlineWebApplicationCache
    case webSQLDatabases
    case indexedDBDatabases
    case all

    /// `WKWebsiteDataType` 상수를 반환합니다.
    @MainActor
    var wkWebsiteDataTypes: Set<String> {
        switch self {
        case .cookies: return Set([WKWebsiteDataTypeCookies])
        case .diskCache: return Set([WKWebsiteDataTypeDiskCache])
        case .memoryCache: return Set([WKWebsiteDataTypeMemoryCache])
        case .localStorage: return Set([WKWebsiteDataTypeLocalStorage])
        case .offlineWebApplicationCache: return Set([WKWebsiteDataTypeOfflineWebApplicationCache])
        case .webSQLDatabases: return Set([WKWebsiteDataTypeWebSQLDatabases])
        case .indexedDBDatabases: return Set([WKWebsiteDataTypeIndexedDBDatabases])
        case .all: return WKWebsiteDataStore.allWebsiteDataTypes() // 모든 데이터 타입 반환
        }
    }
}

// MARK: - Website Data Management
public extension WKWebView {
    /// 지정된 타입의 웹사이트 데이터를 비동기적으로 삭제합니다.
    ///
    /// - Parameters:
    ///   - dataTypes: 삭제할 데이터 타입을 담은 `WebsiteDataType` 배열.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @MainActor
    @discardableResult
    func removeWebsiteData(for dataTypes: [WebsiteDataType]) async -> Self {
        let dataStore = self.configuration.websiteDataStore
        var typesToRemove: Set<String> = []
        for type in dataTypes {
            typesToRemove.formUnion(type.wkWebsiteDataTypes)
        }
        
        // withCheckedContinuation을 사용하여 비동기 처리
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            // fetchDataRecords 호출 없이 바로 removeData(ofTypes: modifiedSince:) 사용
            dataStore.removeData(ofTypes: typesToRemove, modifiedSince: .distantPast) {
                continuation.resume() // 작업 완료 시 async 함수 재개
            }
        }
        
        return self
    }
}

// MARK: - Cookie Management
public extension WKWebView {
    /// 웹뷰에 저장된 모든 `HTTPCookie` 객체를 비동기적으로 가져옵니다.
    ///
    /// - Returns: `HTTPCookie` 객체 배열.
    @MainActor
    @discardableResult
    func getCookies() async -> [HTTPCookie] {
        let cookieStore = self.configuration.websiteDataStore.httpCookieStore
        
        return await withCheckedContinuation { continuation in
            cookieStore.getAllCookies { cookies in
                continuation.resume(returning: cookies)
            }
        }
    }

    /// 지정된 `HTTPCookie` 객체를 웹뷰에 설정합니다.
    ///
    /// - Parameter cookie: 설정할 `HTTPCookie` 객체.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @MainActor
    @discardableResult
    func setCookie(_ cookie: HTTPCookie) async -> Self {
        let cookieStore = self.configuration.websiteDataStore.httpCookieStore
        
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            cookieStore.setCookie(cookie) {
                continuation.resume()
            }
        }
        
        return self
    }

    /// 클로저를 사용하여 `HTTPCookie` 속성을 구성한 후 웹뷰에 설정합니다.
    ///
    /// 이 메소드는 `HTTPCookie` 객체를 직접 생성하는 대신, 클로저 내에서 속성을 설정하여
    /// 쿠키를 더 편리하게 구성할 수 있도록 돕습니다.
    ///
    /// - Parameter configure: `HTTPCookiePropertyKey: Any` 딕셔너리를 `inout` 파라미터로 받아
    ///   쿠키의 속성을 설정하는 클로저.
    /// - Returns: 체이닝을 위한 `WKWebView` 인스턴스.
    @MainActor
    @discardableResult
    func setCookie(_ configure: (inout [HTTPCookiePropertyKey: Any]) -> Void) async -> Self {
        var properties: [HTTPCookiePropertyKey: Any] = [:]
        configure(&properties)
        
        if let cookie = HTTPCookie(properties: properties) {
            await self.setCookie(cookie) // 기존 setCookie 메소드 재사용
        }
        
        return self
    }
}

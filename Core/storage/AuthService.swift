//
//  AuthService.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation
import LocalAuthentication

protocol AuthServiceProtocol: AnyObject {
    var isAuthenticated: Bool { get }
    func login(phone: String, pin: String, completion: @escaping (Result<Void, Error>) -> Void)
    func authenticateWithBiometrics(completion: @escaping (Result<Void, Error>) -> Void)
    func logout()
}

enum AuthError: LocalizedError {
    case biometricsNotAvailable
    case authFailed
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .biometricsNotAvailable:
            return "Биометрия не настроена на устройстве."
        case .authFailed:
            return "Не удалось подтвердить личность."
        case .invalidCredentials:
            return "Неверный номер телефона или PIN (тест: +375 29 123-45-67 / 1234)."
        }
    }
}

final class AuthService: AuthServiceProtocol {
    private let defaults = UserDefaults.standard
    private let authKey = "bank_is_authenticated_user"
    
    var isAuthenticated: Bool {
        return defaults.bool(forKey: authKey)
    }
    
    func login(phone: String, pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Тестовая проверка для проекта
        let cleanPhone = phone.replacingOccurrences(of: " ", with: "")
        if (cleanPhone.contains("1234567") || phone.count >= 7) && pin == "1234" {
            defaults.set(true, forKey: authKey)
            completion(.success(()))
        } else {
            completion(.failure(AuthError.invalidCredentials))
        }
    }
    
    func authenticateWithBiometrics(completion: @escaping (Result<Void, Error>) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Подтвердите вход в приложение Банка"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    if success {
                        self.defaults.set(true, forKey: self.authKey)
                        completion(.success(()))
                    } else {
                        completion(.failure(AuthError.authFailed))
                    }
                }
            }
        } else {
            completion(.failure(AuthError.biometricsNotAvailable))
        }
    }
    
    func logout() {
        defaults.set(false, forKey: authKey)
    }
}

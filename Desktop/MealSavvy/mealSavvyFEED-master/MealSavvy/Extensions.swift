//
//  Extensions.swift
//  MealSavvy
//

import Foundation

extension UserDefaults {
    func user () -> UserModel? {
        guard let dict = object(forKey: Constant.user) as? [String: Any] else {
            return nil
        }
        return UserModel(JSON: dict)
    }
    
    func setUser (_ user: UserModel?) {
        guard let dict = user?.toJSON() else {
            set(nil, forKey: Constant.user)
            synchronize()
            return
        }
        
        set(dict, forKey: Constant.user)
        synchronize()
    }
}

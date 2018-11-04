//
//  RSAUtils.swift
//  MealSavvy
//

import UIKit
import Security

open class RSAUtils: NSObject {
    
    // Configuration keys
    public struct Config {
        /// Determines whether to add key hash to the keychain path when searching for a key
        /// or when adding a key to keychain
        static var useKeyHashes = true
        static let IV = "CIgyZGHh8ZvJRcoiZQL9a1IuNFhAwOgSDN6HoiQR8/SFYHQJE7/7MbOwE0dcc0yFtqk45MZXFghn+z7YuKpnS4FNJaSsQxWAQ6HkU1N98fHWWtjIevJW4MAWf2ZIL8nTn9urd3u8azIWQ+4sixpp171v+QorP8HUD+y8Vwxa4Ak="
        static let Salt = "nz8C3jDa+VT8ih0K+/gAT6NN2ALpG8sYXuEi/MBf88Uq7v26fa11bOTCN4Ff2w25U8csuY+ksXa0zVLvBaNyvOyym3pS9wfRU2c+M/oHlXUlDrHGpSq915v6PWi42+oN7g/+fhSrTGj/o7AxjA1vlMETG6TM+J14lZFEZTetrLQ="
        static let Password = "Bvqx3KSh03mLHPCNwPZUlA/0MxVa5APp423QXwCKKVDCAaFnVFij+c2AOR6U/G4/grJUZeJ67m632jSHRwLa09jW7VO/3cmqizmuOcYdEoFSeQ+2JZQRWgdJNlCUnF0ZputvdT19eckUXiaZmK1sQTy3dfnl4fzlLB2DLSW5sAg="
    }
    
    static var privateKey: String?
    static var publicKey: String?
    
    @objc
    static func getPrivateKey() -> String{
        if let key = privateKey {
            return key
        } else {
            privateKey = RSAUtils.pemKeyString(name: "swiftyrsa-private")
        }
        return privateKey ?? ""
    }
    
    @objc
    static func getPublicKey() -> String{
        if let key = publicKey {
            return key
        } else {
            publicKey = RSAUtils.pemKeyString(name: "swiftyrsa-public")
        }
        return publicKey ?? ""
    }
    
    
    //////////////
    @objc
    static open func getRSAIv() -> String {
        if let decrypted = getRSAString(Config.IV) {
            return decrypted
        }
        return ""
    }
    
    @objc
    static open func getRSASalt() -> String {
        if let decrypted = getRSAString(Config.Salt) {
            return decrypted
        }
        return ""
    }
    
    @objc
    static open func getRSAPassword() -> String {
        if let decrypted = getRSAString(Config.Password)  {
            return decrypted
        }
        return ""
    }
    
    static open func getRSAString(_ string: String) -> String? {
        let privateKey = getPrivateKey()
        if let decrypted = try? SwiftyRSA.decryptString(string, privateKeyPEM: privateKey) as String? {
            if let decryptedData = decrypted {
                return decryptedData
            } else {
                print("Unable to decrypt.")
            }
        }
        return nil
    }
    
    static open func encryptString(_ string: String) -> String? {
        let publicKey = getPublicKey()
        let encrypted = try? SwiftyRSA.encryptString(string, publicKeyPEM: publicKey)
        return encrypted
    }
    
    
    static func getKeyStringFromPEM(_ name: String) -> String {
        let bundle = Bundle.main
        
        let keyPath = bundle.path(forResource: name, ofType: "pem")!
        let keyString = try! NSString(contentsOfFile: keyPath, encoding: String.Encoding.utf8.rawValue)
        let keyArray = keyString.components(separatedBy: "\n") //Remove new line characters
        
        var keyOutput : String = ""
        
        for item in keyArray {
            if !item.contains("-----") { //Example: -----BEGIN PUBLIC KEY-----
                keyOutput += item //Join elements of the text array together as a single string
            }
        }
        return keyOutput
    }
    
    static func getIV()-> String {
        return Config.IV
    }
    
    static public func pemKeyString(name: String) -> String {
        let bundle = Bundle(for: RSAUtils.self)
        let pubPath = bundle.path(forResource: name, ofType: "pem")!
        return (try! NSString(contentsOfFile: pubPath, encoding: String.Encoding.utf8.rawValue)) as String
    }
    
    static public func derKeyData(name: String) -> Data {
        let bundle = Bundle(for: RSAUtils.self)
        let pubPath  = bundle.path(forResource: name, ofType: "der")!
        return (try! Data(contentsOf: URL(fileURLWithPath: pubPath)))
    }
}

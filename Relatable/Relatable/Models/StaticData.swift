//
//  StaticData.swift
//  Relatable
//
//  Created by Felix Izarra on 10/2/21.
//

import Foundation
import UIKit
import UIColor_FlatColors

class StaticData {
    
    static let shared = StaticData()
    
    private var _conversation: String = "" // needs to be parsed
    public static var convoPieces: [Substring] = []
    public static var parent: Bool = false
    
    public var conversation: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "conversation")
        }
        get {
            _conversation = UserDefaults.standard.string(forKey: "conversation") ?? ""
            return _conversation
        }
    }
    
    static var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
    
    static func colorForName(_ name: String) -> UIColor {
        let sanitizedName = name.replacingOccurrences(of: " ", with: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.perform(Selector(selector)).takeUnretainedValue() as! UIColor
    }
}

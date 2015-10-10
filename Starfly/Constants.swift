//
//  Constants.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit


struct Images {
    static let back = "back"
    static let forward = "forward"
    static let reload = "reload"
    static let stop = "stopLoading"
    static let home = "home"
    static let bookmark = "bookmark"
    static let bookmarkFill = "bookmarkFilled"
    static let menu = "logo"
    static let addTab = "addTab"
    static let closeTab = "closeTab"
    static let edit = "edit"
    static let image = "image"
}
func backgroundImages() -> [String]{
    var array = [String]()
    for i in 1...20{
        array.append("abs" + String(i))
    }
    return array
}
func backgroundImagesThumbnails() -> [String]{
    var array = [String]()
    for image in backgroundImages(){
        array.append(image + "_small")
    }
    return array
}
typealias SFTabWeb = SFWebVC -> Void
typealias SFContains = Bool -> Void
typealias SFNewContentLoaded = Bool -> Void
enum SFClockFace : Int {
    case analog = 1//Default
    case digital = 2
    case battery = 3
}

struct SFColors {
    static let lightBlue    = UIColor(rgba: "#03A9F4")
    static let darkBlue     = UIColor(rgba: "#2196F3")
    static let orange       = UIColor(rgba: "#FF6D00")
    static let red          = UIColor(rgba: "#FF1744")
    static let green        = UIColor(rgba: "#4CAF50")
    static let lime         = UIColor(rgba: "#CDDC39")
    static let indigo       = UIColor(rgba: "#3F51B5")
    static let pink         = UIColor(rgba: "#E91E63")
    static let cyan         = UIColor(rgba: "#00BCD4")
    static let teal         = UIColor(rgba: "#009688")
    static let grey         = UIColor(rgba: "#607D8B")
    static let dark         = UIColor(rgba: "#212121")
    static let yellow       = UIColor(rgba: "#CFA601")
    static let allColors =
        [SFColors.cyan,
        SFColors.dark,
        SFColors.darkBlue,
        SFColors.green,
        SFColors.grey,
        SFColors.indigo,
        SFColors.lightBlue,
        SFColors.lime,
        SFColors.orange,
        SFColors.pink,
        SFColors.red,
        SFColors.teal,
        SFColors.yellow]
}

enum SFWebState{
    case web
    case home
}

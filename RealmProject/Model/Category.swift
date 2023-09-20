//
//  Category.swift
//  RealmProject
//
//  Created by Ashraf Eltantawy on 18/09/2023.
//

import Foundation
import RealmSwift
class Category:Object{
    @objc dynamic var name:String=""
    let items = List<Item>()// relationship one to many
}

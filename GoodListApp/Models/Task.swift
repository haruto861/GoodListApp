//
//  Task.swift
//  GoodListApp
//
//  Created by 松島悠人 on 2021/11/03.
//

import Foundation

struct Task {
    let title: String
    let priority: Priority
}

enum Priority: Int{
    case high
    case medium
    case low
}

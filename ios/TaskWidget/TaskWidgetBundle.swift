//
//  TaskWidgetBundle.swift
//  TaskWidget
//
//  Created by Murathan Bayar on 7.03.2026.
//

import WidgetKit
import SwiftUI

@main
struct TaskWidgetBundle: WidgetBundle {
    var body: some Widget {
        TaskWidget()
        TaskWidgetControl()
    }
}

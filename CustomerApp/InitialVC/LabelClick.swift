//
//  LabelClick.swift
//  CustomerApp
//
//  Created by Apple on 13/02/19.
//  Copyright © 2019 CarOK. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class LabelButton: UILabel {
    var onClick: () -> Void = {}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onClick()
    }
}

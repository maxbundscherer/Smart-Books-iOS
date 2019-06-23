//
//  LightStatusBarExtension.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 23.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController
{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//
//  photoE.swift
//  Virtual Tourist
//
//  Created by Deema  on 18/07/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension Photo {
    
    func set(image: UIImage) {
        self.image = image.pngData()
    }
    
    func getImage() -> UIImage? {
        return (image == nil) ? nil : UIImage(data: image!)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}

//
//  CustomLabel.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 07/01/26.
//

import UIKit


//MARK: - Custom Label

class ManropeThinLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontFamily.ManropeThin.size(self.font.pointSize)
    }
}

class ManropeLightLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontFamily.ManropeLight.size(self.font.pointSize)
    }
}

class ManropeRegularLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontFamily.ManropeRegular.size(self.font.pointSize)
    }
}

class ManropeMediumLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontFamily.ManropeMedium.size(self.font.pointSize)
    }
}

class ManropeSemiBoldLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontFamily.ManropeSemiBold.size(self.font.pointSize)
    }
}

class ManropeBoldLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontFamily.ManropeBold.size(self.font.pointSize)
    }
}

class ManropeExtraBoldLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontFamily.ManropeExtraBold.size(self.font.pointSize)
    }
}




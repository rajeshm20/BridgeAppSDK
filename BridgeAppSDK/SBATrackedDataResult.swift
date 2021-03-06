//
//  SBATrackedDataResult.swift
//  BridgeAppSDK
//
//  Copyright © 2016 Sage Bionetworks. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2.  Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission. No license is granted to the trademarks of
// the copyright holders even if such marks are included in this software.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit

public class SBATrackedDataSelectionResult: ORKQuestionResult {
    
    public var selectedItems: [SBATrackedDataObject]?
    
    override init() {
        super.init()
    }
    
    public override init(identifier: String) {
        super.init(identifier: identifier)
        self.questionType = .MultipleChoice
    }
    
    // MARK: NSCoding
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectedItems = aDecoder.decodeObjectForKey("selectedItems") as? [SBATrackedDataObject]
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.selectedItems, forKey: "selectedItems")
    }
    
    // MARK: NSCopying
    
    public override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone)
        guard let result = copy as? SBATrackedDataSelectionResult else { return copy }
        result.selectedItems = self.selectedItems
        return result
    }
    
    // MARK: Equality
    
    public override func isEqual(object: AnyObject?) -> Bool {
        guard super.isEqual(object), let obj = object as? SBATrackedDataSelectionResult else { return false }
        return SBAObjectEquality(self.selectedItems, obj.selectedItems)
    }
    
    override public var hash: Int {
        return super.hash ^ SBAObjectHash(self.selectedItems)
    }

}

extension SBATrackedDataSelectionResult {
    
    public override func jsonSerializedAnswer() -> AnswerKeyAndValue? {
        // Always return a non-nil result for items
        let selectedItems: NSArray? = self.selectedItems
        let value = selectedItems?.jsonObject() ?? []
        return AnswerKeyAndValue(key: "items", value: value)
    }
    
}

//
//  SBADirectNavigationStep.swift
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

import ResearchKit

public protocol SBADirectNavigationRule: SBANavigationRule {
    var nextStepIdentifier: String? { get }
}

extension SBADirectNavigationRule {
    public func nextStepIdentifier(taskResult: ORKTaskResult, additionalTaskResults:[ORKTaskResult]?) -> String? {
        return self.nextStepIdentifier;
    }
}

extension NSDictionary: SBADirectNavigationRule {
    public var nextStepIdentifier: String? {
        return self["nextIdentifier"] as? String
    }
}

/**
 * The direct navigation step allows for a final step to be displayed with a direct
 * pointer to something other than the next step in the sequencial order defined by
 * the ORKOrderedTask steps array. (see SBAQuizFactory for example usage)
 */
public final class SBADirectNavigationStep: ORKInstructionStep, SBADirectNavigationRule, SBACustomTypeStep {
    
    /**
    * For cases where this type of step is created as a placeholder for a custom step.
    */
    public var customTypeIdentifier: String?
    
    /**
     * Pointer to the next step to show after this one. If nil, then the next step
     * is determined by the navigation rules setup by SBANavigableOrderedTask.
     */
    public var nextStepIdentifier: String?
    
    /**
     * HTML Content for the "learn more" for this step
     */
    @available(*, deprecated, message="use learnMoreAction: instead")
    public var learnMoreHTMLContent: String? {
        guard let learnMore = self.learnMoreAction?.identifier else {
            return nil
        }
        return SBAResourceFinder.sharedResourceFinder.htmlNamed(learnMore)
    }
    
    /**
     * The learn more action for this step
     */
    public var learnMoreAction: SBALearnMoreAction?
    
    override public init(identifier: String) {
        super.init(identifier: identifier)
    }
    
    public init(identifier: String, nextStepIdentifier: String?) {
        super.init(identifier: identifier)
        self.nextStepIdentifier = nextStepIdentifier
    }
    
    public init(identifier: String, customTypeIdentifier: String?) {
        super.init(identifier: identifier)
        self.customTypeIdentifier = customTypeIdentifier
    }
    
    // MARK: NSCopy
    
    override public func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone)
        guard let step = copy as? SBADirectNavigationStep else { return copy }
        step.nextStepIdentifier = self.nextStepIdentifier
        step.learnMoreAction = self.learnMoreAction
        step.customTypeIdentifier = self.customTypeIdentifier
        return step
    }
    
    // MARK: NSCoding
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.nextStepIdentifier = aDecoder.decodeObjectForKey("nextStepIdentifier") as? String
        self.learnMoreAction = aDecoder.decodeObjectForKey("learnMoreAction") as? SBALearnMoreAction
        self.customTypeIdentifier = aDecoder.decodeObjectForKey("customTypeIdentifier") as? String
    }
    
    override public func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.nextStepIdentifier, forKey: "nextStepIdentifier")
        aCoder.encodeObject(self.learnMoreAction, forKey: "learnMoreAction")
        aCoder.encodeObject(self.customTypeIdentifier, forKey: "customTypeIdentifier")
    }
    
    // MARK: Equality
    
    override public func isEqual(object: AnyObject?) -> Bool {
        guard let object = object as? SBADirectNavigationStep else { return false }
        return super.isEqual(object) &&
            SBAObjectEquality(self.nextStepIdentifier, object.nextStepIdentifier) &&
            SBAObjectEquality(self.learnMoreAction, object.learnMoreAction) &&
            SBAObjectEquality(self.customTypeIdentifier, object.customTypeIdentifier)
    }
    
    override public var hash: Int {
        return super.hash ^
            SBAObjectHash(self.nextStepIdentifier) ^
            SBAObjectHash(learnMoreAction) ^
            SBAObjectHash(self.customTypeIdentifier)
    }
}
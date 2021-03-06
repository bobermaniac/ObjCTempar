//
//  SCNonnullValidator.m
//  Scribe
//
//  Created by Victor Bryksin on 08/02/16.
//  Copyright © 2016 Victor Bryksin. All rights reserved.
//

#import "SCNonnullValidator.h"

@implementation SCNonnullValidator

- (BOOL)validateValue:(id)value ofProperty:(NSString *)property forObject:(id)object error:(NSError **)error {
    if (value) {
        return YES;
    }
    
    if (error) {
        *error = [SCValidationError validationErrorWithValidator:self];
    }
    return NO;
}

+ (instancetype)validator {
    return [[self alloc] init];
}

@end

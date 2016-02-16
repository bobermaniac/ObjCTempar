//
//  NSSet+SCImmutableCopying.m
//  Scribe
//
//  Created by Victor Bryksin on 16/02/16.
//  Copyright © 2016 Victor Bryksin. All rights reserved.
//

#import "NSSet+SCImmutableCopying.h"
#import "SCImmutableCopyingHelpers.h"

@implementation NSSet (SCImmutableCopying)

- (BOOL)isImmutable {
    return [self objectsPassingTest:^BOOL(id  _Nonnull obj, BOOL * _Nonnull stop) {
        return !SCObjectIsImmutable(obj);
    }].count == 0;
}

- (id)immutableCopyWithError:(NSError *__autoreleasing  _Nullable *)error {
    NSMutableSet *result = [NSMutableSet setWithCapacity:self.count];
    for (id obj in self) {
        id copy = SCObjectImmutableCopy(obj, error);
        if (!copy) {
            return nil;
        }
        [result addObject:copy];
    }
    return [NSSet setWithSet:result];
}

@end

@implementation NSMutableSet (SCImmutableCopying)

- (BOOL)isImmutable {
    return NO;
}

@end
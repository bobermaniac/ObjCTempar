//
//  SCImmutableCopyingHelpers.h
//  Scribe
//
//  Created by Victor Bryksin on 16/02/16.
//  Copyright © 2016 Victor Bryksin. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL SCObjectIsImmutable(id _Nullable obj);
BOOL SCEnumerableContentsAreImmutable(id<NSFastEnumeration> _Nullable enumerable);
id _Nullable SCObjectImmutableCopy(id _Nullable obj, NSError * _Nullable __autoreleasing * _Nullable error);
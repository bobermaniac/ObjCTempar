#import "ExternalHeader.h"
// Comments, comments everywhere

scribe(implement mutable, builder, archivable, tracking; make abstract)
@interface EXBase
// Even here
scribe(implement validator=SomeValidatorInstance)
@property (nonatomic, readonly, nonnull, copy) /* or here */ NSString *Id;

scribe(implement validator=SomeValidatorInstance2, validator=SomeValidatorInstance3)
@property (nonatomic, nonnull) NSString *name;

@property (nonatomic) NSNumber *counter;

scribe(implement collection)
@property (nonatomic) NSMutableDictionary<NSString*,NSString*>*someArray;
@property (nonatomic) int count;
@property (nonatomic) NSInteger count2;

@property (nonatomic) EXBase *baseRef;

@end

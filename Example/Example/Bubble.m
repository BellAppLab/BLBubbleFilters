#import "Bubble.h"


@implementation Bubble

- (instancetype)initWithIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.index = index;
    }
    return self;
}

- (NSString *)bubbleText
{
    return [NSString stringWithFormat:@"%ld",(long)self.index];
}

@synthesize bubbleState = _bubbleState;

@end

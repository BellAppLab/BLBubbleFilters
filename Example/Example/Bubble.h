#import <Foundation/Foundation.h>
#import "BLBubbleFilters.h"


@interface Bubble : NSObject <BLBubbleModel>

- (instancetype)initWithIndex:(NSInteger)index;

@property (nonatomic, assign) NSInteger index;

@end

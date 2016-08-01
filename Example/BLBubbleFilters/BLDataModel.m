//
//  BLDataModel.m
//  BLBubbleFilters
//
//  Created by André Campana on 28/07/2016.
//

#import "BLDataModel.h"


@implementation BLDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bubbleState = BLBubbleNodeStateNormal;
    }
    return self;
}

@synthesize bubbleText, bubbleIcon, bubbleBackground;
@synthesize bubbleState = _bubbleState;

- (NSString *)bubbleText
{
    return @"bubble";
}

- (SKTexture *)bubbleIcon
{
    return [SKTexture textureWithImageNamed:@"bubble"];
}

- (SKTexture *)bubbleBackground
{
    return self.background;
}

@end

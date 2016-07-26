//
//  BLBubbleNode.m
//  Pods
//
//  Created by Founders Factory on 26/07/2016.
//
//

#import "BLBubbleNode.h"


#pragma mark Typedefs
typedef NS_ENUM(NSInteger, BLBubbleNodeStateCount) {
    BLBubbleNodeStateCountFirst = BLBubbleNodeStateRemoved,
    BLBubbleNodeStateCountLast = BLBubbleNodeStateSuperHighlighted
};


#pragma mark - Main Implementation
@interface BLBubbleNode()

//Setup
@property (nonatomic, strong) NSString *text;
- (void)configure;

//State and animations
- (BLBubbleNodeState)stateForKey:(NSString *)key;
- (NSString * __nullable)animationKeyForState:(BLBubbleNodeState)state;

@end


@implementation BLBubbleNode

#pragma Convenience initialiser
- (instancetype)initWithRadius:(CGFloat)radius
                       andText:(NSString *)text
{
    if (self = [BLBubbleNode shapeNodeWithCircleOfRadius:radius]) {
        _state = BLBubbleNodeStateNormal;
        
        _text = text;
        
        CGRect boundingBox = CGPathGetBoundingBox(self.path);
        CGFloat radius = boundingBox.size.width / 2.0;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius + 1.5];
        self.fillColor = [SKColor blackColor];
        self.strokeColor = self.fillColor;
        
        [self configure];
    }
    
    return self;
}

#pragma mark Setup
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _state = [aDecoder decodeIntegerForKey:@"state"];
    _text = [aDecoder decodeObjectForKey:@"text"];
    
    return [super initWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_state
                   forKey:@"state"];
    [aCoder encodeObject:_text
                  forKey:@"text"];
    
    [super encodeWithCoder:aCoder];
}

- (void)configure
{
    _label = [SKLabelNode labelNodeWithFontNamed:@""];
    _label.text = _text;
    _label.position = CGPointZero;
    _label.fontColor = [SKColor whiteColor];
    _label.fontSize = 10;
    _label.userInteractionEnabled = NO;
    _label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [self addChild:_label];
}

#pragma mark State and animations
@synthesize state = _state;

- (void)setState:(BLBubbleNodeState)state
{
    if (_state != state) {
        //Animate
        [self runAction:[self actionForKey:[self animationKeyForState:state]]];
    }
    
    _state = state;
}

- (SKAction *)actionForKey:(NSString *)key
{
    BLBubbleNodeState state = [self stateForKey:key];
    if (state != BLBubbleNodeStateInvalid) {
        switch (state) {
            case BLBubbleNodeStateNormal:
                return [SKAction scaleTo:1.0
                                duration:0.2];
            case BLBubbleNodeStateHighlighted:
                return [SKAction scaleTo:1.3
                                duration:0.2];
            case BLBubbleNodeStateSuperHighlighted:
                return [SKAction scaleTo:2.0
                                duration:0.2];
            case BLBubbleNodeStateRemoved:
                return [SKAction fadeOutWithDuration:0.2];
            default:
                break;
        }
    }
    
    [super actionForKey:key];
}

- (void)removeFromParent
{
    SKAction *action = [self actionForKey:[self animationKeyForState:BLBubbleNodeStateRemoved]];
    if (action) {
        [self runAction:action
             completion:^
        {
            [super removeFromParent];
        }];
        return;
    }
    [super removeFromParent];
}

- (BLBubbleNodeState)stateForKey:(NSString *)key
{
    for (int i=(int)BLBubbleNodeStateCountFirst; i<(int)BLBubbleNodeStateCountLast + 1; i++) {
        if ([self animationKeyForState:(NSInteger)i]) {
            return i;
        }
    }
    return BLBubbleNodeStateInvalid;
}

- (NSString * __nullable)animationKeyForState:(BLBubbleNodeState)state
{
    switch (state) {
        case BLBubbleNodeStateRemoved:
            return @"BLBubbleNodeStateRemoved";
        case BLBubbleNodeStateNormal:
            return @"BLBubbleNodeStateNormal";
        case BLBubbleNodeStateHighlighted:
            return @"BLBubbleNodeStateNormal";
        case BLBubbleNodeStateSuperHighlighted:
            return @"BLBubbleNodeStateNormal";
        default:
            return nil;
    }
}

@end

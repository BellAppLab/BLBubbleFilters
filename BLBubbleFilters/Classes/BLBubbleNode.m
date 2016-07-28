//
//  BLBubbleNode.m
//  Pods
//
//  Created by Founders Factory on 26/07/2016.
//
//

#import "BLBubbleNode.h"


#pragma mark Consts
#define IconPercentualInset 0.4


#pragma mark Private Interface
@interface BLBubbleNode()

//Setup
@property (nonatomic, strong) NSString *text;
- (void)configure;

//UI
@property (nonatomic, strong) SKCropNode *backgroundNode;
@property (nonatomic, strong) SKSpriteNode *icon;

//State and animations
- (BLBubbleNodeState)stateForKey:(NSString *)key;
- (NSString * __nullable)animationKeyForState:(BLBubbleNodeState)state;

@end


#pragma mark - Main Implementation
@implementation BLBubbleNode

#pragma Convenience initialiser
- (instancetype)initWithRadius:(CGFloat)radius
                       andText:(NSString *)text
{
    if (self = [BLBubbleNode shapeNodeWithCircleOfRadius:radius]) {
        _state = BLBubbleNodeStateNormal;
        _text = text;
        
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
    self.name = @"bubble";
    
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1.5 + CGPathGetBoundingBox(self.path).size.width / 2.0];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = 0.3;
    self.physicsBody.friction = 0.0;
    self.physicsBody.linearDamping = 3;
    
    _backgroundNode = [[SKCropNode alloc] init];
    _backgroundNode.userInteractionEnabled = NO;
    _backgroundNode.position = CGPointZero;
    _backgroundNode.zPosition = 0;
    [self addChild:_backgroundNode];
    
    _label = [SKLabelNode labelNodeWithFontNamed:@""];
    _label.text = _text;
    _label.position = CGPointZero;
    _label.fontColor = [SKColor whiteColor];
    _label.fontSize = 10;
    _label.userInteractionEnabled = NO;
    _label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _label.zPosition = 2;
    [self addChild:_label];
}

- (void)setBackgroundImage:(SKTexture *)backgroundImage
{
    if (backgroundImage) {
        //We're defaulting to an aspect fill rendering mode
        //We have to do it manually though
        CGSize imageSize;
        CGFloat radius;
        if (backgroundImage.size.width < backgroundImage.size.height) { //Portrait
            CGFloat percentage = 1 + (self.frame.size.width - backgroundImage.size.width) / backgroundImage.size.width;
            imageSize = CGSizeMake(self.frame.size.width, backgroundImage.size.height * percentage);
            radius = self.frame.size.width;
        } else {
            CGFloat percentage = 1 + (self.frame.size.height - backgroundImage.size.height) / backgroundImage.size.height;
            imageSize = CGSizeMake(backgroundImage.size.width * percentage, self.frame.size.height);
            radius = self.frame.size.height;
        }
        
        SKNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:backgroundImage
                                                            size:imageSize];
        spriteNode.userInteractionEnabled = NO;
        spriteNode.position = CGPointZero;
        spriteNode.zPosition = 0;
        
        SKShapeNode *maskNode = [SKShapeNode shapeNodeWithCircleOfRadius:radius / 2.0];
        maskNode.position = CGPointZero;
        maskNode.userInteractionEnabled = NO;
        //If we don't set these colors, bad things happen
        maskNode.fillColor = [UIColor blackColor];
        maskNode.strokeColor = [UIColor clearColor];
        
        _backgroundNode.maskNode = maskNode;
        [_backgroundNode addChild:spriteNode];
    } else {
        _backgroundNode.maskNode = nil;
        [_backgroundNode removeAllChildren];
    }
}

- (void)setIconImage:(SKTexture *)iconImage
{
    if (iconImage) {
        //We're defaulting to an aspect fill rendering mode
        //We have to do it manually though
        //The icon size is also set to 40% of the bubble's width
        CGSize imageSize;
        if (iconImage.size.width < iconImage.size.height) { //Portrait
            CGFloat percentage = 1 + (self.frame.size.width - iconImage.size.width) / iconImage.size.width;
            imageSize = CGSizeMake(self.frame.size.width * IconPercentualInset, iconImage.size.height * percentage * IconPercentualInset);
        } else {
            CGFloat percentage = 1 + (self.frame.size.height - iconImage.size.height) / iconImage.size.height;
            imageSize = CGSizeMake(iconImage.size.width * percentage * IconPercentualInset, self.frame.size.height * IconPercentualInset);
        }
        
        _icon = [[SKSpriteNode alloc] initWithTexture:iconImage
                                                color:[UIColor clearColor]
                                                 size:imageSize];
        _icon.userInteractionEnabled = NO;
        _icon.zPosition = 1;
    } else {
        [_icon removeFromParent];
        _icon = nil;
    }
}


#pragma mark State and animations
@synthesize state = _state;

- (void)setState:(BLBubbleNodeState)state
{
    if (_state != state) {
        //Animate
        [self removeAllActions];
        [self runAction:[self actionForKey:[self animationKeyForState:state]]];
    }
    
    _state = state;
}

- (SKAction *)actionForKey:(NSString *)key
{
    BLBubbleNodeState state = [self stateForKey:key];
    if (state != BLBubbleNodeStateInvalid) {
        __weak typeof(self) weakSelf = self;
        switch (state) {
            case BLBubbleNodeStateNormal:
                return [SKAction group:@[[SKAction scaleTo:1.0 duration:0.2], [SKAction runBlock:^{
                    [[weakSelf icon] removeFromParent];
                    [weakSelf label].position = CGPointZero;
                }]]];
            case BLBubbleNodeStateHighlighted:
                return [SKAction group:@[[SKAction scaleTo:1.3 duration:0.2], [SKAction runBlock:^{
                    if ([weakSelf icon]) {
                        [weakSelf addChild:[weakSelf icon]];
                        [weakSelf icon].position = CGPointMake(0, [weakSelf icon].size.height * IconPercentualInset);
                        [weakSelf label].position = CGPointMake(0, -[weakSelf icon].size.height * IconPercentualInset);
                    }
                }]]];
            case BLBubbleNodeStateSuperHighlighted:
                return [SKAction scaleTo:1.8
                                duration:0.2];
            case BLBubbleNodeStateRemoved:
            {
                SKAction *disappear = [SKAction fadeOutWithDuration:0.2];
                SKAction *explode = [SKAction scaleTo:1.2
                                             duration:0.2];
                SKAction *remove = [SKAction removeFromParent];
                return [SKAction sequence:@[[SKAction group:@[disappear, explode]], remove]];
            }
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
        if ([[self animationKeyForState:(NSInteger)i] isEqualToString:key]) {
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
            return @"BLBubbleNodeStateHighlighted";
        case BLBubbleNodeStateSuperHighlighted:
            return @"BLBubbleNodeStateSuperHighlighted";
        default:
            return nil;
    }
}


#pragma mark Aux
- (BLBubbleNodeState)nextState
{
    switch (self.state) {
        case BLBubbleNodeStateNormal:
            return BLBubbleNodeStateHighlighted;
        case BLBubbleNodeStateHighlighted:
            return BLBubbleNodeStateSuperHighlighted;
        case BLBubbleNodeStateSuperHighlighted:
            return BLBubbleNodeStateNormal;
        default:
            break;
    }
}

@end

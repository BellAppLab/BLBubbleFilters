//
//  BLBubbleNode.m
//  Pods
//
//  Created by Founders Factory on 26/07/2016.
//
//

#import "BLBubbleNode.h"


#pragma mark Private Interface
@interface BLBubbleNode()

//Setup
@property (nonatomic, strong) NSString *text;
- (void)configure;

//UI
@property (nonatomic, strong) SKCropNode *backgroundImage;
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
    
    _backgroundImage = [[SKCropNode alloc] init];
    _backgroundImage.userInteractionEnabled = NO;
    _backgroundImage.position = CGPointZero;
    _backgroundImage.zPosition = 0;
    [self addChild:_backgroundImage];
    
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
    
    _icon = [[SKSpriteNode alloc] init];
    _icon.userInteractionEnabled = NO;
    _icon.zPosition = 1;
}

- (void)setBackgroundImage:(SKTexture *)backgroundImage
{
    if (backgroundImage) {
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
        maskNode.fillColor = [UIColor blackColor];
        maskNode.strokeColor = [UIColor clearColor];
        _backgroundImage.maskNode = maskNode;
        [_backgroundImage addChild:spriteNode];
        _backgroundImage.alpha = 0.5;
    } else {
        _backgroundImage.maskNode = nil;
        [_backgroundImage removeFromParent];
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
                    [weakSelf addChild:[weakSelf icon]];
                    [weakSelf icon].position = CGPointMake(0, -[weakSelf icon].size.height / 2.0);
                    [weakSelf label].position = CGPointMake(0, [weakSelf icon].size.height / 2.0);
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

#import "BLBubbleNode.h"
#import "BLConsts.h"


#pragma mark Private Interface
@interface BLBubbleNode()

//Setup
- (void)configure;

//UI
- (void)setBackgroundImage:(SKTexture * __nullable)backgroundImage;
- (void)setIconImage:(SKTexture * __nullable)iconImage;
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
{
    self = [BLBubbleNode shapeNodeWithCircleOfRadius:radius];
    if (self) {
        _state = BLBubbleNodeStateInvalid;
        
        [self configure];
    }
    
    return self;
}

#pragma mark Setup
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _state = [aDecoder decodeIntegerForKey:@"state"];
    
    return [super initWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_state
                   forKey:@"state"];
    
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
    _label.position = CGPointZero;
    _label.fontColor = [SKColor whiteColor];
    _label.fontSize = 10;
    _label.userInteractionEnabled = NO;
    _label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _label.zPosition = 2;
    [self addChild:_label];
}

#pragma mark Data Model
- (void)setModel:(id<BLBubbleModel>)model
{
    _model = model;
    
    _label.text = [model bubbleText];
    
    if ([model respondsToSelector:@selector(bubbleIcon)]) {
        [self setIconImage:[model bubbleIcon]];
    }
    
    if ([model respondsToSelector:@selector(bubbleBackground)]) {
        [self setBackgroundImage:[model bubbleBackground]];
    }
    
    [self setState:[model bubbleState]];
    //Order here is very important!
    //Upon calling setState:, we need to have the other properties set so to place elements correctly in the bubble
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
@synthesize label = _label;

- (void)setState:(BLBubbleNodeState)state
{
    if (_state != state) {
        //Animate
        [self removeAllActions];
        [_icon removeAllActions];
        [_label removeAllActions];
        [self runAction:[self actionForKey:[self animationKeyForState:state]]];
        self.model.bubbleState = state;
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
                return [SKAction group:@[[SKAction scaleTo:1.0 duration:AnimationDuration], [SKAction runBlock:^{
                    [[weakSelf icon] runAction:[SKAction fadeOutWithDuration:AnimationDuration] completion:^{
                        [[weakSelf icon] removeFromParent];
                    }];
                    [[weakSelf label] runAction:[SKAction group:@[[SKAction moveTo:CGPointZero duration:AnimationDuration], [SKAction scaleTo:1.0 duration:AnimationDuration]]]];
                }]]];
            case BLBubbleNodeStateHighlighted:
                return [SKAction group:@[[SKAction scaleTo:1.3 duration:AnimationDuration], [SKAction runBlock:^{
                    if ([weakSelf icon] && [[weakSelf icon] parent] == nil) {
                        [weakSelf addChild:[weakSelf icon]];
                        [weakSelf icon].position = CGPointMake(0, [weakSelf icon].size.height * (IconPercentualInset / 2.0));
                        [[weakSelf icon] runAction:[SKAction fadeInWithDuration:AnimationDuration]];
                        [[weakSelf label] runAction:[SKAction group:@[[SKAction scaleTo:0.9 duration:AnimationDuration], [SKAction moveTo:CGPointMake(0, -[weakSelf label].frame.size.height * 1.5) duration:AnimationDuration]]]];
                    } else {
                        [[weakSelf label] runAction:[SKAction group:@[[SKAction scaleTo:0.9 duration:AnimationDuration], [SKAction moveTo:CGPointMake(0, -[weakSelf label].frame.size.height * 1.5) duration:AnimationDuration]]]];
                    }
                }]]];
            case BLBubbleNodeStateSuperHighlighted:
                return [SKAction group:@[[SKAction scaleTo:1.8 duration:AnimationDuration], [SKAction runBlock:^{
                    if ([weakSelf icon] && [weakSelf icon].parent == nil) {
                        [weakSelf addChild:[weakSelf icon]];
                        [weakSelf icon].position = CGPointMake(0, [weakSelf icon].size.height * (IconPercentualInset / 2.0));
                        [[weakSelf icon] runAction:[SKAction fadeInWithDuration:AnimationDuration]];
                        [[weakSelf label] runAction:[SKAction group:@[[SKAction scaleTo:0.7 duration:AnimationDuration], [SKAction moveTo:CGPointMake(0, -[weakSelf label].frame.size.height * 1.5) duration:AnimationDuration]]]];
                    } else {
                        [[weakSelf label] runAction:[SKAction group:@[[SKAction scaleTo:0.7 duration:AnimationDuration], [SKAction moveTo:CGPointMake(0, -[weakSelf label].frame.size.height * 1.5) duration:AnimationDuration]]]];
                    }
                }]]];
            case BLBubbleNodeStateRemoved:
            {
                SKAction *disappear = [SKAction fadeOutWithDuration:AnimationDuration];
                SKAction *explode = [SKAction scaleTo:1.2
                                             duration:AnimationDuration];
                SKAction *remove = [SKAction removeFromParent];
                return [SKAction sequence:@[[SKAction group:@[disappear, explode]], remove]];
            }
            default:
                break;
        }
    }
    
    return [super actionForKey:key];
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
            return BLBubbleNodeStateInvalid;
    }
}

@end

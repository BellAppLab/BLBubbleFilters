//
//  BLBubbleScene.m
//  Pods
//
//  Created by Founders Factory on 26/07/2016.
//
//

#import "BLBubbleScene.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

#pragma mark Private Aux Functions
CGFloat getRandomCGFloat() {
    return (CGFloat)((float)arc4random() / 0xFFFFFFFF);
};

CGFloat getRandomCGFloatWith(CGFloat min, CGFloat max) {
    return getRandomCGFloat() * (max - min) + min;
};


#pragma mark Consts
#define PanThreshold 0.001
#define LongPressThreshold 2.0


#pragma mark Private Interface
@interface BLBubbleScene()

//Setup
- (void)configure;

//Handling touches
@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, weak) NSTimer *touchTimer;
@property (nonatomic, assign) BOOL touchesMoved;
- (BLBubbleNode * __nullable)bubbleAtTouchPoint;
- (void)handleLongPressTimer:(NSTimer *)timer;

//Nodes
@property (nonatomic, assign) CGFloat pushStrength;
@property (nonatomic, strong) NSMutableArray *bubbles;
@property (nonatomic, strong) NSMutableDictionary *colors;
- (CGPoint)randomPositionWithRadius:(CGFloat)radius;
- (void)updateBubble:(BLBubbleNode *)bubble
             toState:(BLBubbleNodeState)nextState;

@end


#pragma mark - Main Implementation
@implementation BLBubbleScene

#pragma mark Setup
- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.pushStrength = 10000;
    self.touchPoint = CGPointZero;
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    _magneticField = [SKFieldNode radialGravityField];
    _magneticField.region = [[SKRegion alloc] initWithRadius:10000];
    _magneticField.minimumRadius = 10000;
    _magneticField.strength = 8000;
    _magneticField.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:_magneticField];
    
    CGRect bodyFrame = self.frame;
    bodyFrame.size.width = _magneticField.minimumRadius;
    bodyFrame.origin.x -= bodyFrame.size.width / 2.0;
    bodyFrame.size.height = self.size.height;
    bodyFrame.origin.y = self.frame.size.height - bodyFrame.size.height;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bodyFrame];
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [self reload];
}


#pragma mark Loading
- (void)reload
{
    //Resetting stuff
    _bubbles = [NSMutableArray new];
    _colors = [NSMutableDictionary new];
    
    NSInteger numberOfBubbles = [self.bubbleDataSource numberOfBubbles];
    
    //Getting colours
    if ([self.bubbleDataSource respondsToSelector:@selector(bubbleColorForState:)]) {
        SKColor *color;
        for (int i=(int)BLBubbleNodeStateCountFirst; i<(int)BLBubbleNodeStateCountLast + 1; i++) {
            color = [self.bubbleDataSource bubbleColorForState:(NSInteger)i];
            //We default to a clear colour if the delegate hasn't implemented all items in the BLBubbleNodeState enum
            [_colors setObject:color ? color : [UIColor clearColor]
                        forKey:@(i)];
        }
    }
    
    //Getting the font
    NSString *fontName = [self.bubbleDataSource respondsToSelector:@selector(bubbleFont)] ? [self.bubbleDataSource bubbleFontName] : @"";
    
    //Getting the text colour
    SKColor *textColour = [self.bubbleDataSource respondsToSelector:@selector(bubbleTextColor)] ? [self.bubbleDataSource bubbleTextColor] : [UIColor whiteColor];
    
    //Creating bubbles
    CGFloat radius = [self.bubbleDataSource respondsToSelector:@selector(bubbleRadius)] ? [self.bubbleDataSource bubbleRadius] : 30.0;
    BLBubbleNode *node = nil;
    for (int i=0; i<numberOfBubbles; i++) {
        node = [[BLBubbleNode alloc] initWithRadius:radius
                                            andText:[self.bubbleDataSource textForBubbleAtIndex:(NSInteger)i]];
        
        //making the bubble beautiful
        node.label.fontColor = textColour;
        node.label.fontName = fontName;
        [node setColor:[_colors objectForKey:@(BLBubbleNodeStateNormal)]];
        
        //Tucking the bubble in
        [_bubbles addObject:node];
        node.position = [self randomPositionWithRadius:radius];
        [self addChild:node];
    }
}


#pragma mark Nodes
- (CGPoint)randomPositionWithRadius:(CGFloat)radius
{
    CGFloat diameter = radius * 2.0;
    CGFloat x = (_bubbles.count % 2 == 0 || _bubbles.count == 0) ? getRandomCGFloatWith(self.frame.size.width + diameter, self.frame.size.width + 50) : getRandomCGFloatWith(-50, -diameter);
    CGFloat y = getRandomCGFloatWith(-50, self.frame.size.height - 50 - diameter);
    return CGPointMake(x, y);
}

- (SKNode *)nodeAtPoint:(CGPoint)p
{
    SKNode *result = [super nodeAtPoint:p];
    
    while (![result.parent isKindOfClass:[SKScene class]] && ![result isKindOfClass:[BLBubbleNode class]] && result.parent != nil && !result.userInteractionEnabled) {
        result = result.parent;
    }
    
    return result;
}

- (void)updateBubble:(BLBubbleNode *)bubble
             toState:(BLBubbleNodeState)nextState
{
    NSInteger index = [self.bubbles indexOfObject:bubble];
    if (index == NSNotFound) return;
    if (nextState == BLBubbleNodeStateInvalid) return;
    
    bubble.state = nextState;
    SKColor *color = [self.colors objectForKey:@(nextState)];
    if (!color) color = bubble.strokeColor;
    [bubble runAction:[SKAction runBlock:^{
        [bubble setColor:color];
    }]];
    [self.bubbleDelegate didSelectBubble:bubble
                                 atIndex:index];
}


#pragma mark Handling touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent * __nullable)event
{
    UITouch *touch = [touches anyObject];
    if (!touch) return;
    
    self.touchPoint = [touch locationInNode:self];
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:LongPressThreshold
                                                       target:self
                                                     selector:@selector(handleLongPressTimer:)
                                                     userInfo:nil
                                                      repeats:NO];
    self.touchesMoved = NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent * __nullable)event
{
    UITouch *touch = [touches anyObject];
    if (!touch) return;
    
    CGPoint plin = [touch previousLocationInNode:self];
    CGPoint lin = [touch locationInNode:self];
    CGFloat dx = lin.x - plin.x;
    CGFloat dy = lin.y - plin.y;
    CGFloat b = sqrt(pow(lin.x, 2) + pow(lin.y, 2));
    dx = b == 0 ? 0 : (dx / b);
    dy = b == 0 ? 0 : (dy / b);
    
    if (dx == 0 && dy == 0) {
        return;
    }
    
    //We're not treating the touch events as a move when deltas are below our threshold (in module)
    //This is so taps, long presses and pans don't interfere with each other
    CGFloat tx = dx < 0 ? -dx : dx;
    CGFloat ty = dy < 0 ? -dy : dy;
    if (tx < PanThreshold && ty < PanThreshold) {
        return;
    }
    
    self.touchesMoved = YES;
    
    CGFloat w, h;
    CGVector direction;
    for (SKNode *node in self.bubbles) {
        w = node.frame.size.width;
        h = node.frame.size.height;
        direction = CGVectorMake(self.pushStrength * dx, self.pushStrength * dy);
        
        //Not going out of bounds
        if ((-w >= node.position.x || self.size.width + w <= node.position.x) && (node.position.x * dx > 0)) {
            direction.dx = 0;
        }
        if ((-h >= node.position.y || self.size.width + h <= node.position.y) && (node.position.y * dy > 0)) {
            direction.dy = 0;
        }
        
        [node.physicsBody applyForce:direction];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent * __nullable)event
{
    //We're not processing this touch as a tap or a long press if a pan has been recognized
    if (self.touchesMoved) return;
    
    BLBubbleNode *bubble = [self bubbleAtTouchPoint];
    self.touchPoint = CGPointZero;
    self.touchesMoved = NO;
    if (!bubble) return;
    
    [self updateBubble:bubble
               toState:[bubble nextState]];
}

- (void)touchesCancelled:(NSSet<UITouch *> * __nullable)touches
               withEvent:(UIEvent * __nullable)event
{
    //Resetting stuff
    self.touchPoint = CGPointZero;
    self.touchesMoved = NO;
}

- (BLBubbleNode * __nullable)bubbleAtTouchPoint
{
    if (self.touchPoint.x == 0 && self.touchPoint.y == 0) return nil;
    
    id bubble = [self nodeAtPoint:self.touchPoint];
    if (![bubble isKindOfClass:[BLBubbleNode class]]) return nil;
    
    return bubble;
}

- (void)handleLongPressTimer:(NSTimer *)timer
{
    [timer invalidate];
    
    //We're not processing this touch if a pan has been recognized
    if (self.touchesMoved) return;
    
    BLBubbleNode *bubble = [self bubbleAtTouchPoint];
    self.touchPoint = CGPointZero;
    self.touchesMoved = NO;
    if (!bubble) return;
    
    //If the touch lasted for more than our threshold, we treat it as a long press
    [self updateBubble:bubble
               toState:BLBubbleNodeStateRemoved];
}

@end

NS_ASSUME_NONNULL_END
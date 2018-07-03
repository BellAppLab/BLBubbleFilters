/*
 MIT License
 
 Copyright (c) 2018 Bell App Lab
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <SpriteKit/SpriteKit.h>
#import "BLBubbleNode.h"


NS_ASSUME_NONNULL_BEGIN
@class BLBubbleScene;


#pragma mark Delegate
/**
 This is how you get notified when the user interacts with the bubbles in your scene.
 
 @see   `BLBubbleSceneDataSource`
 */
@protocol BLBubbleSceneDelegate <NSObject>
/**
 Whenever the user taps a bubble, or long presses it, the Bubble Delegate gets notified.
 
 @param scene   The Bubble Scene that generated the interaction
 @param bubble  The bubble that was tapped or long pressed
 @param index   The index of the bubble
 
 @remark    If you want to know the bubble's status after the interaction (eg. to know if it has been popped), inspect the bubble's `state` property.
 
 @see   `BLBubbleNodeState`
 */
- (void)bubbleScene:(BLBubbleScene *)scene
    didSelectBubble:(BLBubbleNode *)bubble
            atIndex:(NSInteger)index;
@end


#pragma mark Data Source
/**
 This is how you tell your Bubble Scene how many bubbles to present, their attributes and all that.
 
 @see   `BLBubbleSceneDelegate`
 */
@protocol BLBubbleSceneDataSource <NSObject>
/**
 Tells the Bubble Scene to create this number of bubbles
 
 @param scene   The Bubble Scene eager to know how many bubbles to present
 */
- (NSInteger)numberOfBubblesInBubbleScene:(BLBubbleScene *)scene;

/**
 This is how you bind your bubbles and the data model associated with them.
 
 @param scene   The Bubble Scene eager to get data models for its bubbles
 @param index   The bubble's index
 @returns   An object conforming to the `BLBubbleModel` protocol
 
 @see   `BLBubbleModel`
 */
- (id<BLBubbleModel>)bubbleScene:(BLBubbleScene *)scene
           modelForBubbleAtIndex:(NSInteger)index;

@optional

/**
 Tells the Bubble Scene the background colour to set on the bubbles
 
 @param scene   The Bubble Scene that wants background colours
 @param state   The state of the bubble this background colour is to be applied on
 @returns   An SKColor instance for the background colour or nil
 
 @note  This is optional
 
 @remark    We're *not* supporting different colours based both on the bubble's index and state at the moment
 
 @see `BLBubbleNodeState`
 */
- (SKColor * __nullable)bubbleScene:(BLBubbleScene *)scene
            bubbleFillColorForState:(BLBubbleNodeState)state;

/**
 Tells the Bubble Scene the stroke colour to set on the bubbles
 
 @param scene   The Bubble Scene that wants stroke colours
 @param state   The state of the bubble this stroke colour is to be applied on
 @returns   An SKColor instance for the stroke colour or nil
 
 @note  This is optional
 
 @remark    We're *not* supporting different colours based both on the bubble's index and state at the moment
 
 @see `BLBubbleNodeState`
 */
- (SKColor * __nullable)bubbleScene:(BLBubbleScene *)scene
          bubbleStrokeColorForState:(BLBubbleNodeState)state;

/**
 Tells the Bubble Scene the text colour to set on the bubbles
 
 @param scene   The Bubble Scene that wants text colours
 @param state   The state of the bubble this text colour is to be applied on
 @returns   An SKColor instance for the text colour or nil
 
 @note  This is optional
 
 @remark    We're *not* supporting different colours based both on the bubble's index and state at the moment
 
 @see `BLBubbleNodeState`
 */
- (SKColor * __nullable)bubbleScene:(BLBubbleScene *)scene
            bubbleTextColorForState:(BLBubbleNodeState)state;

/**
 Tells the Bubble Scene the name of the font to set on the bubbles
 
 @param scene   The Bubble Scene that wants font names
 @returns   A valid font name to be used by the bubble
 
 @note  This is optional
 
 @remark    We're *not* supporting different font names based on the bubble's index or state at the moment
 */
- (NSString *)bubbleFontNameForBubbleScene:(BLBubbleScene *)scene;

/**
 Tells the Bubble Scene the font size to use on bubbles' text
 
 @param scene   The Bubble Scene that wants font names
 @returns   The bubble's font size
 
 @note  This is optional
 
 @remark    We're *not* supporting different font sizes based on the bubble's index or state at the moment
 */
- (CGFloat)bubbleFontSizeForBubbleScene:(BLBubbleScene *)scene;

/**
 Tells the Bubble Scene the bubbles' radii
 
 @param scene   The Bubble Scene that wants radii
 @returns   The bubble's radius
 
 @note  This is optional
 
 @remark    We're *not* supporting different radii based on the bubble's index or state at the moment
 */
- (CGFloat)bubbleRadiusForBubbleScene:(BLBubbleScene *)scene;

@end

   
#pragma mark - Main Class
/**
 This is the main point of interaction to present bubbles in your app. A `BLBubbleScene` is a subclass of `SKScene` a typical implementation of it would go something like this:
 
 ```
 - (void)viewWillAppear:(BOOL)animated
 {
    [super viewWillAppear:animated];
 
    BLBubbleScene *scene = [BLBubbleScene sceneWithSize:self.view.frame.size];
    scene.bubbleDataSource = self;
    scene.bubbleDelegate = self;
 
    [(SKView *)self.view presentScene:scene];
 }
 ```
 
 @warning   We encourage developers to create the scene on the `viewWillAppear` View Controller phase, so that all views' dimensions and element sizes have been calculated already
 */
@interface BLBubbleScene : SKScene

/**
 Delegate and Data Source
 
 This is how the Bubble Scene knows how to create its bubbles
 
 @see   `BLBubbleSceneDelegate`
 @see   `BLBubbleSceneDataSource`
 */
@property (nonatomic, weak) id<BLBubbleSceneDelegate> __nullable bubbleDelegate;
@property (nonatomic, weak) id<BLBubbleSceneDataSource> __nullable bubbleDataSource;

/**
 This is where the Bubble Scene calls its data source, calculates everything it needs to calculate and presents its bubbles.
 
 @note  If you need to redraw your bubbles, this is the method to call.
 */
- (void)reload;

/**
 The Bubble Scene's bubbles are basically objects floating on a magnetic field. Here we expose such field so its properties can be tweaked if need be.
 
 @see   `SKFieldNode`
 */
@property (nonatomic, readonly) SKFieldNode *magneticField;

@end

NS_ASSUME_NONNULL_END

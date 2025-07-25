//
//  SatinImage.h
//  satin
//
//  Created by Jen Beaven on 1/5/11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"

@interface SatinImage : UIView {
	UIImage * image;
	UIImage * imageover;
	UIImage * lastimage;
	
	CGPoint startTouch;
	CGPoint endTouch;
	
	CGContextRef	mBitmapContext;

	CALayer * tileLayer;
	
	CGFloat sat;
	
	BOOL clearMe;
	BOOL tiling;
	BOOL haslayer;
	BOOL redraw;
	BOOL nothing;
	BOOL alter;
	BOOL drawover;
	BOOL twirling1;
	BOOL twirling2;
	
	enum gradientType {
        GRAD_LINEAR,
		GRAD_RADIAL,
        GRAD_DIAMOND,
		GRAD_PATH,
		GRAD_REFLECT,
		GRAD_TWIRL
    } gradient;
	
	enum changeType {
        CHANGE_GRADIENT,
		CHANGE_RADIAL,
        CHANGE_DIAMOND,
		CHANGE_PATH,
		CHANGE_TILE,
		CHANGE_KALEIDOSCOPE,
		CHANGE_TWIRL
    } change;
	

}

@property (nonatomic, assign) CGFloat sat;
@property (nonatomic, assign) BOOL twirling1;
@property (nonatomic, assign) BOOL twirling2;
@property (nonatomic, retain) UIImage *lastimage;
@property (nonatomic, assign) BOOL haslayer;
@property (nonatomic, retain) CALayer *tileLayer;
@property (nonatomic, assign) CGContextRef mBitmapContext;
@property (nonatomic, assign) BOOL drawover;
@property (nonatomic, assign) BOOL nothing;
@property (nonatomic, retain) UIImage *imageover;
@property (nonatomic, assign) BOOL redraw;
@property (nonatomic, assign) BOOL tiling;
@property (nonatomic, assign) BOOL alter;
@property (nonatomic, assign) CGPoint startTouch;
@property (nonatomic, assign) CGPoint endTouch;
@property (nonatomic, assign) BOOL clearMe;
@property (nonatomic, assign) enum gradientType gradient;
@property (nonatomic, assign) enum changeType change;

@property (nonatomic, retain) UIImage *image;

-(IBAction)tileImage:(id)sender;
-(UIImage *)reflectedImage:(UIImage *)fromImage w:(CGFloat)w h:(CGFloat)h xScale:(CGFloat)xScale yScale:(CGFloat)yScale;
-(void)drawDiamond:(CGRect)rect grad:(CGGradientRef)grad len:(CGFloat)len;
-(void)rotateTo:(UIImageOrientation)orientation;
-(UIImage*)rotate:(UIImage* )src orientation:(UIImageOrientation)orientation;
-(UIImage *)rotatedScaledImage:(UIImage *)fromImage angle:(CGFloat)angle scale:(CGFloat)scale ;
-(CALayer *)rotatedScaledLayer:(CALayer *)fromLayer angle:(CGFloat)angle scale:(CGFloat)scale; 

-(UIImage *)snapLayer:(CALayer *)inLayer;
-(UIImage *)twirlLayer:(CALayer *)inLayer;

-(CGPoint)gradPoint:(CGPoint)inPoint;

-(void)ripple;

@end

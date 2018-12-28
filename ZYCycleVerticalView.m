//
//  ZYCycleVerticalView.m
//  CycleVerticalView
//
//  Created by  on 18/12/28.
//  Copyright © 2018年  All rights reserved.
//

#import "ZYCycleVerticalView.h"

@implementation ZYCycleVerticalView{
    CGRect          _topRect;
    CGRect          _middleRect;
    CGRect          _btmRect;
    NSInteger       _indexNow;
    
    CGRect          _leftRect;
    CGRect          _rightRect;
    
    double          _showTime;
    double          _animationTime;
    ZYCycleVerticalViewScrollDirection  _direction;

    UIButton        *_button;
    
    NSMutableArray  *_animationViewArray;
    NSTimer         *_timer;
    
    UILabel *_tmpAnimationView1;
    UILabel *_tmpAnimationView2;
    
    UILabel *_tmpTopView;
    UILabel *_tmpBtmView;
    UILabel *_tmpLeftView;
    UILabel *_tmpRightView;
    UILabel *_tmpMiddleView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _showTime = 3;
        _animationTime = 0.5;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _middleRect = self.bounds;
    _topRect = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    _btmRect = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    _leftRect = CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    _rightRect = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    
    _tmpAnimationView1 = [[UILabel alloc] initWithFrame:_middleRect];
    _tmpAnimationView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tmpAnimationView1];
    
    _tmpAnimationView2 = [[UILabel alloc] init];
    _tmpAnimationView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tmpAnimationView2];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = [UIColor clearColor];
    _button.frame = _middleRect;
    [_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    _animationViewArray = [NSMutableArray array];
    [_animationViewArray addObject:_tmpAnimationView1];
    [_animationViewArray addObject:_tmpAnimationView2];
    self.clipsToBounds = YES;
}

- (void)configureShowTime:(double)showTime
            animationTime:(double)animationTime
                direction:(ZYCycleVerticalViewScrollDirection)direction
          backgroundColor:(UIColor *)backgroundColor
                textColor:(UIColor *)textColor font:(UIFont *)font
            textAlignment:(NSTextAlignment)textAlignment{
    _showTime = showTime;
    _animationTime = animationTime;
    _direction = direction;
    _tmpAnimationView1.backgroundColor = _tmpAnimationView2.backgroundColor = backgroundColor;
    _tmpAnimationView1.textColor = _tmpAnimationView2.textColor = textColor;
    _tmpAnimationView1.font = _tmpAnimationView2.font = font;
    _tmpAnimationView1.textAlignment = _tmpAnimationView2.textAlignment = textAlignment;
//    _tmpAnimationView2.frame = _direction == ZYCycleVerticalViewScrollDirectionDown ? _topRect : _btmRect;
    _tmpAnimationView2.frame = _direction == ZYCycleVerticalViewScrollDirectionDown ? _topRect : _direction == ZYCycleVerticalViewScrollDirectionLeft ? _rightRect : _direction == ZYCycleVerticalViewScrollDirectionrRight ? _leftRect : _btmRect;

}

- (void)setDirection:(ZYCycleVerticalViewScrollDirection)direction{
    _direction = direction;
//    _tmpAnimationView2.frame = _direction == ZYCycleVerticalViewScrollDirectionDown ? _topRect : _btmRect;
    _tmpAnimationView2.frame = _direction == ZYCycleVerticalViewScrollDirectionDown ? _topRect : _direction == ZYCycleVerticalViewScrollDirectionLeft ? _rightRect : _direction == ZYCycleVerticalViewScrollDirectionrRight ? _leftRect : _btmRect;
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    _indexNow = 0;
    [self startAnimation];
}

- (void)startAnimation{
    [self setViewInfo];
    if (_dataSource.count > 1) {
        [self stopTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:_showTime target:self selector:@selector(executeAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)executeAnimation{
    [self setViewInfo];
    [UIView animateWithDuration:_animationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self->_tmpMiddleView.frame = self->_direction == ZYCycleVerticalViewScrollDirectionDown ? self->_btmRect : self->_topRect;
        _tmpMiddleView.frame = _direction == ZYCycleVerticalViewScrollDirectionDown ? _btmRect : _direction == ZYCycleVerticalViewScrollDirectionLeft ? _leftRect : _direction == ZYCycleVerticalViewScrollDirectionrRight ? _rightRect : _topRect;
        if (self->_direction == ZYCycleVerticalViewScrollDirectionDown) {
            self->_tmpTopView.frame = self->_middleRect;
        }else if(self->_direction == ZYCycleVerticalViewScrollDirectionLeft){
            self->_tmpRightView.frame = self->_middleRect;
        }else if (self->_direction == ZYCycleVerticalViewScrollDirectionrRight){
            self->_tmpLeftView.frame = self->_middleRect;
        }else {
            self->_tmpBtmView.frame = self->_middleRect;
        }
    }completion:^(BOOL finished) {
        [self finished];
    }];
//    [self performSelector:@selector(finished)
//               withObject:nil
//               afterDelay:_animationTime];
    
}

- (void)finished{
    _tmpMiddleView.frame = _direction == ZYCycleVerticalViewScrollDirectionDown ? _topRect : _direction == ZYCycleVerticalViewScrollDirectionLeft ? _rightRect : _direction == ZYCycleVerticalViewScrollDirectionrRight ? _leftRect : _btmRect;
    _indexNow++;
}

- (void)setViewInfo{
    if (_direction == ZYCycleVerticalViewScrollDirectionDown) {
        if (_tmpAnimationView1.frame.origin.y == 0) {
            _tmpMiddleView = _tmpAnimationView1;
            _tmpTopView = _tmpAnimationView2;
        } else {
            _tmpMiddleView = _tmpAnimationView2;
            _tmpTopView = _tmpAnimationView1;
        }
    } else if(_direction == ZYCycleVerticalViewScrollDirectionUp){
        if (_tmpAnimationView1.frame.origin.y == 0) {
            _tmpMiddleView = _tmpAnimationView1;
            _tmpBtmView = _tmpAnimationView2;
        } else {
            _tmpMiddleView = _tmpAnimationView2;
            _tmpBtmView = _tmpAnimationView1;
        }
    }else if (_direction == ZYCycleVerticalViewScrollDirectionLeft){
        if (_tmpAnimationView1.frame.origin.x == 0) {
            _tmpMiddleView = _tmpAnimationView1;
            _tmpRightView = _tmpAnimationView2;
        } else {
            _tmpMiddleView = _tmpAnimationView2;
            _tmpRightView = _tmpAnimationView1;
        }
    }else{//ZYCycleVerticalViewScrollDirectionRight
        if (_tmpAnimationView1.frame.origin.x == 0) {
            _tmpMiddleView = _tmpAnimationView1;
            _tmpLeftView = _tmpAnimationView2;
        } else {
            _tmpMiddleView = _tmpAnimationView2;
            _tmpLeftView = _tmpAnimationView1;
        }
    }
    _tmpMiddleView.text = _dataSource[_indexNow%(_dataSource.count)];
    if(_dataSource.count > 1){
        if (_direction == ZYCycleVerticalViewScrollDirectionDown) {
            _tmpTopView.text = _dataSource[(_indexNow+1)%(_dataSource.count)];
        }else if (_direction == ZYCycleVerticalViewScrollDirectionLeft){
            _tmpRightView.text = _dataSource[(_indexNow+1)%(_dataSource.count)];
        }else if (_direction == ZYCycleVerticalViewScrollDirectionrRight){
            _tmpLeftView.text = _dataSource[(_indexNow+1)%(_dataSource.count)];
        }else {
            _tmpBtmView.text = _dataSource[(_indexNow+1)%(_dataSource.count)];
        }
    }
}

- (void)stopAnimation{
    [self stopTimer];
    [self.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stopTimer{
    if(_timer){
        if([_timer isValid]){
            [_timer invalidate];
        }
        _timer = nil;
    }
}

- (void)btnClick{
    if(_delegate && [_delegate respondsToSelector:@selector(zyCycleVerticalView:didClickItemIndex:)]){
        [_delegate zyCycleVerticalView:self didClickItemIndex:_indexNow%(_dataSource.count)];
    }
}

- (void)dealloc{
    self.delegate = nil;
}

@end

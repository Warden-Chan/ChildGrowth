//
//  SignINController.m
//  PCN
//
//  Created by 蒙奇D路飞 on 16/8/19.
//  Copyright © 2016年 com.smh.pcn. All rights reserved.
//

#import "SignINController.h"

#import "CommonTool.h"
@interface SignINController(){
    int temp;
}

@property (weak, nonatomic) IBOutlet UILabel *footLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (assign,nonatomic) SystemSoundID soundID;
@property (nonatomic, strong)CAEmitterLayer * emitterLayer;//粒子动画
@end
@implementation SignINController
-(void)viewDidLoad{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    self.descriptionLabel.text = @"点击这里签到\n赚取金币";
    self.footLabel.text = [NSString stringWithFormat:@"连续签到%d天",self.signCount];
    [self initMyEmitter];//初始化粒子发射源
    temp = 0;
    [self autoSign];
    [self startTransformAnimation];
    [self GcdTimetoreturnMe];
}
-(void)GcdTimetoreturnMe{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
dispatch_after(popTime, dispatch_get_main_queue(), ^{
//    [self performSegueWithIdentifier:@"returnMe" sender:nil];
    [self dismissModalViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
});
}
- (IBAction)shouldSignIn:(UIButton *)sender {
    [self autoSign];
    [self startTransformAnimation];
}
-(void) startTransformAnimation{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    [self.signBtn.layer addAnimation:rotationAnimation forKey:@"signBtnTransform"];
}
#pragma mark - 自动签到
-(void)autoSign{
    //这里写自己的耗时操作
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopCircle) userInfo:nil repeats:NO];
}
-(void)stopCircle{
    //结束旋转动画
    [self.signBtn.layer removeAnimationForKey:@"signBtnTransform"];
    [self.signBtn setSelected:YES];
    //    self.clickSignBtn(YES);
    self.descriptionLabel.text = @"签到成功\n金币将于次日发放";
    self.footLabel.text = [NSString stringWithFormat:@"连续签到%d天",2];
    //动画撒金币效果
    [self startAnimation];
    //播放音效
    [self playSound];
}
- (void)startAnimation{
    CABasicAnimation * effectAnimation = [CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
    effectAnimation.fromValue = [NSNumber numberWithFloat:30];
    effectAnimation.toValue = [NSNumber numberWithFloat:0];
    effectAnimation.duration = 2.0f;
    effectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    effectAnimation.delegate = self;
    [self.emitterLayer addAnimation:effectAnimation forKey:@"zanCount"];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        //停止播放音效
        AudioServicesDisposeSystemSoundID(self.soundID);
    }
}
//初始化粒子
-(void)initMyEmitter{
    //发射源
    CAEmitterLayer * emitter = [CAEmitterLayer layer];
    emitter.frame = CGRectMake(0, 0, CGRectGetWidth(self.signBtn.frame), CGRectGetHeight(self.signBtn.frame));
    [self.signBtn.layer addSublayer:self.emitterLayer = emitter];
    //发射源形状
    emitter.emitterShape = kCAEmitterLayerCircle;
    //发射模式
    emitter.emitterMode = kCAEmitterLayerOutline;
    //渲染模式
    //    emitter.renderMode = kCAEmitterLayerAdditive;
    //发射位置
    emitter.emitterPosition = CGPointMake(self.signBtn.frame.size.width/2.0, self.signBtn.frame.size.height/2.0);
    //发射源尺寸大小
    emitter.emitterSize = CGSizeMake(20, 20);
    
    // 从发射源射出的粒子
    
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    cell.name = @"zanShape";
    //粒子要展现的图片
    cell.contents = (__bridge id)[UIImage imageNamed:@"coin"].CGImage;
    //    cell.contents = (__bridge id)[UIImage imageNamed:@"EffectImage"].CGImage;
    //            cell.contentsRect = CGRectMake(100, 100, 100, 100);
    //粒子透明度在生命周期内的改变速度
    cell.alphaSpeed = -0.5;
    //生命周期
    cell.lifetime = 3.0;
    //粒子产生系数(粒子的速度乘数因子)
    cell.birthRate = 0;
    //粒子速度
    cell.velocity = 300;
    //速度范围
    cell.velocityRange = 100;
    //周围发射角度
    cell.emissionRange = M_PI / 8;
    //发射的z轴方向的角度
    cell.emissionLatitude = -M_PI;
    //x-y平面的发射方向
    cell.emissionLongitude = -M_PI / 2;
    //粒子y方向的加速度分量
    cell.yAcceleration = 250;
    emitter.emitterCells = @[cell];
}
#pragma mark - 播放音效
-(void)playSound{
    self.soundID = [CommonTool creatSoundIDWithSoundName:@"签到金币音效.mp3"];
    [CommonTool playSoundWithSoundID:self.soundID];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end

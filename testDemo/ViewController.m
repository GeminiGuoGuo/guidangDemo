//
//  ViewController.m
//  testDemo
//
//  Created by lc on 16/9/12.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#import "Base64.h"
#import "MLEmojiLabel.h"
#import "UINavigationBar+Awesome.m"
#import "Person.h"
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//屏幕宽高
#define kwidth   [UIScreen mainScreen].bounds.size.width
#define kheight  [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
{
    UIImageView *imgview;
    UIButton *btn;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    imgview = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [self.view addSubview:imgview];
//    imgview.image  =[UIImage imageNamed:@"icon_60"];
//    
//    btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn.frame = CGRectMake(kwidth/2, kheight-30, kwidth/2, 30);
//    [self.view addSubview:btn];
//    [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
    
    
//    
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    if ([SKPaymentQueue canMakePayments]) {
//        // 执行下面提到的第5步：
//        NSLog(@"允许");
//        [self getProductInfo];
//    } else {
//        NSLog(@"失败，用户禁止应用内付费购买.");
//    }
    
    
//    NSString *str  = @"\r\n测试换行1\r\n\r\n测试换行2\r\n\r\n测试换行3\r\n\r\n";
//    NSLog(@"%@",str);
//    
//    NSString *str1 = @"\r\n18810152570\r\n\r\n测试换行2\r\n\r\n测试换行3\r\n\r\n";
//    
//    [str1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    
//    CGFloat height = [self boundingRectWithSize:CGSizeMake(kwidth-20, CGFLOAT_MAX) withFont:17 str:str1].height;
//    
//    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, kwidth-20, height)];
//    lable1.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:lable1];
//    lable1.numberOfLines = 0;
//    lable1.font = [UIFont systemFontOfSize:17];
//    lable1.text = str1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"123" style:UIBarButtonItemStyleDone target:self action:@selector(action4left)];
    
    
    
    //==============/////////归档/////////===============
    
    Person *p1 = [[Person alloc]initWithName:@"guoguo" phoneNum:@"18810152570" age:18];
    Person *p2 = [[Person alloc]initWithName:@"niuniu" phoneNum:@"15169048383" age:18];
    
    NSMutableData *data = [NSMutableData new];
    NSKeyedArchiver *en = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [en encodeObject:p1 forKey:@"person1"];
    [en encodeObject:p2 forKey:@"person2"];
    [en finishEncoding];
    [data writeToFile:[self getFilePath] atomically:YES];
    //将存入的数据取出
    NSMutableData *data1 = [[NSMutableData alloc]initWithContentsOfFile:[self getFilePath]];
    NSKeyedUnarchiver *un = [[NSKeyedUnarchiver alloc]initForReadingWithData:data1];
    
    Person *p3 = [un decodeObjectForKey:@"person1"];
    Person *p4 = [un decodeObjectForKey:@"person2"];
    NSLog(@"%@======%@",p3,p4);
    
    
}


-(NSString *)getFilePath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"texts"];
    return path1;
}








-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar lt_setBackgroundColor:[UIColor redColor]];
}



- (CGFloat)textHeight:(NSString *)str{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kwidth-20,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}


- (CGSize)boundingRectWithSize:(CGSize)size withFont:(NSInteger)font str:(NSString *)str{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    CGSize retSize = [str boundingRectWithSize:size options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}



- (void)getProductInfo {
    NSSet * set = [NSSet setWithArray:@[@"ProductId"]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}







// 以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}



- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState){
                
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;
    NSString * receipt = [transaction.transactionReceipt base64EncodedString];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}







































-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showLikedFoodsAnimation];
}
//- (void)addAnimatedWithFrame:(CGRect)frame {
//    // 该部分动画 以self.view为参考系进行
//    frame = [[UIApplication sharedApplication].keyWindow  convertRect:frame fromView:self.RFcell.headBtn];
//    UIButton *move = [[UIButton alloc] initWithFrame:frame];
//    [move setBackgroundColor:UIColorFromRGB(0xFFA215)];
//    [move setTitle:self.RFcell.headBtn.currentTitle forState:UIControlStateNormal];
//    [move setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    move.contentMode = UIViewContentModeScaleToFill;
//    [[UIApplication sharedApplication].keyWindow addSubview:move];
//    // 加入购物车动画效果
//    [UIView animateWithDuration:1.2 animations:^{
//        move.frame = CGRectMake(320 - frame.size.width  - 20, 24,
//                                frame.size.width, frame.size.height);
//    } completion:^(BOOL finished) {
//        [move removeFromSuperview];
//        if (self.cartCategoriesLabel == nil) {
//            self.cartCategoriesLabel = [[UILabel alloc] initWithFrame:CGRectMake((16 - 8) / 2, (16 - 8) / 2, 8, 8)];
//            self.cartCategoriesLabel .textColor = [UIColor whiteColor];
//            self.cartCategoriesLabel .backgroundColor = [UIColor clearColor];
//            self.cartCategoriesLabel .textAlignment = NSTextAlignmentCenter;
//            self.cartCategoriesLabel .font = [UIFont systemFontOfSize:9];
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 16, 16)];
//            imgView.image = [UIImage imageNamed:@"news"];
//            [imgView addSubview:self.cartCategoriesLabel];
//            [self.cartButton addSubview:imgView];
//        }
//        self.cartCategoriesLabel .text = [NSString stringWithFormat:@"%d", _cartCategories.count];
//    }];  
//    
//    return;  
//}
- (void)showLikedFoodsAnimation{
    //get the location of label in table view
    NSValue *value = [NSValue valueWithCGPoint:imgview.center];
    CGPoint lbCenter = value.CGPointValue;
    
    //the image which will play the animation soon
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_60"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.hidden = YES;
    imageView.center = lbCenter;
    
    //the container of image view
    CALayer *layer = [[CALayer alloc]init];
    layer.contents = imageView.layer.contents;
    layer.frame = imageView.frame;
    layer.opacity = 1;
    [self.view.layer addSublayer:layer];
    
    //CGPoint btnCenter = btn.center;
    //动画 终点 都以sel.view为参考系
    CGPoint endpoint = btn.center;
    UIBezierPath *path = [UIBezierPath bezierPath];
    //动画起点
    CGPoint startPoint = imgview.center;
    [path moveToPoint:startPoint];
    //贝塞尔曲线控制点
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endpoint.x;
    float ey = endpoint.y;
    float x = sx + (ex - sx) / 3;
    float y = sy + (ey - sy) * 0.5 - 400;
    CGPoint centerPoint=CGPointMake(x, y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    
    //key frame animation to show the bezier path animation
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.8;
    animation.delegate = self;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:@"buy"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

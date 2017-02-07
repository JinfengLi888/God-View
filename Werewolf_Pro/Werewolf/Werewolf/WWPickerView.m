//
//  WWPickerView.m
//  Werewolf
//
//  Created by Jean on 11/23/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import "WWPickerView.h"

@interface WWPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WWPickerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 1;
        self.delegate = self;
        self.dataSource = self;
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        longGes.minimumPressDuration = .5;
        [self addGestureRecognizer:longGes];
        
//        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
//        [self addGestureRecognizer:tapGes];
        
    }
    return self;
}

-(void)gestureAction:(id)sender
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定该玩家死亡?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"死亡" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.layer.borderColor = [UIColor redColor].CGColor;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self.superController presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.nums;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    [self clearSeparatorWithView:pickerView];
    
    return self.dataArray[row];
}

- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0  )
    {
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.block) {
        
        self.block(self.dataArray[row]);
    }
}

-(void)setNums:(NSInteger)nums
{
    _nums = nums;
    if (!self.dataArray)
        self.dataArray = [NSMutableArray array];
    for (int i=1; i<=nums; i++)
    {
        [self.dataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

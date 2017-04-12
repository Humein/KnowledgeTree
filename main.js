
defineClass('CourseCenterpurchaseController',{

            pushPayView: function() {
        
            require('ZTKStatistics,ZTKTools,UIStoryboard,NSBundle');
            ZTKStatistics.event("ZTKPurchase");
            ZTKTools.hideHudWithView(self.view());
            var story = UIStoryboard.storyboardWithName_bundle("OrderTableViewController", NSBundle.mainBundle());
            var myView = story.instantiateViewControllerWithIdentifier("myView");
            myView.setListmodel(self.VideoListmodel());
            if (myView.Listmodel().NetClassId() == null) {
            myView.Listmodel().setNetClassId(self.VideoListmodel().rid());
            }
            self.navigationController().pushViewController_animated(myView, YES);
            
            
            
            }

            
            });


defineClass('CourseCenterpurchaseController',{
            
            tabbarViewChange: function() {
            if (self.purchaseModel().teacher_informatioin().isBuy() == 1) {
            
            
            self.addOnceFreeTabbar();
            
            } else {
            
            if (self.purchaseModel().teacher_informatioin().ActualPrice() > 0) {
            
            self.addOnceBuyTabbar();
            
            
            } else {
            
            
            self.addOnceFreeTabbar();
            }
            
            }
            
            }
            
            });




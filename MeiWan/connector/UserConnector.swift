//
//  UserConnector.swift
//  Liuwei
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import UIKit


@objc public class UserConnector: NSObject {
    
//    private static let userUrl=setting.getIp()+"peiwan-server/rest/users/";
//    private static let orderUrl=setting.getIp()+"peiwan-server/rest/orders/";

    private static func UserURL()->String?{
        return setting.getIp()+"peiwan-server/rest/users/";
    }
    private static func OrderURL()->String?{
        return setting.getIp()+"peiwan-server/rest/orders/";
    }
    public static func acceptInvalidSSLCerts() {
        let manager = Manager.sharedInstance
        
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .CancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(challenge.protectionSpace)
                    if credential != nil {
                        disposition = .UseCredential
                    }
                }
            }
            return (disposition, credential)
        }
    }
    
    //登陆
    public static func login(username:String,password:String,receiver:(data:NSData?,error:NSError?)->()){

        
        request(.GET, UserURL()!+"login", parameters:["username":username,"password":password])
            .response { request, response, data, error in
                if ((error) != nil){
                    setting .adjustIps()
                    
                }
                
                //            var s = NSString(data: data!, encoding: NSUTF8StringEncoding)as String!
                //这里解析你收到的数据
                receiver(data:data!, error:error)
        }
    }
    
    //更新资料
    public static func update(session:String?,parameters:NSDictionary,receiver:(data:NSData?,error:NSError?)->()){
        if(session != nil){
            parameters.setValue(session,forKey:"session")
        }
        request(.GET, UserURL()!+"update", parameters:parameters as? [String : AnyObject])
            .response { request, r, data, error in
                if ((error) != nil){
                    setting .adjustIps()
                }else{
                    
                }

                
                receiver(data:data!, error:error)
        }
    }
    
    //根据条件查找陪玩
    public static func aroundPeiwan(session:String?,gender:NSNumber?,minPrice:NSNumber?,maxPrice:NSNumber?,isWin:NSNumber?,offset:Int,limit:Int,isRecommend:NSNumber?,mode:NSNumber?,tagIndex:NSNumber?,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        if(gender != nil){
            parameters["gender"]=gender
        }
        if(minPrice != nil){
            parameters["minPrice"]=minPrice
        }
        if(maxPrice != nil){
            parameters["maxPrice"]=maxPrice
        }
        if(isWin != nil){
            parameters["isWin"]=isWin
        }
        if(tagIndex != nil){
            parameters["tagIndex"]=tagIndex
        }
        parameters["offset"]=offset
        parameters["limit"]=limit
        if(isRecommend != nil){
            parameters["isRecommend"]=isRecommend
        }
        if(mode != nil){
            parameters["mode"]=mode
        }
        request(.GET, UserURL()!+"aroundPeiwan", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if ((error) != nil){
                }else{
                    setting .adjustIps()
                }
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //注册用户
    public static func register(username:String!,password:String!,verifyCode:String!,nickname:String!,gender:NSNumber!,year:NSNumber!,month:NSNumber!,day:NSNumber!,headUrl:String!,city:String!,district:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["username"]=username
        parameters["password"]=password
        parameters["verifyCode"]=verifyCode
        parameters["nickname"]=nickname
        parameters["gender"]=gender
        parameters["year"]=year
        parameters["month"]=month
        parameters["day"]=day
        parameters["headUrl"]=headUrl
        parameters["city"]=city
        parameters["district"]=district
        request(.GET, UserURL()!+"register", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    if ((error) != nil){
                    }else{
                    }                }
                
                receiver(data:data, error:error)
        }
    }
    
    //通过ID寻找陪玩
    public static func findPeiwanById(session:String?,userId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        parameters["userId"]=userId
        request(.GET, UserURL()!+"findPeiwanById", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                }
                
                receiver(data:data, error:error)
        }
    }
    
  
    //寻找游戏角色
    public static func findRoles(userId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["userId"]=userId
        request(.GET, UserURL()!+"findRoles", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                }
                
                receiver(data:data, error:error)
        }
    }
    
    //查询订单评价
    public static func findOrderEvaluationByUserId(peiwanId:NSNumber!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["peiwanId"]=peiwanId
        parameters["offset"]=offset
        parameters["limit"]=limit
        request(.GET, UserURL()!+"findOrderEvaluationByUserId", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                }
                
                receiver(data:data, error:error)
        }
    }
    
    //查询常去网吧
    public static func peiwanNetbars(peiwanId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["peiwanId"]=peiwanId
        request(.GET, UserURL()!+"peiwanNetbars", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                }
                
                receiver(data:data, error:error)
        }
    }
    
    //发送验证码（注册）
    public static func sendCode(phone:String!,sign:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["phone"]=phone;
        parameters["sign"]=sign;
        request(.GET, UserURL()!+"sendCode", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //发送验证码（找回密码）
    public static func sendCode2(phone:String!,sign:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["phone"]=phone;
        parameters["sign"]=sign;
        request(.GET, UserURL()!+"sendCode2", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //查找好友列表
    public static func findMyFriends(session:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        request(.GET, UserURL()!+"findMyFriends", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //添加好友
    public static func addFriend(session:String!,friendId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["friendId"]=friendId
        request(.GET, UserURL()!+"addFriend", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //删除好友
    public static func deleteFriend(session:String!,friendId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["friendId"]=friendId
        request(.GET, UserURL()!+"deleteFriend", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //投诉
    public static func accusation(session:String!,peiwanId:NSNumber!,contentIndex:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["peiwanId"]=peiwanId
        parameters["contentIndex"]=contentIndex
        request(.GET, UserURL()!+"accusation", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //查询网吧图片
    public static func findNetbarPhoto(netbarId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["netbarId"]=netbarId
        request(.GET, UserURL()!+"findNetbarPhoto", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //添加游戏角色
    public static func addRole(session:String!,part:String!,name:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["part"]=part
        parameters["name"]=name
        request(.GET, UserURL()!+"addRole", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //删除游戏角色
    public static func deleteRole(session:String!,lolRoleId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["lolRoleId"]=lolRoleId
        request(.GET, UserURL()!+"deleteRole", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //创建订单，废弃的接口，因为要传入时间标签的需要
    public static func createOrder(session:String!,peiwanId:NSNumber!,netbarId:NSNumber?,price:NSNumber!,type:NSNumber!,hours:NSNumber!,isWin:NSNumber!,promoterId:NSNumber?,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["peiwanId"]=peiwanId
        if(netbarId != nil){
            parameters["netbarId"]=netbarId
        }
        if(promoterId != nil){
            parameters["promoterId"]=promoterId
        }
        parameters["price"]=price
        parameters["type"]=type
        parameters["hours"]=hours
        parameters["isWin"]=isWin
        request(.GET, OrderURL()!+"createOrder", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //创建订单
    public static func createOrder2(session:String!,peiwanId:NSNumber!,price:NSNumber!,tagIndex:NSNumber!,hours:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        if(peiwanId != nil){
            parameters["peiwanId"]=peiwanId
        }
        if(tagIndex != nil){
            parameters["tagIndex"]=tagIndex
        }
        if(price != nil){
            parameters["price"]=price
        }
        if(hours != nil){
            parameters["hours"]=hours
        }
        request(.GET, OrderURL()!+"createOrder2", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //我的动态
    public static func findStates(session:String!, userId:NSNumber!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"] = session
        parameters["userId"]=userId
        parameters["offset"]=offset
        parameters["limit"]=limit
        request(.GET, UserURL()!+"findStates2", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //附近动态
    public static func findAroundStates(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["offset"]=offset
        parameters["limit"]=limit
        request(.GET, UserURL()!+"findAroundStates", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //加入动态评论
    public static func insertStateComment(session:String!,toId:NSNumber!,content:String!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["toId"] = toId
        parameters["content"]=content
        parameters["stateId"]=stateId
        request(.GET, UserURL()!+"insertStateComment", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //插入评论回复
    public static func insertStateReplay(session:String!,toId:NSNumber!,content:String!,stateCommentId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["toId"] = toId
        parameters["content"]=content
        parameters["stateCommentId"]=stateCommentId
        request(.GET, UserURL()!+"insertStateReplay", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //全部动态评论
    public static func findStateComment(session:String!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["stateId"]=stateId
        request(.GET, UserURL()!+"findStateComment", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //发表动态
    public static func insertState(session:String!,content:String!,statePhotos:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["content"]=content
        parameters["statePhotos"]=statePhotos
        request(.GET, UserURL()!+"insertState", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //删除动态
    public static func deleteState(session:String!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["stateId"]=stateId
        request(.GET, UserURL()!+"deleteState", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //点赞
    public static func likeUserState(session:String!,toId:NSNumber!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"] = session
        parameters["toId"] = toId
        parameters["stateId"] = stateId
        request(.GET, UserURL()!+"likeUserState",parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //取消点赞
    public static func unlikeUserState(session:String!,toId:NSNumber!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"] = session
        parameters["toId"] = toId
        parameters["stateId"] = stateId
        request(.GET, UserURL()!+"unlikeUserState",parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //用户标签
    public static func findUserTags(userId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["userId"] = userId
        request(.GET, UserURL()!+"findUserTags", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //排行榜
    public static func rankUsers(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"] = session
        parameters["offset"] = offset
        parameters["limit"] = limit
        request(.GET, UserURL()!+"rankUsers", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //提交陪玩申请
    public static func createPeiwanForm(session:String!,phone:String!,gameName:String!,gameNickname:String!,headPhoto:String!,idPhoto:String!,address:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["phone"]=phone
        parameters["gameName"]=gameName
        parameters["gameNickname"]=gameNickname
        parameters["headPhoto"]=headPhoto
        parameters["idPhoto"]=idPhoto
        parameters["address"]=address
        request(.GET, UserURL()!+"createPeiwanForm", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //通过名称查询网吧
    public static func findNetbarLikeName(name:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["name"]=name
        parameters["offset"]=offset
        parameters["limit"]=limit
        request(.GET, UserURL()!+"findNetbarLikeName", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //我的订单
    public static func myOrders(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["offset"]=offset
        parameters["limit"]=limit
        request(.GET, OrderURL()!+"myOrders", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //接受邀请
    public static func acceptOrder(session:String!,orderId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["orderId"]=orderId
        request(.GET, OrderURL()!+"acceptOrder", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //邀请我的
    public static func inviteMeOrders(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["offset"]=offset
        parameters["limit"]=limit
        request(.GET, OrderURL()!+"inviteMeOrders", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //完成订单
    public static func orderOk(session:String!,orderId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["orderId"]=orderId
        request(.GET, OrderURL()!+"orderOk", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //余额支付
    public static func payWithAccountMoney(session:String!,orderId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["orderId"]=orderId
        request(.GET, OrderURL()!+"payWithAccountMoney", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //订单投诉
    public static func sendComplain(session:String!,orderId:NSNumber!,title:String?,content:String?,photos:String?,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["orderId"]=orderId
        parameters["title"]=title
        parameters["content"]=content
        parameters["photos"]=photos
        request(.GET, OrderURL()!+"sendComplain", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //订单评价
    public static func evaluationOrder(session:String!,orderId:NSNumber!,peiwanId:NSNumber!,point:NSNumber!,tagIndexs:String!,content:String?,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["orderId"]=orderId
        parameters["peiwanId"]=peiwanId
        parameters["point"]=point
        parameters["tagIndexs"]=tagIndexs
        parameters["content"]=content
        request(.GET, OrderURL()!+"evaluationOrder", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //申请提现
    public static func createCashRequest(session:String!,money:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["money"]=money
        request(.GET, UserURL()!+"createCashRequest", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //查询提现列表
    public static func myCashRequests(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["offset"]=offset
        parameters["limit"]=limit
        request(.GET, UserURL()!+"myCashRequests", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //重设密码
    public static func resetPwd(username:String!,password:String!,verifyCode:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["username"]=username
        parameters["password"]=password
        parameters["verifyCode"]=verifyCode
        request(.GET, UserURL()!+"resetPassword", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //添加标签
    public static func addUserTimeTag(session:String!,tagIndex:NSNumber!,price:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["tagIndex"]=tagIndex
        parameters["price"]=price
        request(.GET, UserURL()!+"addUserTimeTag", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //删除标签
    public static func deleteUserTimeTag(session:String!,tagIndex:NSNumber!,price:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        parameters["tagIndex"]=tagIndex
        parameters["price"]=price
        request(.GET, UserURL()!+"deleteUserTimeTag", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    /**充值*/
    public static func createRecharge(session:String!,money:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        if(money != nil){
            parameters["money"]=money
        }
        request(.GET, OrderURL()!+"createRecharge", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    //获取用户动态 粉丝 关注数量
    public static func getLoginedUser(session:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        request(.GET, UserURL()!+"getLoginedUser", parameters:parameters as? [String : NSObject])
            
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    /**直接充值*/
    public static func aliRechargeSigh(session:String!,price:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
       
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if(session != nil){
            parameters["session"]=session
        }
        if(price != nil){
            parameters["price"]=price
        }
        
        request(.GET, OrderURL()!+"aliRechargeSigh", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                receiver(data:data!.gunzippedData(), error:error)
        }

    
    }
    
    public static func payWithAccountMoney(session:String!,peiwanId:NSNumber!,price:NSNumber!,hours:NSNumber!,tagIndex:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
    
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if(session != nil){
            parameters["session"]=session
        }
        if(price != nil){
            parameters["peiwanId"]=peiwanId
        }
        if(price != nil){
            parameters["price"]=price
        }
        if(price != nil){
            parameters["hours"]=hours
        }
        if(price != nil){
            parameters["tagIndex"]=tagIndex
        }
        
        request(.GET, OrderURL()!+"payWithAccountMoney", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                receiver(data:data!.gunzippedData(), error:error)
        }


    }
    
    public static func aliOrderSign(session:String!,peiwanId:NSNumber!,price:NSNumber!,hours:NSNumber!,tagIndex:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if(session != nil){
            parameters["session"]=session
        }
        if(price != nil){
            parameters["peiwanId"]=peiwanId
        }
        if(price != nil){
            parameters["price"]=price
        }
        if(price != nil){
            parameters["hours"]=hours
        }
        if(price != nil){
            parameters["tagIndex"]=tagIndex
        }
        
        request(.GET, OrderURL()!+"aliOrderSign", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                receiver(data:data!.gunzippedData(), error:error)
        }
        
        
    }
    
    //查找关注列表
    public static func findMyFocus(session:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        parameters["session"]=session
        request(.GET, UserURL()!+"findFollowersByUserId", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error != nil){
                    setting .adjustIps()

                    
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }

    
}








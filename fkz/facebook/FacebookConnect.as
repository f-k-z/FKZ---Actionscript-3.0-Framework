package fkz.facebook
{
	import com.adobe.images.JPGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.external.ExternalInterface;
	import com.facebook.graph.Facebook;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	/******************************************************************************************
	 * 
	 *	This wrapper uses a modified version of com.facebook.graph.core.FacebookJSBridge.as.
	 *	Be sure you have the correct version before using this wrapper.
	 * 
	 * 	Things to change:
	 *   	- Modify the getLoginStatus method:
	 * 			getLoginStatus: function()
	 * 			{
	 *				FB.getLoginStatus(function(response)
	 * 				{
	 *					if(response.authResponse)
	 * 					{
	 *						//FBAS.updateSwfAuthResponse(response);
	 *						FBAS.updateSwfAuthResponse_login(response);
	 *					} else {
	 *						//FBAS.updateSwfAuthResponse(null);
	 *						FBAS.updateSwfAuthResponse_login(response);
	 *					}
	 *				});
	 *			}
	 *		
	 * 		- Add the following method:		
	 *			updateSwfAuthResponse_login: function(response)
	 * 			{								
	 *				swf = FBAS.getSwf();
	 *				swf.authResponseChange_login(response.status, response.authResponse);
	 *			}
	 * 
	 ****************************************************************************************/
	
	public class FacebookConnect
	{
		public static const CONNECTED				:String = "connected";
		public static const NOT_AUTHORIZED			:String = "not_authorized";
		public static const UNKNOWN					:String = "unknown";
		
		private static var instance					:FacebookConnect;
		
		private var _appId							:String;
		private var _appSecret						:String;
		
		private var _loginStatus					:String;
		private var _accessToken					:String;
		
		private var loginCallback					:Function;
		private var getLoginStatusCallback			:Function;
		
		public function FacebookConnect()
		{
			
		}
		
		/////////////////// SINGLETON
		public static function getInstance():FacebookConnect
		{
			if (instance == null)
				instance = new FacebookConnect;
				
			return instance;
		}
		
		/////////////////// PRIVATE METHODS
		private function _init(appId:String, loginCallback:Function, getLoginStatusCallback:Function, extraInitParams:Object = null, accessToken:String = ""):void
		{
			_appId = appId;
			
			this.loginCallback = loginCallback;
			this.getLoginStatusCallback = getLoginStatusCallback;
			
			if (ExternalInterface.available)
				ExternalInterface.addCallback("authResponseChange_login", _onGetLoginStatus);
				
			var initParams:Object = {appId: _appId};
			
			for (var p:* in extraInitParams)
				initParams[p] = extraInitParams[p];
			
			if (accessToken == "")
			{
				Facebook.init(_appId, loginCallback, initParams);
			}
			else
			{
				Facebook.init(_appId, loginCallback, initParams, accessToken);
			}
		}
		
		private function _getLoginStatus():void
		{
			Facebook.getLoginStatus();
		}
		
		private function _onGetLoginStatus(status:String, response:Object):void
		{
			_loginStatus = status;
			
			if (response)
				_accessToken = response.accessToken;
			
			getLoginStatusCallback.call(null, status, response);
		}
		
		private function _login(loginPopupParams:String):void
		{
			Facebook.login(loginCallback, {scope: loginPopupParams});
		}
		
		private function _post(message:String, onPost:Function):void
		{
			if (_loginStatus != CONNECTED)
			{
				trace("# [FacebookConnect.as] You need to be connected to post anything on your wall.");
				return;
			}
			
			Facebook.postData("/me/feed", onPost, {access_token: _accessToken, message: message});
		}
		
		private function _postLink(link:String, message:String, onPost:Function):void
		{
			if (_loginStatus != CONNECTED)
			{
				trace("# [FacebookConnect.as] You need to be connected to post anything on your wall.");
				return;
			}
			
			Facebook.postData("/me/feed", onPost, {access_token: _accessToken, link: link, message: message});
		}
		
		private function _get(graphObject:String, callback:Function):void
		{
			if (_loginStatus != CONNECTED)
			{
				trace("# [FacebookConnect.as] You need to be connected to use the graph API.");
				return;
			}
			
			Facebook.api(graphObject, callback, {access_token: _accessToken});
		}
		
		/////////////////// PUBLIC METHODS
		public static function init(appId:String, loginCallback:Function, getLoginStatusCallback:Function, extraInitParams:Object = null, accessToken:String = ""):void
		{
			getInstance()._init(appId, loginCallback, getLoginStatusCallback, extraInitParams, accessToken);
		}
		
		public static function getLoginStatus():void
		{
			getInstance()._getLoginStatus();
		}
		
		public static function login(loginPopupParams:String):void
		{
			getInstance()._login(loginPopupParams);
		}
		
		public static function post(message:String, onPost:Function):void
		{
			getInstance()._post(message, onPost);
		}
		
		public static function postLink(link:String, message:String, onPost:Function):void
		{
			getInstance()._postLink(link, message, onPost);
		}
		
		public static function get(graphObject:String, callback:Function):void
		{
			getInstance()._get(graphObject, callback);
		}
		
		public static function get appId():String { return getInstance()._appId; }
		
		public static function get appSecret():String { return getInstance()._appSecret; }
		
		public static function get loginStatus():String { return getInstance()._loginStatus; }
		
		public static function get accessToken():String { return getInstance()._accessToken; }
	}
}
package com.telecoms.media.cdnVideoPortal.control.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class LoadFolderDataDelegate
	{
		private var __locator:ServiceLocator = ServiceLocator.getInstance();
		private var __service:HTTPService;
		private var __responder:IResponder;
		
		public function LoadFolderDataDelegate(responder:IResponder)
		{
			__service = __locator.getHTTPService("retrieveFolderData");
			__responder = responder;
		}
		
		public function loadIcData():void
		{
			var token:AsyncToken = __service.send();
			token.addResponder(__responder);
		}
	}
}
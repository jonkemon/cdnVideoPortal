package com.telecoms.media.cdnVideoPortal.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.telecoms.media.cdnVideoPortal.control.delegates.LoadFolderDataDelegate;
	import com.telecoms.media.cdnVideoPortal.model.PortalModelLocator;
	
	import flash.external.ExternalInterface;
	import flash.xml.XMLDocument;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.utils.ArrayUtil;

	public class LoadFolderDataCommand implements ICommand
	{		
		private var model:PortalModelLocator = PortalModelLocator.getInstance();
		private	var c:int = 0;
		public function execute(event:CairngormEvent):void
		{
			var responder:Responder = new Responder(onResults,onFault);
			var delegate:LoadFolderDataDelegate = new LoadFolderDataDelegate(responder);
			delegate.loadIcData();
		}
		private function onFault(event:FaultEvent):void
		{
			Alert.show('No XML file was found...');
		}
		private function onResults(event:ResultEvent):void
		{
			model.folderData = event.token.result as XML;
		}
	}
}
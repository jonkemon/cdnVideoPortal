package com.telecoms.media.cdnVideoPortal.model
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class PortalModelLocator
	{
		static public var __instance:PortalModelLocator=null;
		public var folderData:XML = new XML;
		public var folderName:String = "";
		
		static public function getInstance():PortalModelLocator
		{
			if(__instance == null)
			{
				__instance = new PortalModelLocator();
			}
			return __instance;
		}
	}	
}
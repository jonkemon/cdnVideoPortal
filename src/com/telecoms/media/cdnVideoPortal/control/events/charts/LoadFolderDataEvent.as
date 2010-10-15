package com.telecoms.media.cdnVideoPortal.control.events.charts
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class LoadFolderDataEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "LoadFolderData";
		public function LoadFolderDataEvent()
		{
			super(EVENT_ID);
			trace(this);
		}
		
	}
}
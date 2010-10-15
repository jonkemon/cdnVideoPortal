package com.telecoms.media.cdnVideoPortal.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.telecoms.media.cdnVideoPortal.control.events.charts.LoadFolderDataEvent;
	import com.telecoms.media.cdnVideoPortal.control.command.LoadFolderDataCommand;
	
	public class PTController extends FrontController
	{
		public function PTController()
		{
			super();
			addCommand(LoadFolderDataEvent.EVENT_ID, LoadFolderDataCommand);
		}
		
	}
}
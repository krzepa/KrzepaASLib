package com.krzepa.gui.popups
{
	import flash.display.*;

	public class PopupInitParams
	{
		public var content:Class;
		public var customData:Object;
		public var priority:int;
		
		public function PopupInitParams( content:Class=null, priority:int = 0, customData:Object=null )
		{
			this.content = content;
			this.priority = priority;
			this.customData = customData;
		}
	}
}
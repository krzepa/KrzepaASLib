package com.krzepa.gui.loaders
{
	public class LoaderConfig
	{
		public var bgColor:uint;
		public var loaderColor:uint;
		public var loaderClass:Class;
		public var mainClass:*;
		public var appName:String;
		public var checkRoot:Boolean;
		public var stableBg:Boolean;
		
		public function LoaderConfig( appName:String = '', loaderColor:uint = 0xFFFFFF, bgColor:uint = 0x000000,
									  loaderClass:Class = null, mainClass:* = null, checkRoot:Boolean = false, stableBg:Boolean = false )
		{
			this.appName = appName;
			this.loaderColor = loaderColor;
			this.bgColor = bgColor;
			this.loaderClass = loaderClass ? loaderClass : DotsLoader;
			this.mainClass = mainClass;
			this.checkRoot = checkRoot;
			this.stableBg = stableBg;
		}
	}
}
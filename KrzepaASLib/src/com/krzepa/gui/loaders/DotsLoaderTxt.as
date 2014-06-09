package com.krzepa.gui.loaders
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class DotsLoaderTxt extends DotsLoader
	{
		private var _txt:TextField;
		
		public function DotsLoaderTxt(	dotsColor:uint = 0xFFFFFF ,
										dotsDiameter:Number = 5 ,
										dotsNum:uint = 9 ,
										diameter:Number = 40 )
		{
			_dotsColor = dotsColor;
			_dotsDiameter = dotsDiameter;
			_dotsNum = dotsNum;
			_diameter = diameter;
		};
		
		override public function init():void
		{
			super.init();
			
			var tf:TextFormat = new TextFormat();
			_txt = new TextField();
			_txt.defaultTextFormat = tf;
			addChild(_txt);
		}
	}
}
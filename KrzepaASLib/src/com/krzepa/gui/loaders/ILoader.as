package com.krzepa.gui.loaders
{
	import flash.display.*;
	
	public interface ILoader 
	{
		function setVisibility(value:Boolean):void;
		function setPercentage(loadedBytes:Number,totalBytes:Number):void;
		function setConfig(value:Object):void;
		function setPosition(valueX:Number,valueY:Number):void;
		function init():void;
	}
}
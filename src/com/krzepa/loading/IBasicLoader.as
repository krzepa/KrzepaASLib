package com.krzepa.loading
{
	public interface IBasicLoader
	{
		function set url( value:String ):void;
		function get url():String;
		function get loader():Object;
		function load( url:Object  ):void;
		function close():void;
	}
}
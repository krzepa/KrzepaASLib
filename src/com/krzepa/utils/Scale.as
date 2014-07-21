package com.krzepa.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

    public final class Scale
	{	
        public static function toHeight(fromWidth:Number, fromHeight:Number, toWidth:Number, toHeight:Number):Rectangle
		{
			var kh:Number = fromHeight / toHeight;
			var newH:Number = toHeight;
			var newW:Number = Math.floor(fromWidth / kh);
			var newY:Number = 0;
			var newX:Number = Math.round(Math.floor((toWidth - newH) * 0.5));
			var r:Rectangle = new Rectangle(0,newY,newW,newH);
			return r;
        }
		
        public static function toWidth(fromWidth:Number, fromHeight:Number, toWidth:Number, toHeight:Number):Rectangle
		{
            var kw:Number = fromWidth / toWidth;
            var newW:Number = toWidth;
            var newH:Number = Math.floor(fromHeight / kw);
            var newY:Number = Math.round(Math.floor((toHeight - newH) * 0.5));
			var r:Rectangle = new Rectangle(0,newY,newW,newH);
			return r;
        }
		
        public static function proportional(fromWidth:Number, fromHeight:Number, toWidth:Number, toHeight:Number):Rectangle
		{
			var kw:Number = fromWidth / toWidth;
			var kh:Number = fromHeight / toHeight;
            var k:Number = Math.max(kw,kh);
			
		
			
			var newW:Number = Math.floor(fromWidth / k);
			var newH:Number = Math.floor(fromHeight / k);
            var newX:Number = Math.floor((toWidth - newW) * 0.5);
            var newY:Number = Math.floor((toHeight - newH) * 0.5);
            var r:Rectangle = new Rectangle(newX,newY,newW,newH);
			return r;
        }
		
		public static function applyRectangle( object:DisplayObject , rect:Rectangle ):void
		{
			object.x = rect.x;
			object.y = rect.y;
			object.width = rect.width;
			object.height = rect.height;
		}
		

    }
}
package com.krzepa.utils
{
	public class ArrayList
	{
		private var _items:Array;
		private var _currentItem:int;		
	
		public function ArrayList( a:Array = null )
		{
			if( a == null ) _items = new Array();
			else _items = a;
			_currentItem = -1;	
		};
		
		public function setItems( a:Array ):void
		{
			_items = a;
			reset();
		};
		
		public function getItems():Array
		{
			return _items;
		};
		
		public function add( o:Object ):void
		{
			_items.push( o );
		};
		
		public function addAt( o:Object , index:int ):void
		{
			_items.splice( index , 0 , o );
		}		
		
		public function remove(index:uint=0):void
		{
			_items.splice(index,1);
			reset();
		};
		
		public function getAt( index:int ):Object
		{
			if(index>=0 && index<=_items.length-1) {
				return _items[index];
			} else {
				return null;
			}
		};	
		
		public function getPrev():Object
		{
			if(_currentItem > 0) {
				return _items[_currentItem-1];
			} else {
				return null;
			}
		};
		
		public function getNext():Object
		{
			if(_currentItem < _items.length-1 ) {
				_currentItem++;
				return _items[_currentItem];
			} else {
				return null;
			}
			
		};
		
		public function dec():void
		{	
			_currentItem--;
			if( _currentItem < -1 ) {
				_currentItem = -1;
			}
		}
		
		public function inc():void
		{
			_currentItem++;
			if( _currentItem > _items.length-1 ) {
				_currentItem = _items.length-1;
			}
		}
		
		public function setIndex(value:int):void
		{
			if(value>=-1 && value<=_items.length-1) {
				_currentItem = value;				
			}
		}
		
		public function getIndex():int
		{
			return _currentItem;
		}
		
		public function hasNext():Boolean
		{
			return _currentItem < _items.length-1;
		};
		
		public function hasPrev():Boolean
		{
			return (_currentItem > 0) && (_items.length > 1);
		}
			
		public function reset():void
		{	
			_currentItem = -1;
		};
		
		public function length():uint
		{
			return _items.length;
		};

	}
}
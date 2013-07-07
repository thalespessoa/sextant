package com.andreanaya.datalib{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class DataLibItem {
		public var dispatcher:EventDispatcher;
		public var data:*;
		public var _type:String;
		
		public function DataLibItem(t:String):void{
			_type = t;
			dispatcher = new EventDispatcher();
		}
		
		public function get type():String{
			return _type;
		}
		
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(evt : Event) : Boolean {
			return dispatcher.dispatchEvent(evt);
		}

		public function hasEventListener(type : String) : Boolean {
			return dispatcher.hasEventListener(type);
		}

		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type : String) : Boolean {
			return dispatcher.willTrigger(type);
		}
		
		public function dispose():void{
			dispatcher = null;
			data = null;
		}
	}
}
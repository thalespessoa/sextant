package com.andreanaya.datalib{
	import flash.events.Event;
	import flash.display.BitmapData;
	
	dynamic public class DataLibEvent extends Event{
		public static var COMPLETE : String = "onComplete";
		public static var PROGRESS : String = "onProgress";
		public static var CLOSE : String = "onClose";
		public static var ERROR : String = "onError";
		
		public function DataLibEvent(type : String, bubbles:Boolean = false, cancelable:Boolean = false, params:Object = null):void{
			super(type, bubbles, cancelable);
			
			if(params){
				for(var i:String in params){
					this[i] = params[i];
				}
			}
		}
	}
}
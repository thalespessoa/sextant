package com.andreanaya.datalib {
	import flash.display.Loader;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.IEventDispatcher;
	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.System;
	
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	
	public class DataLib {
		public static const TYPE_JPG:String = "jpg";
		public static const TYPE_GIF:String = "gif";
		public static const TYPE_PNG:String = "png";
		public static const TYPE_SWF:String = "swf";
		public static const TYPE_XML:String = "xml";
		public static const TYPE_BINARY:String = "binary";
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		private static var dataLib:Dictionary = new Dictionary(true);
		private static var loadQueue:Array = new Array();
		
		private static var loader:Loader = new Loader();
		private static var runningLoader:Boolean = false;
		private static var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);

		
		private static var urlLoader:URLLoader = new URLLoader();
		private static var runningURLLoader:Boolean = false;
		
		private static var listenersDefined:Boolean = false;
		
		private static var totalItems:Number;
		
		public function DataLib():void {
		}
		
		public static function get lib():Dictionary {
			return dataLib;
		}
		
		public static function addItem(url:String, type:String, extra:Object = null):DataLibItem{
			return addItemAt(url, type, loadQueue.length, extra);
		}
		
		public static function addItemAt(url:String, type:String, index:Number, extra:Object = null):DataLibItem {
			if(url != "" && type != "" && index >= 0 && (type == TYPE_JPG || type == TYPE_GIF || type == TYPE_PNG || type == TYPE_SWF || type == TYPE_XML || type == TYPE_BINARY)){
				if(checkItem(url)){
					dataLib[url] = new DataLibItem(type);
				}				
				loadQueue.splice(index, 0, {url:url, type:type, extra:extra});
			}			
			return dataLib[url];
		}
		
		public static function removeItem(url:String):void{
			var i:Number = loadQueue.length;
			while(--i>-1){
				if(loadQueue[i].url == url){
					loadQueue.splice(i, 1);
					i = loadQueue.length;
				
					if(running){
						totalItems = loadQueue.length;
					}
				}
			}
			if(dataLib[url]){
				dataLib[url].dispose();
				dataLib[url] = null;
				delete dataLib[url];
				
				try {
					//System.gc();
				} catch (e:Error){
					//do nothing
				}
			}
		}
		
		public static function removeItemAt(index:Number):void{
			if(index < loadQueue.length && index >= 0){
				loadQueue.splice(index, 1);
				
				if(running){
					totalItems = loadQueue.length;
				}
			}
		}
		
		private static function checkItem(url:String):Boolean {
			var chk:Boolean = true;
			
			for(var i:Number = 0; i<loadQueue.length; i++){
				if(loadQueue[i].url == url){
					chk = false;
				}
			}
			
			if(dataLib[url] != null){
				chk = false;
			}
			
			return chk;
		}
		
		public static function get queue():Array {
			return loadQueue;
		}
		
		public static function load():void {
			if(!running){
				totalItems = loadQueue.length;
				
				loadNextItem();
			}
		}
		public static function close():void{
			if(runningLoader){
				try{
					loader.close();
				}catch(e:Error){
					trace(e);
				}
			}
			runningLoader = false;
				
			if(runningURLLoader){
				urlLoader.close();
			}
			runningURLLoader = false;
			
			for(var i:Number = 0; i<loadQueue.length; i++){
				dataLib[loadQueue[i].url].dispose();
				dataLib[loadQueue[i].url] = null;
				delete dataLib[loadQueue[i].url];
			}
			
			loadQueue.splice(0, loadQueue.length);
			totalItems = 0;
			
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, getError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, setProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, setData);
			
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, getError);
			urlLoader.removeEventListener(ProgressEvent.PROGRESS, setProgress);
			urlLoader.removeEventListener(Event.COMPLETE, setData);
			
			listenersDefined = false;
			
			try {
				//System.gc();
			} catch (e:Error){
				//do nothing
			}
		}
		
		public static function get running():Boolean {
			return runningLoader || runningURLLoader;
		}
		
		private static function loadNextItem():void{
			if(!listenersDefined){
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, getError);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, setProgress);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, setData);
				
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, getError);
				urlLoader.addEventListener(ProgressEvent.PROGRESS, setProgress);
				urlLoader.addEventListener(Event.COMPLETE, setData);
				
				listenersDefined = true;
			}
			if(loadQueue.length > 0){
				if(dataLib[loadQueue[0].url].data == undefined){
					if(loadQueue[0].type == TYPE_JPG || loadQueue[0].type == TYPE_GIF || loadQueue[0].type == TYPE_PNG || loadQueue[0].type == TYPE_SWF ){
						runningLoader = true;
						loader.load(new URLRequest(loadQueue[0].url), (loadQueue[0].type == TYPE_SWF)?loaderContext:null);
						//loader.load(new URLRequest(loadQueue[0].url));
					} else if(loadQueue[0].type == TYPE_XML){
						runningURLLoader = true;
						urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
						urlLoader.load(new URLRequest(loadQueue[0].url));
					} else if(loadQueue[0].type == TYPE_BINARY){
						runningURLLoader = true;
						urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
						urlLoader.load(new URLRequest(loadQueue[0].url));
					}
				} else {
					dataLib[loadQueue[0].url].dispatchEvent(new DataLibEvent(DataLibEvent.COMPLETE, false, false, {data:dataLib[loadQueue[0].url].data, url:loadQueue[0].url, extra:loadQueue[0].extra}));
					
					loadQueue.splice(0, 1);
					
					loadNextItem();
				}
			} else {
				dispatchEvent(new DataLibEvent(DataLibEvent.COMPLETE, false, false));
			}
		}
		
		private static function setData(e:Event):void{
			if(running){
				if(loadQueue[0].type == TYPE_JPG || loadQueue[0].type == TYPE_GIF || loadQueue[0].type == TYPE_PNG || loadQueue[0].type == TYPE_SWF){
					runningLoader = false;
					
					dataLib[loadQueue[0].url].data = e.currentTarget.content;
					
					loader.unload();
					
				} else if(loadQueue[0].type == TYPE_XML){
					runningURLLoader = false;
					
					dataLib[loadQueue[0].url].data = new XML(e.currentTarget.data);
				} else if(loadQueue[0].type == TYPE_BINARY){
					runningURLLoader = false;
					
					dataLib[loadQueue[0].url].data = e.currentTarget.data;
				}
				
				dataLib[loadQueue[0].url].dispatchEvent(new DataLibEvent(DataLibEvent.COMPLETE, e.bubbles, e.cancelable, {data:dataLib[loadQueue[0].url].data, url:loadQueue[0].url, extra:loadQueue[0].extra}));
				
				loadQueue.splice(0, 1);
				
				loadNextItem();
			}
		}
		private static function getError(e:IOErrorEvent):void{
			trace("DataLib ERROR\n\tURL not found: "+loadQueue[0].url);
			dispatchEvent(new DataLibEvent(DataLibEvent.ERROR));
			
			removeItem(loadQueue[0].url);
			
			load();
		}
		private static function setProgress(e:ProgressEvent):void{
			if(running){
				dataLib[loadQueue[0].url].dispatchEvent(new DataLibEvent(DataLibEvent.PROGRESS, e.bubbles, e.cancelable, {bytesLoaded:e.bytesLoaded, bytesTotal:e.bytesTotal}));
				dispatchEvent(new DataLibEvent(DataLibEvent.PROGRESS, e.bubbles, e.cancelable, {bytesLoaded:totalItems-loadQueue.length+e.bytesLoaded/e.bytesTotal, bytesTotal:totalItems}));
			}
		}
		
		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public static function dispatchEvent(evt : Event) : Boolean {
			return dispatcher.dispatchEvent(evt);
		}

		public static function hasEventListener(type : String) : Boolean {
			return dispatcher.hasEventListener(type);
		}

		public static function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		public static function willTrigger(type : String) : Boolean {
			return dispatcher.willTrigger(type);
		}
	}
}
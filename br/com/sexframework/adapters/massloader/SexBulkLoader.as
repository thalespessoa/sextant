package br.com.sexframework.adapters.massloader 
{
	import br.com.sexframework.api.ISexMassLoader;
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * Adaptador para o BulkLoader
	 * @author contato@thalespessoa.com.br
	 * @version 0.0.4
	 */
	public class SexBulkLoader implements ISexMassLoader
	{
		private var _percent:Number;
		private var _bulk:BulkLoader
		
		public function get progressEvent():String{return BulkProgressEvent.PROGRESS;}
		public function get completeEvent():String { return BulkProgressEvent.COMPLETE; }
		public function get hasQueue():Boolean { return _bulk.itemsTotal != _bulk.itemsLoaded; }
		public function get percent():Number { return _percent; }
		
		public function SexBulkLoader() 
		{
			_bulk = new BulkLoader("sextant-loader");
			_bulk.addEventListener(BulkLoader.PROGRESS, onProgress);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			_bulk.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			_bulk.removeEventListener(type, listener, useCapture);
		}
		
		public function getItem( id:String ):*
		{
			if ( !_bulk.get( id ) )
				return null;
			return _bulk.get( id ).content;
		}
		
		public function removeItem( id:String ):void
		{
			_bulk.remove( id );
		}
		
		public function addItem(... args):void
		{
			_bulk.add( args[0], {context:new LoaderContext( false, ApplicationDomain.currentDomain )} );
		}
		
		public function start():void
		{
			if( hasQueue )
				_bulk.start();
			else
				_bulk.dispatchEvent( new BulkProgressEvent( completeEvent ) );
		}
		
		public function close():void
		{
			_bulk.clear();
		}
		
		private function onProgress(e:BulkProgressEvent):void 
		{
			_percent = e.weightPercent;
		}		
	}
}
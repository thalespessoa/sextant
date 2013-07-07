package br.com.sexframework.adapters.massloader 
{
	import br.com.sexframework.api.ISexMassLoader;
	import com.andreanaya.datalib.DataLib;
	import com.andreanaya.datalib.DataLibEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Adaptador para o DataLib
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class SexDataLib implements ISexMassLoader
	{
		private var _percent:Number;
		
		public function get progressEvent():String{return DataLibEvent.PROGRESS;}
		public function get completeEvent():String { return DataLibEvent.COMPLETE; }
		public function get hasQueue():Boolean { return DataLib.queue.length > 0; }
		public function get percent():Number { return _percent; }
		
		public function SexDataLib() 
		{
			DataLib.addEventListener( DataLibEvent.PROGRESS, onProgress );
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			DataLib.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			DataLib.removeEventListener(type, listener, useCapture);
		}
		
		public function getItem( id:String ):*
		{
			if ( !DataLib.lib[id] )
				return null;
			return DataLib.lib[id].data;
		}
		
		public function removeItem( id:String ):void
		{
			return DataLib.removeItem( id );
		}
		
		public function addItem(... args):void
		{
			DataLib.addItem( args[0], args[1], args[2] );
		}
		
		public function start():void
		{
			DataLib.load();
		}
		
		public function close():void
		{
			DataLib.close();
		}
		
		private function onProgress(e:DataLibEvent):void 
		{
			_percent = e.bytesLoaded / e.bytesTotal;
		}		
	}
}
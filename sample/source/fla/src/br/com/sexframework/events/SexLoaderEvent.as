package br.com.sexframework.events 
{
	import flash.events.Event;
	
	/**
	 * Eventos para o loader visual
	 * @author contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class SexLoaderEvent extends Event
	{
		static public var SHOW_COMPLETE:String = "showComplete";
		static public var HIDE_COMPLETE:String = "hideComplete";
		static public var LOAD_COMPLETE:String = "loadComplete";
		
		public function SexLoaderEvent( type:String ) 
		{
			super( type );
		}		
	}	
}
package br.com.sexframework.core
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	internal class TransitionEvent extends Event
	{
		static public const INITIED		:String = "initied";
		static public const SHOWED		:String = "showed";
		static public const HIDDEN		:String = "hidden";
		static public const UPDATED		:String = "updated";		
		
		public function TransitionEvent( type:String ) 
		{
			super( type );
		}		
	}	
}
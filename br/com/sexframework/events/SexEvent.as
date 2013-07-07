package br.com.sexframework.events 
{
	import br.com.sexframework.api.IPageInfo;
	import flash.events.Event;
	
	/**
	 * Evento de navegação
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class SexEvent extends Event
	{
		static public const LOAD_START		:String = "load";
		static public const LOAD_COMPLETE	:String = "loaded";
		static public const INIT_START		:String = "init";
		static public const INIT_COMPLETE	:String = "initied";
		static public const SHOW_START		:String = "show";
		static public const SHOW_COMPLETE	:String = "showed";
		static public const HIDE_START		:String = "hide";
		static public const HIDE_COMPLETE	:String = "hidden";
		static public const UPDATE_START	:String = "update";
		static public const UPDATE_COMPLETE	:String = "updated";
		static public const NAVIGATE		:String = "navigate";
		
		private var _pageInfo:IPageInfo;
		
		public function get pageInfo():IPageInfo { return _pageInfo; }
		
		public function SexEvent( type:String, pageInfo:IPageInfo ) 
		{
			_pageInfo = pageInfo;
			super( type );
		}		
	}	
}
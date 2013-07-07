package br.com.sexframework.api 
{	
	/**
	 * Interface para loader visual
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public interface ISexLoader 
	{
		function set percent( value:Number ):void;
		function get currentPage():IPageInfo;
		function set currentPage( value:IPageInfo ):void;
		
		function show():void;		
		function hide():void;
		function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		function removeEventListener (type:String, listener:Function, useCapture:Boolean = false) : void;
	}	
}
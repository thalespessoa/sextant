package br.com.sexframework.api 
{
	
	/**
	 * Interface para qualquer lib de mass loader
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public interface ISexMassLoader 
	{
		function get hasQueue():Boolean;
		function get progressEvent():String;
		function get completeEvent():String;
		function get percent():Number;
		
		function getItem( id:String ):*;
		function addItem(... args):void;
		function removeItem( id:String ):void;
		function start():void;
		function close():void;
		function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true):void
		function removeEventListener(type : String, listener : Function, useCapture : Boolean = false):void
	}	
}
package br.com.sexframework.core
{	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	internal class DataTransition 
	{
		private var _pageNode:PageNode;
		private var _method:String;
		private var _param:Object;
		private var _isLoading:Boolean;
		
		function DataTransition( pageNode:PageNode, method:String, param:Object = null, isLoading:Boolean = false ) 
		{
			_pageNode = pageNode;
			_method = method;
			_param = param;
			_isLoading = isLoading;
		}
		
		public function toString():String 
		{
			return "[DataTransition = "+_pageNode+"."+_method+"]";
		}
		
		internal function get pageNode():PageNode { return _pageNode; }	
		internal function get method():String { return _method; }
		internal function get isLoading():Boolean { return _isLoading; }
		
		internal function get param():Object { return _param; }		
		internal function set param(value:Object):void 
		{
			_param = value;
		}
		
	}
	
}
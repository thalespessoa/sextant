package br.com.sexframework.vo 
{
	import flash.text.TextFormatAlign;
	
	/**
	 * Informações de um asset
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class AssetInfo 
	{
		private var _name:String;
		private var _src:String;
		private var _type:String;
		private var _useCache:Boolean;
		
		public function get name():String { return _name; }		
		public function get src():String { return _src; }		
		public function get type():String { return _type; }			
		public function get useCache():Boolean { return _useCache; }
		
		public function AssetInfo( name:String, src:String, type:String, useCache:Boolean ):void
		{
			_name = name;
			_src = src;
			_type = type;
			_useCache = useCache;
		}		
	}	
}
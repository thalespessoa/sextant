package br.com.sexframework.vo 
{
	import br.com.sexframework.api.IAssetInfo;
	import br.com.sexframework.api.IPageInfo;
	import br.com.sexframework.api.IPageNode;
	import br.com.sexframework.api.ISexLoader;
	import br.com.sexframework.api.ISexPage;
	import br.com.sexframework.api.IVariable;
	import br.com.sexframework.core.Sextant;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	/**
	 * Informações de uma página
	 * @author contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class PageInfo implements IPageInfo
	{
		static public const STATE_LOADING:uint = 0;
		static public const STATE_SHOW:uint = 1;
		static public const STATE_ACTIVE:uint = 2;
		static public const STATE_HIDE:uint = 3;
		static public const STATE_DESACTIVE:uint = 4;
		
		private var _id:String;
		private var _title:String;
		private var _className:String;
		private var _hash:String;
		private var _fullHash:String;
		private var _page:ISexPage;
		private var _assets:Array;
		private var _vars:Object;
		private var _loader:ISexLoader;
		private var _node:IPageNode;
		private var _containerSubPages:DisplayObjectContainer;
		private var _state:uint;
		private var _singleton:Boolean;
		private var _remove:Boolean;	
		
		/**
		 * Id da página indicado no xml de configuração
		 */ 
		public function get id():String { return _id; }	
		
		/**
		 *  Titulo da página indicado no xml de configuração. Este titulo sera mostrado na janela do navegador
		 */
		public function get title():String { return _title; }
		
		/**
		 * Hash da página indicado no xml de configuração. O hash mostrado no browser é a concatenação do hash da página co m o hash de seus pais
		 */ 
		public function get hash():String { return _hash; }		
		
		/**
		 * Concatenação do hash da página co m o hash de seus pais. Este é o endereço que sera mostrado no browser
		 */ 
		public function get fullHash():String { return _node.parent && _node.parent.info.hash ? _node.parent.info.fullHash + "/" + _hash: _hash; }
		public function set fullHash(value:String):void { _fullHash = value; }
		
		/**
		 * Página. Este valor existe somente quando a página esta aberta. Quando ele é fechado este valor é anulado
		 */
		public function get page():ISexPage { return _page; }	
		public function set page(value:ISexPage):void {	_page = value;}	
		
		/**
		 * Variaveis da página indicadas no xml de configuração
		 */
		public function get vars():Object { return _vars; }		
		
		/**
		 * Loader visual da página
		 */
		public function get loader():ISexLoader { return _loader; }		
		public function set loader(value:ISexLoader):void {_loader = value;}
		
		/**
		 * Nome da classe da página, indicado no xml de configuração
		 */
		public function get className():String { return _className; }
		
		/**
		 * DisplayObjectContainer onde as subpaginas desta página vão ser adicionadas. Se este valor não for definido suas subppaginas serão adicionadas na view da página
		 */
		public function get containerSubPages():DisplayObjectContainer { return _containerSubPages; }		
		public function set containerSubPages(value:DisplayObjectContainer):void { _containerSubPages = value;	}		
		public function get node():IPageNode { return _node; }
		
		/**
		 * Estado que a pagina se encontra. (PageInfo.STATE_LOADING, PageInfo.STATE_SHOW, PageInfo.STATE_ACTIVE, PageInfo.STATE_HIDE ou PageInfo.STATE_DESACTIVE)
		 */
		public function get state():uint { return _state; }		
		public function set state(value:uint):void { _state = value;	}	
		
		/**
		 * Assets da página indicado no xml de configuração
		 */	
		public function get assets():Array { return _assets; }		
		public function get singleton():Boolean { return _singleton; }		
		public function get remove():Boolean { return _remove; }
		
		
		public function PageInfo( id:String, title:String, className:String, hash:String, assets:Array, vars:Object, node:IPageNode, singleton:Boolean, remove:Boolean ) 
		{
			_id = id;
			_title = title;
			_className = className;
			_hash = hash;
			_assets = assets;
			_vars = vars;
			_node = node;
			_singleton = singleton;
			_remove = remove;
		}	
		
		/**
		 * Retorna um asset a partir do nome especificado no sitemap.xml
		 * 
		 * @param	assetName 	nome do asset
		 * @return
		 */
		public function getAsset( assetName:String ):*
		{
			var len:uint = assets.length;
			for (var i:uint = 0; i < len; i++) 
				if ( assets[i].name == assetName )
					return Sextant.massLoader.getItem(assets[i].src);
		}	
		
		/**
		 * Adiciona um asset na lista de carregamento da página
		 * 
		 * @param	asset	asset adicionado a lista de carregamento da página
		 */
		public function addAsset( asset:IAssetInfo ):void
		{
			assets.push( asset );
		}
		
		/**
		 * Remove um asset carregado da memoria
		 * 
		 * @param	assetName	nome do asset
		 */
		public function removeAssetFromMemory( name:String ):void
		{
			var len:uint = assets.length;
			for (var i:uint = 0; i < len; i++) 
				if ( assets[i].name == name )
					break;
					
			Sextant.massLoader.removeItem( assets[i].src );
		}
		
		/**
		 * Remove um asset da lista de carregamento da página
		 * 
		 * @param	assetName	nome do asset
		 */
		public function removeAssetFromList( name:String ):void
		{
			var len:uint = assets.length;
			for (var i:uint = 0; i < len; i++) 
				if ( assets[i].name == name )
					break;
					
			assets.splice( i , 1 );
		}
		
		/**
		 * Remove os assets de uma página que estão com o parametro 'useCache' definido como false
		 */
		public function checkAssestsCache():void
		{
			var len:uint = assets.length;
			for (var i:uint = 0; i < len; i++) 
				if ( assets[i].useCache == false )
					removeAssetFromMemory( assets[i].name );
		}
		
		/**
		 * Retorna uma variavel extra indicada no sitemap
		 * 
		 * @param	name	nome da variavel extra
		 * @return
		 */
		public function getVariable( name:String ):IVariable
		{
			return vars[name];
		}
		
		public function toString():String 
		{
			return "[PageInfo id: "+ _id +"]";
		}
	}	
}
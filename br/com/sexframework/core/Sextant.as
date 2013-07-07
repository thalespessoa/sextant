package br.com.sexframework.core
{
	import br.com.sexframework.api.IPageInfo;
	import br.com.sexframework.api.ISexAddress;
	import br.com.sexframework.api.ISexLoader;
	import br.com.sexframework.api.ISexMassLoader;
	import br.com.sexframework.events.SexEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * É disparado quando qualquer página da aplicação termina sua animação de saida
	 * @eventType br.com.sexframework.events.SexEvent.HIDE_COMPLETE
	 */
	[Event(name = "HIDE_COMPLETE", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação começa sua animação de saida
	 * @eventType br.com.sexframework.events.SexEvent.HIDE_START
	 */
	[Event(name = "HIDE_START", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação termina sua inicialização ( logo antes de ser adicionado no stage )
	 * @eventType br.com.sexframework.events.SexEvent.INIT_COMPLETE
	 */
	[Event(name = "INIT_COMPLETE", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação começa sua inicialização
	 * @eventType br.com.sexframework.events.SexEvent.INIT_COMPLETE
	 */
	[Event(name = "INIT_START", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação termina de carregar seus assets
	 * @eventType br.com.sexframework.events.SexEvent.LOAD_COMPLETE
	 */
	[Event(name = "LOAD_COMPLETE", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação termina de carregar seus assets
	 * @eventType br.com.sexframework.events.SexEvent.LOAD_COMPLETE
	 */
	[Event(name = "LOAD_COMPLETE", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação começa a carregar seus assets
	 * @eventType br.com.sexframework.events.SexEvent.LOAD_START
	 */
	[Event(name = "LOAD_START", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando o sextant começa a navegação até uma página
	 * @eventType br.com.sexframework.events.SexEvent.NAVIGATE
	 */
	[Event(name = "NAVIGATE", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação termina sua animação de entrada
	 * @eventType br.com.sexframework.events.SexEvent.SHOW_COMPLETE
	 */
	[Event(name = "SHOW_COMPLETE", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação começa sua animação de entrada
	 * @eventType br.com.sexframework.events.SexEvent.SHOW_START
	 */
	[Event(name = "SHOW_START", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação termina sua animação de atualização
	 * @eventType br.com.sexframework.events.SexEvent.UPDATE_COMPLETE
	 */
	[Event(name = "UPDATE_COMPLETE", type = "br.com.sexframework.events.SexEvent")] 
	
	/**
	 * É disparado quando qualquer página da aplicação começa sua animação de atualização
	 * @eventType br.com.sexframework.events.SexEvent.UPDATE_START
	 */
	[Event(name = "UPDATE_START", type = "br.com.sexframework.events.SexEvent")] 
	
	
	/**
	 * Classe principal
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.3
	 */
	public class Sextant 
	{
		static private var _siteTree:Tree = new Tree();
		static private var _pageList:Array = [];
		static private var _dispatcher:EventDispatcher = new EventDispatcher();
		static private var _mainNode:PageNode;
		static private var _stage:Stage;
		static private var _breadCrumb:Array;
		static private var _defaultLoader:ISexLoader;
		static private var _address:ISexAddress;
		static private var _massLoader:ISexMassLoader;
		static private var _bootLoader:URLLoader;
		static private var _siteLoader:ISexLoader;
		static private var _currentPage:IPageInfo;
		static private var _nextPage:IPageInfo;
		
		static public function get stage():Stage { return _stage; }
		
		/**
		 * PageInfo da main
		 */
		static public function get mainInfo():IPageInfo { return _mainNode.info; }
		
		/**
		 * Loader usado para páginas que não tenham loader definido
		 */
		static public function get defaultLoader():ISexLoader { return _defaultLoader; }		
		static public function set defaultLoader(value:ISexLoader):void { _defaultLoader = value; }
		
		static public function get breadCrumb():Array { return _breadCrumb; }
		static public function get pageList():Array { return _pageList; }		
		static public function set pageList(value:Array):void { _pageList = value;}	
		static public function get massLoader():ISexMassLoader { return _massLoader; }		
		static public function get currentPage():IPageInfo { return _currentPage; }		
		static public function get nextPage():IPageInfo { return _nextPage; }
		
		/**
		 * 
		 * @param	mapSrc				caminho para o xml de configuração
		 * @param	stage				stage da aplicação
		 * @param	massLoader			classe de mass loader ( deve implementar ISexMassLoader )	
		 * Ex.: new SexDataLib(), new SexBulkLoader()
		 * @param	address				classe de Deep linking ( deve implementar ISexMassLoader )
		 * Ex.: new SexSWFAddress()
		 * @param	loader				loader visual
		 */
		static public function boot( mapSrc:String, stage:Stage, massLoader:ISexMassLoader, address:ISexAddress, loader:ISexLoader = null ):void
		{
			_address = address;
			_massLoader = massLoader;
			_siteLoader = loader;
			_stage = stage;
			
			_bootLoader = new URLLoader();
			_bootLoader.addEventListener( Event.COMPLETE, loadMapHandler );
			_bootLoader.load(new URLRequest( mapSrc ));
		}
		
		/**
		 * Navega até uma página qualquer
		 * @param	pageId		Id da página destino
		 * @param	param		Parametros envados por Query string
		 */
		static public function navigateTo( pageId:String, param:Object = null ):void
		{
			_address.change( getPageByProperty("id", pageId).fullHash, param );
		}
		
		/**
		 * Retorna o pageInfo de uma página através de uma propriedade qualquer
		 * @param	property	Nome da propriedade especificada no sitemap.xml
		 * @param	value		Valor da propriedade especificada no sitemap.xml
		 * @return
		 */
		static public function getPageByProperty( property:String, value:String ):IPageInfo
		{
			var len:uint = _pageList.length;
			for (var i:uint = 0; i < len; i++) 
				if ( _pageList[i][property] == value )
					break;
					
			return _pageList[i];
		}
		
		/**
		 * Retorna o pageInfo de uma página através do id indicado no xm lde configuração
		 * @param	id			Id especificado no xml de configuração
		 * @return
		 */
		static public function getPageById( id:String ):IPageInfo
		{
			return getPageByProperty( "id", id );
		}
		
		static public function addChildPages( parentId:String, pagesDefinition:XML ):void
		{
		       _siteTree.addChildPages( parentId, pagesDefinition.children() );
		}
		
		static public function createBreadCrumb( path:String, param:Object ):void
		{
			var hash:Array = path.split("/");
			_breadCrumb = _siteTree.getPageByHash( hash );		
			
			dispatchEvent( new SexEvent( SexEvent.NAVIGATE, _breadCrumb[ _breadCrumb.length - 1 ] ) );
			
			if ( _breadCrumb )
			{
				_mainNode.subPages.createStackTransition( _breadCrumb );
				TransitionControl.param = param;
				TransitionControl.currentTransition || TransitionControl.executeNext();
			}
		}	
		
		//--------------------------------------------------------------------------------------------------------------
		// internal
		//--------------------------------------------------------------------------------------------------------------
		
		static internal function createTree( map:XML, loaderSite:ISexLoader ):void
		{
			_mainNode = new PageNode( map.main[0], null );
			_pageList.push( mainInfo );
			_mainNode.info.loader = loaderSite;
			_siteTree.create( map.main.page, _mainNode );
			_address.init(map.main[0].page[0].@hash);
		}	
		
		//--------------------------------------------------------------------------------------------------------------
		// private
		//--------------------------------------------------------------------------------------------------------------
		
		static private function loadMapHandler(e:Event):void 
		{
			e.target.removeEventListener(Event.COMPLETE, loadMapHandler);
			createTree( XML( e.target.data ), _siteLoader );
			_siteLoader = null;
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// eventos
		//--------------------------------------------------------------------------------------------------------------
		/**
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		static public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			_dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		/**
		 * 
		 * @param	type
		 * @param	listener
		 */
		static public function removeEventListener( type:String, listener:Function ):void
		{
			_dispatcher.removeEventListener( type, listener );
		}
		
		/**
		 * 
		 * @param	type
		 */
		static public function hasEventListener( type:String ):void
		{
			_dispatcher.hasEventListener( type );
		}
		
		/**
		 * 
		 * @param	event
		 */
		static internal function dispatchEvent( event:SexEvent ):void
		{
			if ( event.type == SexEvent.NAVIGATE )	_nextPage = event.pageInfo;
			if ( event.type == SexEvent.SHOW_START )_currentPage = event.pageInfo;
			if ( event.type == SexEvent.UPDATE_START )_currentPage = event.pageInfo;
			
			_dispatcher.dispatchEvent( event );
		}
	}	
}
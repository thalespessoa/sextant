package br.com.sexframework.core
{
	import br.com.sexframework.api.IPageInfo;
	import br.com.sexframework.api.ISexLoader;
	import br.com.sexframework.api.ISexAddress;
	import br.com.sexframework.api.ISexMassLoader;	
	import br.com.sexframework.events.SexEvent;
	import br.com.sexframework.vo.PageInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * Classe principal
	 * @author Thales Pessoa | contato@thalespessoa.com.br
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
		
		static internal function createTree( map:XML, stage:Stage, loaderSite:ISexLoader ):void
		{
			_stage = stage;
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
			createTree( XML( e.target.data ), _stage, _siteLoader );
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
			_dispatcher.dispatchEvent( event );
		}
	}	
}
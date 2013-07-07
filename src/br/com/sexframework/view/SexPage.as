package br.com.sexframework.view 
{
	import br.com.sexframework.api.IPageInfo;
	import br.com.sexframework.api.IVariable;
	import br.com.sexframework.events.SexEvent;
	import br.com.sexframework.api.ISexPage;
	import br.com.sexframework.vo.PageInfo;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class SexPage extends Sprite implements ISexPage
	{
		private var _pageInfo:IPageInfo;
		
		public function get view():DisplayObject { return this; }
		public function get pageInfo():IPageInfo { return _pageInfo; }
		public function set pageInfo(value:IPageInfo):void { _pageInfo = value; }
		
		public function get containerSubPages():DisplayObjectContainer { return pageInfo.containerSubPages }
		public function set containerSubPages(value:DisplayObjectContainer):void {pageInfo.containerSubPages = value;}
		
		public function SexPage() 
		{
			
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// Public - Abstract
		//--------------------------------------------------------------------------------------------------------------
		
		public function init():void { onInit(); }		
		public function update(param:Object):void { onUpdate(); }		
		public function show(param:Object = null):void { onShow(); }		
		public function hide():void { onHide(); }
		public function dispose():void {}
		
		//--------------------------------------------------------------------------------------------------------------
		// Public
		//--------------------------------------------------------------------------------------------------------------
		
		/**
		 * Retorna um asset a partir do nome especificado no sitemap.xml
		 * 
		 * @param	assetName 	nome do asset
		 * @return
		 */
		protected function getAsset( assetName:String ):*
		{
			return _pageInfo.getAsset( assetName );
		}	
		
		/**
		 * 
		 * @param	assetName	nome do asset
		 */
		protected function removeAsset( assetName:String ):void
		{
			return _pageInfo.removeAssetFromMemory( assetName );
		}
		
		/**
		 * Retorna uma variavel extra indicada no sitemap
		 * 
		 * @param	name	nome da variavel extra
		 * @return
		 */
		protected function getVariable( name:String ):IVariable
		{
			return _pageInfo.getVariable( name );
		}
		
		public function onInit(e:Event=null):void
		{
			dispatchEvent( new SexEvent( SexEvent.INIT_COMPLETE, pageInfo ) );
		}
		
		public function onShow(e:Event=null):void
		{
			dispatchEvent( new SexEvent( SexEvent.SHOW_COMPLETE, pageInfo ) );
		}
		
		public function onUpdate(e:Event=null):void
		{
			dispatchEvent( new SexEvent( SexEvent.UPDATE_COMPLETE, pageInfo ) );
		}
		
		public function onHide(e:Event=null):void
		{
			dispatchEvent( new SexEvent( SexEvent.HIDE_COMPLETE, pageInfo ) );
		}
	}	
}
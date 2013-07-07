package br.com.sexframework.view 
{
	import br.com.sexframework.api.IPageInfo;
	import br.com.sexframework.api.ISexLoader;
	import br.com.sexframework.api.ISexPage;
	import br.com.sexframework.events.SexLoaderEvent;
	import br.com.sexframework.vo.PageInfo;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class SexLoader extends Sprite implements ISexLoader
	{
		private var _currentPage:IPageInfo;
		
		public function set percent( value:Number ):void{}
		
		public function get currentPage():IPageInfo{	return _currentPage; }		
		public function set currentPage( value:IPageInfo ):void{	_currentPage = value; }
		
		public function SexLoader() 
		{
			
		}
		
		public function show():void{}		
		public function hide():void{}
		
		public function onShow():void
		{
			dispatchEvent( new SexLoaderEvent( SexLoaderEvent.SHOW_COMPLETE ) );
		}
		
		public function onHide():void
		{
			dispatchEvent( new SexLoaderEvent( SexLoaderEvent.HIDE_COMPLETE ) );
		}
	}	
}
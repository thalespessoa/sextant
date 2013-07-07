package br.com.sexframework.api 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * Interface para PageInfo
	 * @author contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public interface IPageInfo
	{
		/**
		 * Id da página indicado no xml de configuração
		 */ 
		function get id():String;
		
		/**
		 *  Titulo da página indicado no xml de configuração. Este titulo sera mostrado na janela do navegador
		 */
		function get title():String;
		
		/**
		 * Hash da página indicado no xml de configuração. O hash mostrado no browser é a concatenação do hash da página co m o hash de seus pais
		 */ 
		function get hash():String;	
		
		/**
		 * Concatenação do hash da página co m o hash de seus pais. Este é o endereço que sera mostrado no browser
		 */ 
		function get fullHash():String;
		function set fullHash(value:String):void;
		
		/**
		 * Página. Este valor existe somente quando a página esta aberta. Quando ele é fechado este valor é anulado
		 */
		function get page():ISexPage;			
		function set page(value:ISexPage):void;
		
		/**
		 * Variaveis da página indicadas no xml de configuração
		 */
		function get vars():Object;
		
		/**
		 * Loader visual da página
		 */
		function get loader():ISexLoader;	
		function set loader(value:ISexLoader):void;
		
		/**
		 * Nome da classe da página, indicado no xml de configuração
		 */
		function get className():String;
		
		function get node():IPageNode;
		
		/**
		 * Estado que a pagina se encontra. (PageInfo.STATE_LOADING, PageInfo.STATE_SHOW, PageInfo.STATE_ACTIVE, PageInfo.STATE_HIDE ou PageInfo.STATE_DESACTIVE)
		 */
		function get state():uint;
		function set state(value:uint):void;
		
		/**
		 * Assets da página indicado no xml de configuração
		 */
		function get assets():Array;
		
		/**
		 * DisplayObjectContainer onde as subpaginas desta página vão ser adicionadas. Se este valor não for definido suas subppaginas serão adicionadas na view da página
		 */
		function get containerSubPages():DisplayObjectContainer;
		function set containerSubPages(value:DisplayObjectContainer):void;	
		
		/**
		 * Retorna um asset através do nome indicado no xml de configuração
		 * 
		 * @param	assetName 	nome do asset
		 * @return
		 */
		function getAsset( assetName:String ):*;
		
		/**
		 * Adiciona um novo asset na lista de carregamento de uma página
		 * 
		 * @param	asset	asset adicionado a lista de carregamento da página
		 */
		function addAsset( asset:IAssetInfo ):void;
		
		/**
		 * Remove um asset da memoria
		 * 
		 * @param	assetName	nome do asset
		 */
		function removeAssetFromMemory( name:String ):void;
		
		/**
		 * Remove um asset da lista de carregamento de uma página
		 * 
		 * @param	assetName	nome do asset
		 */
		function removeAssetFromList( name:String ):void;
		
		/**
		 * Retorna uma variável através do nome indicado no xml de configuração
		 * 
		 * @param	name	nome da variavel extra
		 * @return
		 */
		function getVariable( name:String ):IVariable;
		
		/**
		 * Remove os assets de uma página que estão com o parametro 'useCache' definido como false
		 */
		function checkAssestsCache():void;
	}	
}
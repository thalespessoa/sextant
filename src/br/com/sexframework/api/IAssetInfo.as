package br.com.sexframework.api 
{
	
	/**
	 * Interface para AssetInfo
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public interface IAssetInfo 
	{
		/**
		 * Nome do asset, indicado no xml de configuração
		 */
		function get name():String;	
		
		/**
		 * Caminho do asset, indicado no xml de configuração
		 */
		function get src():String;
		
		/**
		 * Tipo do asset, indicado no xml de configuração
		 */
		function get type():String;
		
		/**
		 * Indica se o asset vai ser descarregado da memoria quando a página que ele pertence fechar
		 */
		function get useCache():Boolean;
	}	
}
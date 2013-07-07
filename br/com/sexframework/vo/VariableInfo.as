package br.com.sexframework.vo 
{
	import br.com.sexframework.api.IVariable;
	
	/**
	 * Informações de uma varivel
	 * @author contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class VariableInfo implements IVariable
	{
		private var _name:String;
		private var _value:String;
		
		/**
		 * Nome da variável, indicado no xml de configuração
		 */
		public function get name():String { return _name; }	
		
		/**
		 * Valor da variavel
		 */
		public function get value():String { return _value; }		
		public function set value(value:String):void {_value = value;}
		
		public function VariableInfo( name:String, value:String ) 
		{
			_name = name;
			_value = value;
		}		
	}	
}
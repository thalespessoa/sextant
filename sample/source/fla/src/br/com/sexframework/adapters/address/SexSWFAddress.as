package br.com.sexframework.adapters.address
{
	import br.com.sexframework.core.Sextant;
	import br.com.sexframework.api.ISexAddress;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	/**
	 * Adaptador para o SWFAddress
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class SexSWFAddress implements ISexAddress
	{
		private var _homeHash:String;
		
		public function get path():String 
		{
			return SWFAddress.getPath() == "/" ? "/"+_homeHash : SWFAddress.getPath();
		}
		
		public function get param():Object 
		{
			return SWFAddress.getParameterNames().length > 0 ? convertQStringToParam() : null;
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// public
		//--------------------------------------------------------------------------------------------------------------
		
		public function change( path:String, param:Object ):void
		{
			if ( param )
			{
				path = path.concat( "?" );
				for ( var name:String in param )
					path = path.concat( name + "=" + param[ name ] + "&" );
					
				path = path.substring( 0, path.length-1 );
			}
			
			SWFAddress.setValue( path );
		}
		
		public function init( homeHash:String ):Boolean
		{
			_homeHash = homeHash;
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE, onChangeAddress );
			return true;
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// private
		//--------------------------------------------------------------------------------------------------------------
		
		private function convertQStringToParam():Object
		{
			var parameters:Object = { };
			var parametersNames:Array = SWFAddress.getParameterNames();
			var len:uint = parametersNames.length;
			for (var i:uint = 0; i < len; i++) 
				parameters[parametersNames[i]] = SWFAddress.getParameter(parametersNames[i]);
			
            return parameters;
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// listeners
		//--------------------------------------------------------------------------------------------------------------
		
		private function onChangeAddress( e:SWFAddressEvent ):void 
		{
			if ( e.path == "/" )
			{
				SWFAddress.setValue( _homeHash );
				return;
			}
			
			var path	:String = e.path;
			var param	:Object = e.parametersNames.length > 0 ? e.parameters : null;
			
			SWFAddress.setTitle( Sextant.getPageByProperty( "fullHash", path.substr(1) ).title );
			
			Sextant.createBreadCrumb( path, param );
		}	
	}	
}
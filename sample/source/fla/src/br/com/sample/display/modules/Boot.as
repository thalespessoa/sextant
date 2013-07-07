package br.com.sample.display.modules 
{
	import br.com.sample.display.loaders.SiteLoader;
	import br.com.sexframework.adapters.address.SexSWFAddress;
	import br.com.sexframework.adapters.massloader.SexDataLib;
	import br.com.sexframework.core.Sextant;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 */
	public class Boot extends Sprite
	{
		Main, Page1, Page2, Page3, Page4;
		
		public function Boot() 
		{
			stage.align = StageAlign.TOP_LEFT;
			var loader:SiteLoader = new SiteLoader( stage );
			addChild( loader );
			Sextant.defaultLoader = loader;
			Sextant.boot( "xml/sitemap.xml", stage, new SexDataLib(), new SexSWFAddress(), loader );
		}
	}	
}
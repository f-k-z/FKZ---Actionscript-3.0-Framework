package fkz.utils 
{
	/**
	 * ...
	 * @author Francois.Gillet/Soleil Noir
	 */
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class Definition
	{
		public static function hasDefinition( name : String, loaderContext : LoaderContext ) : Boolean
		{
			return loaderContext.applicationDomain.hasDefinition( name );
		}
		
		public static function getByName( name : String, loaderContext : LoaderContext = null ) : Class
		{
			if ( loaderContext == null )
				loaderContext = new LoaderContext( false, ApplicationDomain.currentDomain );
				
			return loaderContext.applicationDomain.getDefinition( name ) as Class;
		}
	}

}
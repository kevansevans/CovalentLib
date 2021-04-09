package covalent.component;

/**
 * ...
 * @author Kaelan
 */
class MapBase 
{
	public var properties:MapProperties;
	public function new(_properties:MapProperties) 
	{
		properties = _properties;
	}
	
}
typedef MapProperties = {
	var locationID:Int;
	var blocks:Array<Int>;
	var width:Int;
	var height:Int;
	var fillerID:Int;
	var musicID:Int;
}
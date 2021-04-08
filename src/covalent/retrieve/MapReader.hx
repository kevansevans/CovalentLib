package retrieve;

import component.MapBase;
import enums.maps.MapGroup;
import enums.maps.MapIndex;

import enums.Bank;

import typedefs.RomPointer;

/**
 * ...
 * @author Kaelan
 */
class MapReader 
{
	
	static var data:Array<Int>;
	
	public static var mapHeaderSize:Int = 12;
	
	public static function getMap(_group:MapGroup, _index:MapIndex):MapBase {
		
		var mapHeaderA:HeaderA;
		var mapHeaderB:HeaderB;
		var blocks:Array<Int>;
		
		var data = Main.romData;
		
		var mapPointer = (_index * 9) + (((data[(0x25 * 0x4000) + (_group * 2) + 1]) << 8 | (data[(0x25 * 0x4000) + (_group * 2)])) & 0x3FFF) + (0x25 * 0x4000);
		
		mapHeaderA = {
			secondPart : data[mapPointer],
			tileID : data[mapPointer + 1],
			permission : data[mapPointer + 2],
			secondary : data[mapPointer + 4] << 8 | data[mapPointer + 3],
			location : data[mapPointer + 5],
			music : data[mapPointer + 6],
			phonepalette : data[mapPointer + 7],
			fishing : data[mapPointer + 8],
		}
		
		var offset = (mapHeaderA.secondPart * 0x4000) + (mapHeaderA.secondary & 0x3FFF);
		
		mapHeaderB = {
			fillID : data[offset],
			height : data[offset + 1],
			width : data[offset + 2],
			blockDataBank : data[offset + 3],
			blockDataPointer : data[offset + 5] << 8 | data[offset + 4],
			scriptsEventsBanks : data[offset + 6],
			scriptsPointer : data[offset + 8] << 8 | data[offset + 7],
			eventsPointer : data[offset + 10] << 8 | data[offset + 9],
			directionEnabled : data[offset + 11]
		}
		
		blocks = new Array();
		
		var blockLocation:Int = (mapHeaderB.blockDataBank * 0x4000) + (mapHeaderB.blockDataPointer & 0x3FFF);
		
		for (item in 0...(mapHeaderB.width * mapHeaderB.height)) {
			blocks.push(data[blockLocation + item]);
		}
		
		var mapdata:MapProperties = {
			locationID : mapHeaderA.location,
			//blocks : blocks,
			width : mapHeaderB.width,
			height : mapHeaderB.height,
			fillerID : mapHeaderB.fillID,
			musicID : mapHeaderA.music
		}
		
		return new MapBase(mapdata);
	}	
}
typedef HeaderA = {
	var secondPart:Int;
	var tileID:Int;
	var permission:Int;
	var secondary:Int;
	var location:Int;
	var music:Int;
	var phonepalette:Int;
	var fishing:Int;
}
typedef HeaderB = {
	var fillID:Int;
	var width:Int;
	var height:Int;
	var blockDataBank:Int;
	var blockDataPointer:Int;
	var scriptsEventsBanks:Int;
	var scriptsPointer:Int;
	var eventsPointer:Int;
	var directionEnabled:Int;
}
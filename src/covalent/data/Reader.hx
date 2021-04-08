package covalent.data;

import covalent.typedefs.MapHeaderPrimary;
import covalent.typedefs.MapHeaderSecondary;
import covalent.enums.maps.MapGroup;
import covalent.enums.maps.MapIndex;
import covalent.component.MapBase;

/**
 * ...
 * @author Kaelan
 */
class Reader 
{

	public static inline var bankRange:Int = 0x3FFF;
	
	public static function getSprite(_bankOffset:Int, _spriteIndex:Int):Array<Array<Int>> {
		
		var data = Main.romData;
		
		var out:Array<Array<Int>> = [];
		
		for (y in 0...8) {
			var cur = [0, 0, 0, 0, 0, 0, 0, 0];
			for (b in 0...2) {
				for (i in 0...8) {
					var mask = 1 << i;
					cur[7 - i] |= ((data[_bankOffset + _spriteIndex * 16 + y * 2 + b] & mask) >> i) << b;
				}
			}
			out.push(cur);
		}
		
		return out;
	}
	
	public static function getMap(_group:MapGroup, _index:MapIndex):MapBase {
		
		var mapHeaderA:MapHeaderPrimary;
		var mapHeaderB:MapHeaderSecondary;
		var blocks:Array<Int>;
		
		var data = Main.romData;
		
		var mapPointer = (_index * 9) + (((data[(0x25 * 0x4000) + (_group * 2) + 1]) << 8 | (data[(0x25 * 0x4000) + (_group * 2)])) & 0x3FFF) + (0x25 * 0x4000);
		
		mapHeaderA = {
			secondaryBank : data[mapPointer],
			tileID : data[mapPointer + 1],
			permission : data[mapPointer + 2],
			secondary : data[mapPointer + 4] << 8 | data[mapPointer + 3],
			location : data[mapPointer + 5],
			music : data[mapPointer + 6],
			phonepalette : data[mapPointer + 7],
			fishing : data[mapPointer + 8],
		}
		
		var offset = (mapHeaderA.secondaryBank * 0x4000) + (mapHeaderA.secondary & 0x3FFF);
		
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
package com.adobe.ac.mxeffects
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
		
	public class Lighting
	{		
		public var direction : String;
		public var horizontalLightingLocation : String;
		public var verticalLightingLocation : String;
		public var lightingStrengthDefault : Number = 7.5;
		
		private var _lightingStrength : Number;
		
		public function get lightingStrength() : Number
		{
			return convertToExternalLightingStrength( _lightingStrength );
		}
		
		public function set lightingStrength( value : Number ) : void
		{
			_lightingStrength = convertToInternalLightingStrength( value );
		}
		
		public function getUpdateMethod( toBlack : Function, 
													toWhite : Function, 
													noLighting : Function ) : Function
		{
			var updateMethod : Function;
			if( goBlack() )
			{
				updateMethod = toBlack
			}
			else if( goWhite() )
			{
				updateMethod = toWhite;
			}
			else
			{
				updateMethod = noLighting;
			}
			return updateMethod;	
		}		
		
		public function goBlack() : Boolean
		{
			return goBlackForHorizontal() || goBlackForVertical();
		}
		
		public function goWhite() : Boolean
		{
			return goWhiteForHorizontal() || goWhiteForVertical();
		}
		
		public function toBlack( value : Number ) : Number
		{
			return value / 100 * -1 / _lightingStrength;
		}
		
		public function toWhite( value : Number ) : Number
		{
			return ( 100 - value ) / 100 / _lightingStrength;
		}		
		
		public function fromWhite( value : Number ) : Number
		{
			return value / 100 / _lightingStrength;
		}
		
		public function fromBlack( value : Number ) : Number
		{
			return ( 100 - value ) / 100 * -1 / _lightingStrength;
		}
		
		public function setBrightness( displayObject : DisplayObject, bright : Number ) : void 
		{
			var trans : ColorTransform = displayObject.transform.colorTransform;
			trans.redMultiplier = trans.greenMultiplier = trans.blueMultiplier = 1 - Math.abs( bright );
			trans.redOffset = trans.greenOffset = trans.blueOffset = (bright > 0) ? bright * ( 256 / 1 ) : 0;
			displayObject.transform.colorTransform = trans;
		}
		
		private function convertToInternalLightingStrength( value : Number ) : Number
		{
			if( isNaN( value ) ) value = lightingStrengthDefault;
			value *= 10;
			value = ( 100 - value );
			return ( value / 100 * 6 );
		}
		
		private function convertToExternalLightingStrength( value : Number ) : Number
		{
			return ( value / 6 * 100 );
		}
				
		private function goBlackForHorizontal() : Boolean
		{
			return ( ( horizontalLightingLocation == DistortionConstants.LEFT 
						&& direction == DistortionConstants.RIGHT ) 					
					|| ( horizontalLightingLocation == DistortionConstants.RIGHT 
						&& direction == DistortionConstants.LEFT ) );
		}
		
		private function goBlackForVertical() : Boolean
		{
			return ( ( verticalLightingLocation == DistortionConstants.TOP 
						&& direction == DistortionConstants.BOTTOM )	
					||	( verticalLightingLocation == DistortionConstants.BOTTOM 
						&& direction == DistortionConstants.TOP ) );
		}
		
		private function goWhiteForHorizontal() : Boolean
		{
			return ( ( horizontalLightingLocation == DistortionConstants.LEFT 
						&& direction == DistortionConstants.LEFT ) 
					|| ( horizontalLightingLocation == DistortionConstants.RIGHT 
						&& direction == DistortionConstants.RIGHT ) );
		}
		
		private function goWhiteForVertical() : Boolean
		{
			return ( ( verticalLightingLocation == DistortionConstants.TOP 
						&& direction == DistortionConstants.TOP )
					|| ( verticalLightingLocation == DistortionConstants.BOTTOM 
						&& direction == DistortionConstants.BOTTOM ) );
		}
	}
}
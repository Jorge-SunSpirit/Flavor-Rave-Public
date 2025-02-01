package shaders;

import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxShader;

class InvertMaskShader extends FlxShader
{
	@:glFragmentSource('
	#pragma header

	uniform sampler2D alphaMask;

	void main(){
		vec4 baseColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		vec4 maskColor = flixel_texture2D(alphaMask, openfl_TextureCoordv);
		vec3 normalColor = vec3(0.0);

		if(baseColor.a > 0.0){
			normalColor = vec3(baseColor.rgb / baseColor.a);
		}

		vec3 invertColor = vec3(1.0 - normalColor.rgb);
		vec3 finalColor = mix(normalColor, invertColor, maskColor.a);
		gl_FragColor = vec4(mix(normalColor, invertColor, maskColor.a) * baseColor.a, baseColor.a);
	}
	')

	public function new()
	{
		super();
	}
}

class InvertMask
{
	public var shader(default, null):InvertMaskShader = new InvertMaskShader();
	public var mask(default, set):FlxGraphic;

	private function set_mask(value:FlxGraphic)
	{
		mask = value;
		shader.alphaMask.input = value.bitmap;
		return mask;
	}

	public function new(mask:FlxGraphic)
	{
		this.mask = mask;
	}
}

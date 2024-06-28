package shaders;

import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxShader;

class DifferenceShaderData extends FlxShader
{
	@:glFragmentSource('
	#pragma header

	uniform sampler2D mask;

	void main()
	{
		vec4 mask = flixel_texture2D(mask, openfl_TextureCoordv.xy);

		vec4 texture = flixel_texture2D(bitmap, openfl_TextureCoordv.xy) / openfl_Alphav;
		float alpha = texture.a * mask.a * openfl_Alphav;

		gl_FragColor = vec4(abs(mask - texture) * alpha);
	}
	')

	public function new()
	{
		super();
	}
}

class DifferenceShader
{
	public var shader(default, null):DifferenceShaderData = new DifferenceShaderData();
	public var mask(default, set):FlxGraphic;

	private function set_mask(value:FlxGraphic)
	{
		mask = value;
		shader.mask.input = value.bitmap;
		return mask;
	}

	public function new(mask:FlxGraphic)
	{
		this.mask = mask;
	}
}

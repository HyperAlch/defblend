varying mediump vec2 var_texcoord0;

uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp vec4 blend;

float color_dodge(float base, float blend) {
	return (blend==1.0)?blend:min(base/(1.0-blend),1.0);
}

float color_burn(float base, float blend) {
	return (blend==0.0)?blend:max((1.0-((1.0-base)/blend)),0.0);
}

float vivid_light(float base, float blend) {
	return (blend<0.5)?color_burn(base,(2.0*blend)):color_dodge(base,(2.0*(blend-0.5)));
}

float hard_mix(float base, float blend) {
	return (vivid_light(base,blend)<0.5)?0.0:1.0;
}

void main()
{
	vec4 base = texture2D(DIFFUSE_TEXTURE, var_texcoord0.xy);
	vec4 blended = vec4(hard_mix(base.r,blend.r), hard_mix(base.g,blend.g), hard_mix(base.b,blend.b), blend.w);
	vec4 color = vec4(blended.rgb * blended.a +  base.rgb * (1.0 - blended.a), base.w);
	base.rgba = color * base.w;
	gl_FragColor = base;
}

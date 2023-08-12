// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Lordenfel/Mauntains"
{
	Properties
	{
		_SnowAlbedo("Snow Albedo", 2D) = "white" {}
		_SnowNormal("Snow Normal", 2D) = "white" {}
		_TilingSnow("Tiling Snow", Float) = 1
		_SnowSmoothness("Snow Smoothness", Float) = 0.2
		_GrassAlbedo("Grass Albedo", 2D) = "white" {}
		_GrassNormal("Grass Normal", 2D) = "white" {}
		_TilingGrass("Tiling Grass", Float) = 1
		_GrassSmoothnessMin("Grass Smoothness Min", Float) = 0.2
		_GrassSmoothnessMax("Grass Smoothness Max", Float) = 0.8
		_RockAlbedo("Rock Albedo", 2D) = "white" {}
		_RockNormal("Rock Normal", 2D) = "white" {}
		_TilingRock("Tiling Rock", Float) = 1
		_RockSmoothnessMin("Rock Smoothness Min", Float) = 0.2
		_RockSmoothnessMax("Rock Smoothness Max", Float) = 0.8
		_BakedNormal("Baked Normal", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		[Toggle(_ONLYSNOW_ON)] _OnlySnow("Only Snow", Float) = 0
		[Toggle(_ONLYGRASS_ON)] _OnlyGrass("Only Grass", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature _ONLYSNOW_ON
		#pragma shader_feature _ONLYGRASS_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _RockNormal;
		uniform float _TilingRock;
		uniform sampler2D _GrassNormal;
		uniform float _TilingGrass;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform sampler2D _SnowNormal;
		uniform float _TilingSnow;
		uniform sampler2D _BakedNormal;
		uniform float4 _BakedNormal_ST;
		uniform sampler2D _RockAlbedo;
		uniform sampler2D _GrassAlbedo;
		uniform sampler2D _SnowAlbedo;
		uniform float _RockSmoothnessMin;
		uniform float _RockSmoothnessMax;
		uniform float _GrassSmoothnessMin;
		uniform float _GrassSmoothnessMax;
		uniform float _SnowSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_TilingRock).xx;
			float2 uv_TexCoord16 = i.uv_texcoord * temp_cast_0;
			float3 tex2DNode8 = UnpackNormal( tex2D( _RockNormal, uv_TexCoord16 ) );
			float2 temp_cast_1 = (_TilingGrass).xx;
			float2 uv_TexCoord15 = i.uv_texcoord * temp_cast_1;
			float3 tex2DNode6 = UnpackNormal( tex2D( _GrassNormal, uv_TexCoord15 ) );
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode9 = tex2D( _Mask, uv_Mask );
			float3 lerpResult43 = lerp( tex2DNode8 , tex2DNode6 , tex2DNode9.r);
			float2 temp_cast_2 = (_TilingSnow).xx;
			float2 uv_TexCoord14 = i.uv_texcoord * temp_cast_2;
			float3 tex2DNode2 = UnpackNormal( tex2D( _SnowNormal, uv_TexCoord14 ) );
			float3 lerpResult46 = lerp( lerpResult43 , tex2DNode2 , tex2DNode9.g);
			float3 lerpResult45 = lerp( tex2DNode8 , tex2DNode6 , tex2DNode9.b);
			#ifdef _ONLYGRASS_ON
				float3 staticSwitch48 = lerpResult45;
			#else
				float3 staticSwitch48 = lerpResult46;
			#endif
			float3 lerpResult44 = lerp( tex2DNode8 , tex2DNode2 , tex2DNode9.a);
			#ifdef _ONLYSNOW_ON
				float3 staticSwitch49 = lerpResult44;
			#else
				float3 staticSwitch49 = lerpResult46;
			#endif
			#ifdef _ONLYSNOW_ON
				float3 staticSwitch53 = staticSwitch49;
			#else
				float3 staticSwitch53 = staticSwitch48;
			#endif
			float2 uv_BakedNormal = i.uv_texcoord * _BakedNormal_ST.xy + _BakedNormal_ST.zw;
			o.Normal = BlendNormals( staticSwitch53 , UnpackNormal( tex2D( _BakedNormal, uv_BakedNormal ) ) );
			float4 tex2DNode7 = tex2D( _RockAlbedo, uv_TexCoord16 );
			float4 tex2DNode5 = tex2D( _GrassAlbedo, uv_TexCoord15 );
			float4 lerpResult18 = lerp( tex2DNode7 , tex2DNode5 , tex2DNode9.r);
			float4 tex2DNode1 = tex2D( _SnowAlbedo, uv_TexCoord14 );
			float4 lerpResult19 = lerp( lerpResult18 , tex2DNode1 , tex2DNode9.g);
			float4 lerpResult20 = lerp( tex2DNode7 , tex2DNode5 , tex2DNode9.b);
			#ifdef _ONLYGRASS_ON
				float4 staticSwitch33 = lerpResult20;
			#else
				float4 staticSwitch33 = lerpResult19;
			#endif
			float4 lerpResult21 = lerp( tex2DNode7 , tex2DNode1 , tex2DNode9.a);
			#ifdef _ONLYSNOW_ON
				float4 staticSwitch38 = lerpResult21;
			#else
				float4 staticSwitch38 = lerpResult19;
			#endif
			#ifdef _ONLYSNOW_ON
				float4 staticSwitch50 = staticSwitch38;
			#else
				float4 staticSwitch50 = staticSwitch33;
			#endif
			o.Albedo = staticSwitch50.rgb;
			o.Metallic = 0.0;
			float lerpResult32 = lerp( _RockSmoothnessMin , _RockSmoothnessMax , tex2DNode7.r);
			float lerpResult29 = lerp( _GrassSmoothnessMin , _GrassSmoothnessMax , tex2DNode5.r);
			float lerpResult39 = lerp( lerpResult32 , lerpResult29 , tex2DNode9.r);
			float temp_output_25_0 = ( tex2DNode1.a * _SnowSmoothness );
			float lerpResult42 = lerp( lerpResult39 , temp_output_25_0 , tex2DNode9.g);
			float lerpResult41 = lerp( lerpResult32 , lerpResult29 , tex2DNode9.b);
			#ifdef _ONLYGRASS_ON
				float staticSwitch37 = lerpResult41;
			#else
				float staticSwitch37 = lerpResult42;
			#endif
			float lerpResult40 = lerp( lerpResult32 , temp_output_25_0 , tex2DNode9.a);
			#ifdef _ONLYSNOW_ON
				float staticSwitch47 = lerpResult40;
			#else
				float staticSwitch47 = lerpResult42;
			#endif
			#ifdef _ONLYSNOW_ON
				float staticSwitch52 = staticSwitch47;
			#else
				float staticSwitch52 = staticSwitch37;
			#endif
			o.Smoothness = staticSwitch52;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Standard (Specular setup)"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
618;78;1779;1215;4203.503;1091.05;2.910132;True;False
Node;AmplifyShaderEditor.RangedFloatNode;12;-2693.801,397.5741;Inherit;False;Property;_TilingGrass;Tiling Grass;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2595.295,936.019;Inherit;False;Property;_TilingRock;Tiling Rock;11;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-2469.801,381.5741;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-2387.295,904.019;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-2676.51,-147.5552;Inherit;False;Property;_TilingSnow;Tiling Snow;2;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-2045.941,886.2396;Inherit;True;Property;_RockAlbedo;Rock Albedo;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-2101.295,525.278;Inherit;False;Property;_GrassSmoothnessMax;Grass Smoothness Max;8;0;Create;True;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-2030.365,628.4081;Inherit;True;Property;_GrassNormal;Grass Normal;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-2101.295,442.2786;Inherit;False;Property;_GrassSmoothnessMin;Grass Smoothness Min;7;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-1836.442,1547.739;Inherit;True;Property;_Mask;Mask;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-2028.341,1236.122;Inherit;True;Property;_RockNormal;Rock Normal;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-2026.188,1159.238;Inherit;False;Property;_RockSmoothnessMax;Rock Smoothness Max;13;0;Create;True;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2452.51,-163.5552;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-2120.158,248.327;Inherit;True;Property;_GrassAlbedo;Grass Albedo;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-2026.188,1076.239;Inherit;False;Property;_RockSmoothnessMin;Rock Smoothness Min;12;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;-1812.821,461.9413;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;32;-1737.709,1095.901;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2137.37,-110.507;Inherit;False;Property;_SnowSmoothness;Snow Smoothness;3;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2176.982,-310.8822;Inherit;True;Property;_SnowAlbedo;Snow Albedo;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-2062.895,-14.80888;Inherit;True;Property;_SnowNormal;Snow Normal;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;43;-1337.16,744.317;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;39;-1355.961,112.0489;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-1162.716,884.3311;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;45;-1013.52,1017.459;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;44;-864.0483,1159.768;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;18;-1348.51,-434.2157;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1879.318,-128.0066;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;40;-882.85,527.5;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;48;-613.4928,729.827;Inherit;False;Property;_OnlyGrass;Only Grass;17;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;20;-1024.871,-161.0737;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;-875.3995,-18.76447;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;41;-1032.322,385.191;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-1174.067,-294.2017;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;-1181.518,252.063;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;49;-607.6459,921.3085;Inherit;False;Property;_OnlySnow;Only Snow;16;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;38;-607.4551,-109.0539;Inherit;False;Property;_OnlySnow;Only Snow;17;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;47;-604.2082,369.4276;Inherit;False;Property;_OnlySnow;Only Snow;16;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-244.5302,956.8124;Inherit;True;Property;_BakedNormal;Baked Normal;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;33;-608.412,-302.132;Inherit;False;Property;_OnlyGrass;Only Grass;16;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;53;-310.6953,805.277;Inherit;False;Property;_OnlySnow;Only Snow;16;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;37;-610.0551,177.9461;Inherit;False;Property;_OnlyGrass;Only Grass;16;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;17;121.822,741.8109;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;50;-342.6953,-203.723;Inherit;False;Property;_OnlySnow;Only Snow;16;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;52;-343.6953,271.277;Inherit;False;Property;_OnlySnow;Only Snow;16;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;273.7687,480.5372;Inherit;False;Constant;_Float0;Float 0;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;530.072,415.2474;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/Lordenfel/Mauntains;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Standard (Specular setup);-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;12;0
WireConnection;16;0;13;0
WireConnection;7;1;16;0
WireConnection;6;1;15;0
WireConnection;8;1;16;0
WireConnection;14;0;11;0
WireConnection;5;1;15;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;29;2;5;1
WireConnection;32;0;30;0
WireConnection;32;1;31;0
WireConnection;32;2;7;1
WireConnection;1;1;14;0
WireConnection;2;1;14;0
WireConnection;43;0;8;0
WireConnection;43;1;6;0
WireConnection;43;2;9;1
WireConnection;39;0;32;0
WireConnection;39;1;29;0
WireConnection;39;2;9;1
WireConnection;46;0;43;0
WireConnection;46;1;2;0
WireConnection;46;2;9;2
WireConnection;45;0;8;0
WireConnection;45;1;6;0
WireConnection;45;2;9;3
WireConnection;44;0;8;0
WireConnection;44;1;2;0
WireConnection;44;2;9;4
WireConnection;18;0;7;0
WireConnection;18;1;5;0
WireConnection;18;2;9;1
WireConnection;25;0;1;4
WireConnection;25;1;23;0
WireConnection;40;0;32;0
WireConnection;40;1;25;0
WireConnection;40;2;9;4
WireConnection;48;1;46;0
WireConnection;48;0;45;0
WireConnection;20;0;7;0
WireConnection;20;1;5;0
WireConnection;20;2;9;3
WireConnection;21;0;7;0
WireConnection;21;1;1;0
WireConnection;21;2;9;4
WireConnection;41;0;32;0
WireConnection;41;1;29;0
WireConnection;41;2;9;3
WireConnection;19;0;18;0
WireConnection;19;1;1;0
WireConnection;19;2;9;2
WireConnection;42;0;39;0
WireConnection;42;1;25;0
WireConnection;42;2;9;2
WireConnection;49;1;46;0
WireConnection;49;0;44;0
WireConnection;38;1;19;0
WireConnection;38;0;21;0
WireConnection;47;1;42;0
WireConnection;47;0;40;0
WireConnection;33;1;19;0
WireConnection;33;0;20;0
WireConnection;53;1;48;0
WireConnection;53;0;49;0
WireConnection;37;1;42;0
WireConnection;37;0;41;0
WireConnection;17;0;53;0
WireConnection;17;1;10;0
WireConnection;50;1;33;0
WireConnection;50;0;38;0
WireConnection;52;1;37;0
WireConnection;52;0;47;0
WireConnection;0;0;50;0
WireConnection;0;1;17;0
WireConnection;0;3;54;0
WireConnection;0;4;52;0
ASEEND*/
//CHKSM=184C558FAB87FFA662E18C1C639A2BDACB78D9B3
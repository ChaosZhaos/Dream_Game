// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Lordenfel/Rock"
{
	Properties
	{
		_RockAlbedo("Rock Albedo", 2D) = "white" {}
		_RockNormal("Rock Normal", 2D) = "bump" {}
		_TilingRock("Tiling Rock", Float) = 1
		_RockSmoothnessMin("Rock Smoothness Min", Float) = 0
		_RockSmoothnessMax("Rock Smoothness Max", Float) = 0
		_CrevicesTint("Crevices Tint", Color) = (0.8156863,0.7647059,0.6745098,0)
		_MossAlbedo("Moss Albedo", 2D) = "white" {}
		_MossNormal("Moss Normal", 2D) = "bump" {}
		_TilingMoss("Tiling Moss", Float) = 1
		_MossSmoothnessMin("Moss Smoothness Min", Float) = 0
		_MossSmoothnessMax("Moss Smoothness Max", Float) = 0
		[Toggle(_USEMOSSSLOPE_ON)] _UseMossSlope("Use Moss Slope", Float) = 1
		_SlopeMin("SlopeMin", Float) = -6.1
		_SlopeMax("SlopeMax", Float) = 3.7
		_BakedNormal("Baked Normal", 2D) = "bump" {}
		_BakedMask("Baked Mask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _USEMOSSSLOPE_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _RockNormal;
		uniform float _TilingRock;
		uniform sampler2D _MossNormal;
		uniform float _TilingMoss;
		uniform sampler2D _BakedMask;
		uniform float4 _BakedMask_ST;
		uniform sampler2D _BakedNormal;
		uniform float4 _BakedNormal_ST;
		uniform float _SlopeMin;
		uniform float _SlopeMax;
		uniform sampler2D _RockAlbedo;
		uniform float4 _CrevicesTint;
		uniform sampler2D _MossAlbedo;
		uniform float _RockSmoothnessMin;
		uniform float _RockSmoothnessMax;
		uniform float _MossSmoothnessMin;
		uniform float _MossSmoothnessMax;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_TilingRock).xx;
			float2 uv_TexCoord2 = i.uv_texcoord * temp_cast_0;
			float2 temp_cast_1 = (_TilingMoss).xx;
			float2 uv_TexCoord9 = i.uv_texcoord * temp_cast_1;
			float3 tex2DNode12 = UnpackNormal( tex2D( _MossNormal, uv_TexCoord9 ) );
			float2 uv_BakedMask = i.uv_texcoord * _BakedMask_ST.xy + _BakedMask_ST.zw;
			float4 tex2DNode17 = tex2D( _BakedMask, uv_BakedMask );
			float3 lerpResult23 = lerp( UnpackNormal( tex2D( _RockNormal, uv_TexCoord2 ) ) , tex2DNode12 , tex2DNode17.r);
			float2 uv_BakedNormal = i.uv_texcoord * _BakedNormal_ST.xy + _BakedNormal_ST.zw;
			float3 tex2DNode16 = UnpackNormal( tex2D( _BakedNormal, uv_BakedNormal ) );
			float3 temp_output_22_0 = BlendNormals( lerpResult23 , tex2DNode16 );
			float3 temp_cast_2 = ((WorldNormalVector( i , temp_output_22_0 )).y).xxx;
			float dotResult54 = dot( temp_cast_2 , float3(0,1,0) );
			float lerpResult59 = lerp( _SlopeMin , _SlopeMax , ( ( dotResult54 + 1.0 ) * 0.5 ));
			float temp_output_62_0 = saturate( lerpResult59 );
			float3 lerpResult29 = lerp( lerpResult23 , tex2DNode12 , temp_output_62_0);
			#ifdef _USEMOSSSLOPE_ON
				float3 staticSwitch34 = BlendNormals( tex2DNode16 , lerpResult29 );
			#else
				float3 staticSwitch34 = temp_output_22_0;
			#endif
			o.Normal = staticSwitch34;
			float4 tex2DNode1 = tex2D( _RockAlbedo, uv_TexCoord2 );
			float4 lerpResult20 = lerp( tex2DNode1 , ( _CrevicesTint * tex2DNode1 ) , tex2DNode17.b);
			float4 tex2DNode10 = tex2D( _MossAlbedo, uv_TexCoord9 );
			float4 lerpResult21 = lerp( lerpResult20 , tex2DNode10 , tex2DNode17.r);
			float4 lerpResult28 = lerp( lerpResult21 , tex2DNode10 , temp_output_62_0);
			#ifdef _USEMOSSSLOPE_ON
				float4 staticSwitch33 = lerpResult28;
			#else
				float4 staticSwitch33 = lerpResult21;
			#endif
			o.Albedo = staticSwitch33.rgb;
			o.Metallic = 0.0;
			float lerpResult83 = lerp( _RockSmoothnessMin , _RockSmoothnessMax , tex2DNode1.r);
			float lerpResult87 = lerp( _MossSmoothnessMin , _MossSmoothnessMax , tex2DNode10.r);
			float lerpResult24 = lerp( lerpResult83 , lerpResult87 , tex2DNode17.r);
			float lerpResult30 = lerp( lerpResult24 , lerpResult87 , temp_output_62_0);
			#ifdef _USEMOSSSLOPE_ON
				float staticSwitch35 = lerpResult30;
			#else
				float staticSwitch35 = lerpResult24;
			#endif
			o.Smoothness = staticSwitch35;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Standard (Specular setup)"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
618;78;1779;1215;2086.944;896.8394;1.783161;True;False
Node;AmplifyShaderEditor.RangedFloatNode;15;-2239.971,440.4474;Inherit;False;Property;_TilingMoss;Tiling Moss;8;0;Create;True;0;0;False;0;False;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2172.601,-406.0299;Inherit;False;Property;_TilingRock;Tiling Rock;2;0;Create;True;0;0;False;0;False;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1971.859,-423.1452;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1984.07,424.6197;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-1640.351,188.5005;Inherit;True;Property;_RockNormal;Rock Normal;1;0;Create;True;0;0;False;0;False;-1;None;27a3c4a939c6a214ba695783dc86fd43;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-1378.694,-18.26261;Inherit;True;Property;_BakedMask;Baked Mask;15;0;Create;True;0;0;False;0;False;-1;None;bc6ed41e39a85024a9c3b19fc7d59b4f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-1637.023,399.4604;Inherit;True;Property;_MossNormal;Moss Normal;7;0;Create;True;0;0;False;0;False;-1;None;2cb7ce45d81a20d4099e5ee66c9fead7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;23;-1046.755,321.3262;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;16;-1323.82,530.0248;Inherit;True;Property;_BakedNormal;Baked Normal;14;0;Create;True;0;0;False;0;False;-1;None;9c6d5ba1d3088fb4a9a2f62924cfb234;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;22;-906.0923,150.9524;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;55;-676.584,135.1792;Inherit;False;Constant;_Vector0;Vector 0;17;0;Create;True;0;0;False;0;False;0,1,0;0.5,0.5,0.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;25;-694.2665,-5.894342;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;54;-484.7734,38.65876;Inherit;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1639.838,-450.307;Inherit;True;Property;_RockAlbedo;Rock Albedo;0;0;Create;True;0;0;False;0;False;-1;None;c8d7a9135b097a54f8cf8b35b8aef96b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-1497.585,-671.7124;Inherit;False;Property;_CrevicesTint;Crevices Tint;5;0;Create;True;0;0;False;0;False;0.8156863,0.7647059,0.6745098,0;0.8156863,0.7647059,0.6745098,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;57;-336.0678,38.45712;Inherit;False;ConstantBiasScale;-1;;4;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-283.3952,-123.1943;Inherit;False;Property;_SlopeMin;SlopeMin;12;0;Create;True;0;0;False;0;False;-6.1;-6.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-278.3952,-37.1943;Inherit;False;Property;_SlopeMax;SlopeMax;13;0;Create;True;0;0;False;0;False;3.7;3.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1618.104,1009.761;Inherit;False;Property;_MossSmoothnessMin;Moss Smoothness Min;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-1637.859,-223.4308;Inherit;True;Property;_MossAlbedo;Moss Albedo;6;0;Create;True;0;0;False;0;False;-1;None;158100dae9af7754982e773ea629a376;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;91;-1615.325,808.9987;Inherit;False;Property;_RockSmoothnessMin;Rock Smoothness Min;3;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-1614.104,1102.761;Inherit;False;Property;_MossSmoothnessMax;Moss Smoothness Max;10;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;59;-90.68712,-62.3402;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1611.325,901.9987;Inherit;False;Property;_RockSmoothnessMax;Rock Smoothness Max;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1198.248,-566.7659;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;87;-1236.548,1063.301;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;83;-1245.481,817.8088;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-945.6367,-448.9805;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;62;40.05874,158.4071;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;-921.9474,812.5336;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-552.3785,-331.7404;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;29;203.2637,408.9175;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;30;209.3327,716.9611;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;241.3355,-299.4559;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;82;381.5223,313.6078;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;44;827.7474,122.1532;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;35;639.922,434.0258;Inherit;False;Property;_UseMossSlope;Use Moss Slope;11;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;34;643.8154,227.2968;Inherit;False;Property;_UseMossSlope;Use Moss Slope;12;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;33;643.8354,-53.60251;Inherit;False;Property;_UseMossSlope;Use Moss Slope;11;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1019.388,60.45972;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/Lordenfel/Rock;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Standard (Specular setup);-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;3;0
WireConnection;9;0;15;0
WireConnection;6;1;2;0
WireConnection;12;1;9;0
WireConnection;23;0;6;0
WireConnection;23;1;12;0
WireConnection;23;2;17;1
WireConnection;22;0;23;0
WireConnection;22;1;16;0
WireConnection;25;0;22;0
WireConnection;54;0;25;2
WireConnection;54;1;55;0
WireConnection;1;1;2;0
WireConnection;57;3;54;0
WireConnection;10;1;9;0
WireConnection;59;0;60;0
WireConnection;59;1;61;0
WireConnection;59;2;57;0
WireConnection;19;0;18;0
WireConnection;19;1;1;0
WireConnection;87;0;93;0
WireConnection;87;1;92;0
WireConnection;87;2;10;1
WireConnection;83;0;91;0
WireConnection;83;1;89;0
WireConnection;83;2;1;1
WireConnection;20;0;1;0
WireConnection;20;1;19;0
WireConnection;20;2;17;3
WireConnection;62;0;59;0
WireConnection;24;0;83;0
WireConnection;24;1;87;0
WireConnection;24;2;17;1
WireConnection;21;0;20;0
WireConnection;21;1;10;0
WireConnection;21;2;17;1
WireConnection;29;0;23;0
WireConnection;29;1;12;0
WireConnection;29;2;62;0
WireConnection;30;0;24;0
WireConnection;30;1;87;0
WireConnection;30;2;62;0
WireConnection;28;0;21;0
WireConnection;28;1;10;0
WireConnection;28;2;62;0
WireConnection;82;0;16;0
WireConnection;82;1;29;0
WireConnection;35;1;24;0
WireConnection;35;0;30;0
WireConnection;34;1;22;0
WireConnection;34;0;82;0
WireConnection;33;1;21;0
WireConnection;33;0;28;0
WireConnection;0;0;33;0
WireConnection;0;1;34;0
WireConnection;0;3;44;0
WireConnection;0;4;35;0
ASEEND*/
//CHKSM=0E156235863F485B37882D2C6B56408BCB8148C8
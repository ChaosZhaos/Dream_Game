// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplebrick/FloorBlendHeight"
{
	Properties
	{
		[NoScaleOffset]_BaseColorA("Base Color A", 2D) = "white" {}
		[NoScaleOffset]_NormalA("Normal A", 2D) = "white" {}
		_NormalAScale("Normal A Scale", Range( 0 , 1)) = 1
		[NoScaleOffset]_BaseColorB("BaseColor B", 2D) = "white" {}
		[NoScaleOffset]_NormalB("Normal B", 2D) = "white" {}
		_NormalBScale("Normal B Scale", Range( 0 , 1)) = 1
		_HeightRMasksGBAOA("Height(R) Masks(G+B) AO(A)", 2D) = "white" {}
		_HeightScale("Height Scale", Range( 0 , 0.1)) = 0
		_WaterColor("Water Color", Color) = (0.3161765,0.2515303,0.1697124,0)
		_OcclusionStrength("Occlusion Strength", Range( 0 , 1)) = 0
		_WetEdges("Wet Edges", Range( 0.15 , 3)) = 0.15
		_WaterOpacity("Water Opacity", Range( 0 , 0.2)) = 0
		[HideInInspector]_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform float _NormalBScale;
		uniform sampler2D _NormalB;
		uniform sampler2D _HeightRMasksGBAOA;
		uniform float4 _HeightRMasksGBAOA_ST;
		uniform float _HeightScale;
		uniform float _NormalAScale;
		uniform sampler2D _NormalA;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _WetEdges;
		uniform sampler2D _BaseColorB;
		uniform sampler2D _BaseColorA;
		uniform float4 _WaterColor;
		uniform float _WaterOpacity;
		uniform float _OcclusionStrength;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_HeightRMasksGBAOA = i.uv_texcoord * _HeightRMasksGBAOA_ST.xy + _HeightRMasksGBAOA_ST.zw;
			float4 tex2DNode30 = tex2D( _HeightRMasksGBAOA, uv_HeightRMasksGBAOA );
			float2 paralaxOffset42 = ParallaxOffset( tex2DNode30.r , _HeightScale , i.viewDir );
			float2 temp_output_44_0 = ( i.uv_texcoord + paralaxOffset42 );
			float3 lerpResult7 = lerp( UnpackScaleNormal( tex2D( _NormalB, temp_output_44_0 ) ,_NormalBScale ) , UnpackScaleNormal( tex2D( _NormalA, temp_output_44_0 ) ,_NormalAScale ) , tex2DNode30.g);
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float temp_output_60_0 = ( pow( tex2DNode30.b , _WetEdges ) * 1.0 );
			float3 lerpResult50 = lerp( lerpResult7 , UnpackNormal( tex2D( _TextureSample1, uv_TextureSample1 ) ) , temp_output_60_0);
			o.Normal = lerpResult50;
			float4 tex2DNode2 = tex2D( _BaseColorB, temp_output_44_0 );
			float4 tex2DNode1 = tex2D( _BaseColorA, temp_output_44_0 );
			float4 lerpResult6 = lerp( tex2DNode2 , tex2DNode1 , tex2DNode30.g);
			float4 lerpResult45 = lerp( lerpResult6 , _WaterColor , ( _WaterOpacity + temp_output_60_0 ));
			o.Albedo = lerpResult45.rgb;
			float lerpResult8 = lerp( tex2DNode2.a , tex2DNode1.a , tex2DNode30.g);
			float lerpResult48 = lerp( lerpResult8 , 0.98 , temp_output_60_0);
			o.Smoothness = lerpResult48;
			float lerpResult56 = lerp( 1.0 , tex2DNode30.a , _OcclusionStrength);
			o.Occlusion = lerpResult56;
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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
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
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
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
	Fallback "Diffuse"
}
	
/*ASEBEGIN
Version=15301
0;92;926;786;869.671;-140.6599;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;28;-2012.922,-76.91004;Float;True;Property;_HeightRMasksGBAOA;Height(R) Masks(G+B) AO(A);6;0;Create;True;0;0;False;0;None;None;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;30;-1713.563,-79.08839;Float;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-1722.233,-694.3403;Float;False;Property;_HeightScale;Height Scale;7;0;Create;True;0;0;False;0;0;0.0132;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;41;-1649.947,-535.7743;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexCoordVertexDataNode;43;-1265.887,-748.5494;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;42;-1300.696,-598.1719;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-772.9654,284.1622;Float;False;Property;_WetEdges;Wet Edges;11;0;Create;True;0;0;False;0;0.15;0;0.15;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1113.082,773.4055;Float;False;Property;_NormalAScale;Normal A Scale;2;0;Create;True;0;0;False;0;1;0.592;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;58;-602.0595,160.4382;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1075.325,927.7968;Float;False;Property;_NormalBScale;Normal B Scale;5;0;Create;True;0;0;False;0;1;0.813;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-1032.291,-643.7421;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-75.92218,-58.14456;Float;False;Property;_WaterOpacity;Water Opacity;12;0;Create;True;0;0;False;0;0;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-315.2288,161.3014;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-782.124,-156.6205;Float;True;Property;_BaseColorB;BaseColor B;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;6aa34313375c232459d7de6dfee3a500;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-812.9641,632.8931;Float;True;Property;_NormalA;Normal A;1;1;[NoScaleOffset];Create;True;0;0;False;0;None;5a8b4e10eaa58024c89a5d503d83bed8;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-812.9808,825.3356;Float;True;Property;_NormalB;Normal B;4;1;[NoScaleOffset];Create;True;0;0;False;0;None;2d86f82ddd854624dbefe091f065e909;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-795.21,-367.3024;Float;True;Property;_BaseColorA;Base Color A;0;1;[NoScaleOffset];Create;True;0;0;False;0;None;d2c0802492fd93447b2390f2ee2ba6d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;-192.1861,389.9368;Float;False;Property;_OcclusionStrength;Occlusion Strength;10;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;188.6439,104.1562;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;0.98;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;-189.5996,643.1654;Float;True;Property;_TextureSample1;Texture Sample 1;13;1;[HideInInspector];Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;80.7663,-19.71152;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-348.4275,-292.3393;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;7;-426.7621,763.4731;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;8;-345.7052,-153.6669;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;85.06364,-440.6774;Float;False;Property;_WaterColor;Water Color;9;0;Create;True;0;0;False;0;0.3161765,0.2515303,0.1697124,0;0.3161765,0.2515303,0.1697124,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;48;398.1268,-14.33352;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-267.0843,27.75564;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-563.9111,58.06955;Float;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;False;0;1;0.74;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;56;137.6463,302.1918;Float;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;51;-34.04992,784.5742;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;0.5,0.5,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;50;193.9503,595.328;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;45;351.2898,-177.428;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;857.0855,100.081;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Triplebrick/FloorBlendHeight;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;28;0
WireConnection;42;0;30;1
WireConnection;42;1;40;0
WireConnection;42;2;41;0
WireConnection;58;0;30;3
WireConnection;58;1;61;0
WireConnection;44;0;43;0
WireConnection;44;1;42;0
WireConnection;60;0;58;0
WireConnection;2;1;44;0
WireConnection;3;1;44;0
WireConnection;3;5;31;0
WireConnection;4;1;44;0
WireConnection;4;5;32;0
WireConnection;1;1;44;0
WireConnection;62;0;63;0
WireConnection;62;1;60;0
WireConnection;6;0;2;0
WireConnection;6;1;1;0
WireConnection;6;2;30;2
WireConnection;7;0;4;0
WireConnection;7;1;3;0
WireConnection;7;2;30;2
WireConnection;8;0;2;4
WireConnection;8;1;1;4
WireConnection;8;2;30;2
WireConnection;48;0;8;0
WireConnection;48;1;49;0
WireConnection;48;2;60;0
WireConnection;39;0;8;0
WireConnection;39;1;35;0
WireConnection;56;1;30;4
WireConnection;56;2;57;0
WireConnection;50;0;7;0
WireConnection;50;1;64;0
WireConnection;50;2;60;0
WireConnection;45;0;6;0
WireConnection;45;1;47;0
WireConnection;45;2;62;0
WireConnection;0;0;45;0
WireConnection;0;1;50;0
WireConnection;0;4;48;0
WireConnection;0;5;56;0
ASEEND*/
//CHKSM=C4592E870E64005C1F4BED8B128E4B404B36421D
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplebrick/Cobweb"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_ColorTint("Color Tint", Color) = (1,1,1,0)
		_MoveSpeed("Move Speed", Range( 0 , 3)) = 1
		_Brightness("Brightness", Range( 0 , 1)) = 0
		_Transparency("Transparency", Range( 0.01 , 8)) = 0.01
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float eyeDepth;
		};

		uniform sampler2D _Texture;
		uniform float _MoveSpeed;
		uniform float4 _Texture_ST;
		uniform float4 _ColorTint;
		uniform float _Brightness;
		uniform float _Transparency;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_MoveSpeed).xx;
			float2 panner6 = ( ( _Time.x * 0.7 ) * temp_cast_0 + v.texcoord.xy);
			float temp_output_15_0 = ( tex2Dlod( _Texture, float4( panner6, 0, 0.0) ).a + -0.5 );
			float4 appendResult8 = (float4(( temp_output_15_0 * 0.4 ) , 0.0 , ( temp_output_15_0 * 1.0 ) , 0.0));
			float2 uv_Texture = v.texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode1 = tex2Dlod( _Texture, float4( uv_Texture, 0, 0.0) );
			v.vertex.xyz += ( appendResult8 * tex2DNode1.g ).xyz;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_2_0 = _ColorTint;
			o.Albedo = temp_output_2_0.rgb;
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode1 = tex2D( _Texture, uv_Texture );
			o.Emission = ( ( _Brightness * _ColorTint ) * tex2DNode1.g ).rgb;
			float cameraDepthFade27 = (( i.eyeDepth -_ProjectionParams.y - 0.0 ) / 3.0);
			float clampResult29 = clamp( ( pow( tex2DNode1.r , _Transparency ) * cameraDepthFade27 ) , 0.0 , 1.0 );
			o.Alpha = clampResult29;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.z = customInputData.eyeDepth;
				o.worldPos = worldPos;
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
				surfIN.eyeDepth = IN.customPack1.z;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	
}
/*ASEBEGIN
Version=15301
8;100;1201;689;2096.597;346.7951;2.102386;True;False
Node;AmplifyShaderEditor.TimeNode;7;-1937.907,503.6376;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-2066.487,453.7913;Float;False;Property;_MoveSpeed;Move Speed;2;0;Create;True;0;0;False;0;1;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-2025.377,306.9205;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1682.33,520.3433;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;-1645.871,323.3414;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;2,2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1705.934,0.2889171;Float;True;Property;_Texture;Texture;0;0;Create;True;0;0;False;0;None;0f1aee15dccc793468f1fc271468f7a5;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;4;-1400.115,289.4124;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1279.149,39.66022;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-1070.074,262.9664;Float;False;Property;_Transparency;Transparency;4;0;Create;True;0;0;False;0;0.01;0.847;0.01;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1143.859,522.767;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1216.091,-186.6347;Float;False;Property;_Brightness;Brightness;3;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;23;-746.074,161.9665;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;27;-432.8564,841.6417;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;3;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-934.1073,596.3801;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-958.4908,392.1115;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-980.4074,-474.9346;Float;False;Property;_ColorTint;Color Tint;1;0;Create;True;0;0;False;0;1,1,1,0;0.7647059,0.7647059,0.7647059,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-327.9954,433.4771;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-890.5909,-77.23472;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-773.9353,483.3391;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;29;-92.10693,585.4865;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-612.69,264.6313;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-715.074,48.96648;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Triplebrick/Cobweb;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;7;1
WireConnection;6;0;5;0
WireConnection;6;2;19;0
WireConnection;6;1;12;0
WireConnection;4;0;3;0
WireConnection;4;1;6;0
WireConnection;1;0;3;0
WireConnection;15;0;4;4
WireConnection;23;0;1;1
WireConnection;23;1;24;0
WireConnection;9;0;15;0
WireConnection;10;0;15;0
WireConnection;28;0;23;0
WireConnection;28;1;27;0
WireConnection;20;0;21;0
WireConnection;20;1;2;0
WireConnection;8;0;10;0
WireConnection;8;2;9;0
WireConnection;29;0;28;0
WireConnection;13;0;8;0
WireConnection;13;1;1;2
WireConnection;22;0;20;0
WireConnection;22;1;1;2
WireConnection;0;0;2;0
WireConnection;0;2;22;0
WireConnection;0;9;29;0
WireConnection;0;11;13;0
ASEEND*/
//CHKSM=DA04023B6A5D391A766A26D56378934E43EBE9CD